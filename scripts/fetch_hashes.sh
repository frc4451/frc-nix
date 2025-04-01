#!/usr/bin/env -S nix shell nixpkgs#bun nixpkgs#nix-prefetch-git --command bash

branch="release"
native_version="2025.3.2"
java_version="2025.3.2"

native_tools=(
    "DataLogTool"
    "Glass"
    "OutlineViewer"
    "SysId"
    "roboRIOTeamNumberSetter"
    "wpical"
)

java_tools=(
    "PathWeaver"
    "SmartDashboard"
    "Shuffleboard"
    "RobotBuilder"
)

declare -rA github_tools=(
    ["AdvantageScope"]="4.1.6"
    ["Choreo"]="2025.0.3"
    ["Elastic"]="2025.2.2"
    ["PathPlanner"]="2025.2.2"
    ["allwpilib"]="2025.3.2"
    ["vscode-extension"]="2025.3.2"
    ["wpilibutility"]="2025.3.2"
)

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

for tool in "${native_tools[@]}"; do
    bun "$SCRIPT_DIR/fetch_hashes.ts" --tool "$tool" --branch "$branch" --version "$native_version" --type native
    echo
done

for tool in "${java_tools[@]}"; do
    bun "$SCRIPT_DIR/fetch_hashes.ts" --tool "$tool" --branch "$branch" --version "$java_version" --type java
    echo
done

for tool in "${!github_tools[@]}"; do
    version="${github_tools[$tool]}"
    bun "$SCRIPT_DIR/fetch_hashes.ts" --tool "$tool" --version "$version" --type github
    echo
done
