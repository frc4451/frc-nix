#!/usr/bin/env nu

# Example Usage: fetch_wpilib_artifact_hashes --repo {release,development} --version 2024.3.2
# Would also suggest browsing: https://frcmaven.wpi.edu/ui/repos/tree/ to see how this works

def get-artifact-hashes [basePath: string] {
    let folder = try {
        (http get $"https://frcmaven.wpi.edu/artifactory/api/storage/($basePath)" | from json)
    } catch {
        return $"Not found at ($basePath)"
    }
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
            | insert hash { |row| nix hash convert --hash-algo sha256 --to sri $row.checksums.sha256 | str trim }
    )

    $artifacts
        | each { |it| $'($it.system) = "($it.hash)";' }
        | sort
        | str join "\n"
}

def get-tool-hash [repo: string, tool: string, version: string] {
    get-artifact-hashes $"($repo)/edu/wpi/first/tools/($tool)/($version)"
}

def main [--repo: string, --version: string] {
    for $tool in [
        "DataLogTool"
        "Glass"
        "OutlineViewer"
        "PathWeaver"
        # "RobotBuilder" # Robot Builder doesn't follow the same format as everthing else so just do it manually
        "Shuffleboard"
        "SmartDashboard"
        "SysId"
        "roboRIOTeamNumberSetter"
        "wpical"
        ] {
        let hashes = (get-tool-hash $repo $tool $version)
        print $"($tool):\n($hashes)\n"
    }
    print $"RobotBuilder \(Manual\):
Just let it fail then put in the new one
Available at for reference: https://frcmaven.wpi.edu/artifactory/($repo)/edu/wpi/first/tools/RobotBuilder/"
}
