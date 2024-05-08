#!/usr/bin/env nu

# Example Usage: fetch_wpilib_artifact_hashes --version 2024.3.2

def get-artifact-hashes [basePath: string] {
    let folder = (http get $"https://frcmaven.wpi.edu/artifactory/api/storage/($basePath)" | from json)
    let children = (
        $folder.children
            | where not folder
            | get uri
            | each { |it| $"($folder.uri)/($it)" }
            | par-each { |it| (http get $it | from json) }
    )

    let systems = [linuxarm32, linuxarm64, linuxx86-64, linuxx64, osxuniversal, macarm64, macx64];

    let artifacts = (
        $children
            | insert system { |row|
                let candidates = $systems | filter { |system| $row.path | str contains $system }
                if ($candidates | length) > 0 {
                    $candidates | first
                } else {
                    null
                }
            }
            | where system != null
            | insert hash { |row| nix hash to-sri --type sha256 $row.checksums.sha256 | str trim }
    )

    $artifacts
        | each { |it| $'($it.system) = "($it.hash)";' }
        | sort
        | str join "\n"
}

def get-tool-hash [repo: string, tool: string, version: string] {
    get-artifact-hashes $"($repo)/edu/wpi/first/tools/($tool)/($version)"
}

def main [--version: string] {
    for $it in [
        "DataLogTool"
        "Glass"
        "OutlineViewer"
        "PathWeaver"
        "roboRIOTeamNumberSetter"
        # "RobotBuilder" # Robot Builder doesn't follow the same format as everthing else so just do it manually
        "Shuffleboard"
        "SmartDashboard"
        "SysId"] {
        let hashes = (get-tool-hash "release" $it $version)
        print $"($it):\n($hashes)\n"
    }
}
