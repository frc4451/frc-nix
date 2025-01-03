#!/usr/bin/env bb

;;; Wanna explore where the files are?
;;; Take a look at:
;;;   * https://frcmaven.wpi.edu/ui/repos/tree
;;; & * https://frcmaven.wpi.edu/artifactory/api/storage/development/edu/wpi/first/tools/
;;;

(ns fetch-hashes
  (:require
   [babashka.cli :as cli]
   [babashka.http-client :as http]
   [cheshire.core :as json]
   [clojure.java.shell :refer [sh]]
   [clojure.string :as str]))

(defn get-tool-file-tree [tool repo version]
  (-> (http/get (str "https://frcmaven.wpi.edu/artifactory/api/storage/" repo "/edu/wpi/first/tools/" tool "/" version))
      :body
      (json/parse-string true)))

(defn not-folder [object]
  (not (:folder object)))

(defn remove-invalid-tool-children [info]
  (->> info
       :children
       (filter not-folder)))

(defn is-jar-file? [filename]
  (str/ends-with? filename ".jar"))

(defn could-be-native-file? [filename]
  (str/ends-with? filename ".zip"))

(defn get-uri-hash [uri]
  (-> uri
      http/get
      :body
      (json/parse-string true)
      (get-in [:checksums :sha256])))

(defn get-rel-tool-uris [tree is-valid-file?]
  (->> tree
       remove-invalid-tool-children
       (map :uri)
       (filter is-valid-file?)))

(defn get-system-from-relative-uri [tool version rel-uri file-extension]
  (-> rel-uri
      (str/replace-first (str "/" tool "-" version "-") "")
      str/reverse
      (str/replace-first (str/reverse file-extension) "")
      str/reverse))

(defn sha256->nix-sri [sha256]
  (-> (sh "nix" "hash" "convert" "--hash-algo" "sha256" "--to" "sri" sha256)
      :out
      str/trim))

(defn rel-uris->hashes [tool version rel-tool-uris base-uri file-extension]
  ;; reducing like this is probably dumb but meh
  (reduce
   into
   (map
    (fn [rel-uri]
      (let [system (get-system-from-relative-uri tool version rel-uri file-extension)
            sha256-hash (-> (str base-uri rel-uri)
                            get-uri-hash
                            sha256->nix-sri)]
        {system sha256-hash}))
    rel-tool-uris)))

(defn get-tool-hashes [tool version branch tool-type]
  (let [tool-types {:native {:filter-fn could-be-native-file?
                             :extension ".zip"}
                    :java {:filter-fn is-jar-file?
                           :extension ".jar"}}
        tree (get-tool-file-tree tool branch version)
        base-uri (:uri tree)
        filter-fn (get-in tool-types [tool-type :filter-fn])
        file-extension (get-in tool-types [tool-type :extension])
        rel-tool-uris (get-rel-tool-uris tree filter-fn)]
    (rel-uris->hashes tool version rel-tool-uris base-uri file-extension)))

(defn tool-hashes->nix-format [hashes]
  (str
   "{\n"
   (reduce str (map (fn [[k v]] (str "  " k " = " \" v "\";\n")) hashes))
   "};"))

;;; These are just random tests I used during development
;;; I'll leave them here for future reference
(comment
  ;; 2024 Testing
  (get-tool-file-tree "DataLogTool" "2024.3.2" "release")
  (get-tool-file-tree "SmartDashboard" "2024.3.2" "release")
  (get-tool-hashes "DataLogTool" "2024.3.2" "release" :native)
  (get-tool-hashes "SmartDashboard" "2024.3.2" "release" :java)
  (get-system-from-relative-uri "SmartDashboard" "2024.3.2" "/SmartDashboard-2024.3.2-macx64.jar" ".jar")
  ;; RobotBuilder works :tada:, not sure why the key for the output is what it is, meh
  (get-tool-hashes "RobotBuilder" "2024.3.2" "release" :java)
  ;; 2025 Testing, native & java have different versioning styles for whatever reason
  (get-tool-hashes "DataLogTool" "2025.1.1-beta-3-5-g156bd71" "development" :native)
  (get-tool-hashes "SmartDashboard" "2025.1.1-beta-3" "development" :java)
  (println (tool-hashes->nix-format (get-tool-hashes "SmartDashboard" "development" "2025.1.1-beta-3" :java))))

;;; Stable Example
;;; fetch_hashes.clj --tool DataLogTool --branch release --version 2024.3.2 --type native
;;; fetch_hashes.clj --tool SmartDashboard --branch release --version 2024.3.2 --type java
;;; ...

;;; Beta Example
;;; fetch_hashes.clj --tool DataLogTool --branch development --version 2025.1.1-beta-3-5-g156bd71 --type native
;;; fetch_hashes.clj --tool SmartDashboard --branch development --version 2025.1.1-beta3 --type java
;;; ...

(defn -main []
  (let [parsed-opts (cli/parse-opts *command-line-args*
                                    {:spec {:tool {}
                                            :version {}
                                            :branch {:default "release"}
                                            :type {}}
                                     :require [:tool :version :branch :type]
                                     :restrict [:tool :version :branch :type]})
        tool (:tool parsed-opts)
        version (:version parsed-opts)
        branch (:branch parsed-opts)
        tool-type (keyword (:type parsed-opts))]
    (->> (get-tool-hashes tool version branch tool-type)
         tool-hashes->nix-format
         (str tool " (" version "):\nartifactHashes = ")
         println)))

(-main) ; For babashka in script mode
