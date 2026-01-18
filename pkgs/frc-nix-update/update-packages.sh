#!/usr/bin/env bash
set -euo pipefail

# FRC Nix Package Updater
# Similar to nix-update, automatically updates package versions and hashes

# Set defaults if not already set by wrapper
REPO_ROOT="${REPO_ROOT:-$(pwd)}"
DRY_RUN=false
PACKAGES=()
VERBOSE=false
FORCE=false

usage() {
    cat << EOF
Usage: $0 [OPTIONS] [PACKAGE...]

Update FRC Nix packages to their latest versions.

OPTIONS:
    --dry-run       Show what would be updated without making changes
    --force         Force refetch hashes even if version hasn't changed
    --verbose       Show detailed output
    --help          Show this help message

EXAMPLES:
    $0                          # Update all packages
    $0 --dry-run                # Show what would be updated
    $0 --force choreo           # Force refetch hashes for choreo
    $0 choreo advantagescope    # Update specific packages
EOF
}

log() {
    echo "==> $*" >&2
}

verbose() {
    if [[ "$VERBOSE" == "true" ]]; then
        echo "    $*" >&2
    fi
}

error() {
    echo "ERROR: $*" >&2
    exit 1
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --force)
            FORCE=true
            shift
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        --help)
            usage
            exit 0
            ;;
        -*)
            error "Unknown option: $1"
            ;;
        *)
            PACKAGES+=("$1")
            shift
            ;;
    esac
done

# Get latest GitHub release version
get_github_latest() {
    local repo="$1"
    curl -s "https://api.github.com/repos/$repo/releases/latest" | \
        jq -r '.tag_name' | sed 's/^v//'
}

# Get latest WPILib version
get_wpilib_latest() {
    local branch="${1:-release}"
    verbose "Fetching latest WPILib version from Maven..."
    local latest
    latest=$(curl -s "https://frcmaven.wpi.edu/artifactory/api/storage/$branch/edu/wpi/first/wpilibj/wpilibj-java" | \
        jq -r '.children[] | select(.folder == true) | .uri' | \
        sed 's|^/||; s|/$||' | \
        grep -v 'beta\|alpha\|rc' | \
        sort -V | \
        tail -1)
    verbose "Latest WPILib version: $latest"
    echo "$latest"
}

# Compare two versions using semantic versioning
# Returns 0 if $1 < $2, 1 otherwise
version_less_than() {
    local ver1="$1"
    local ver2="$2"
    # Use sort -V to compare versions semantically
    local sorted
    sorted=$(printf '%s\n%s\n' "$ver1" "$ver2" | sort -V | head -1)
    [[ "$sorted" == "$ver1" && "$ver1" != "$ver2" ]]
}

# Extract current version from Nix file
get_current_version() {
    local file="$1"
    # Try different version patterns
    if [[ "$file" == *"/wpilib/"* && ! "$file" == *"/default.nix" && ! "$file" == *"/vscode-extension.nix" ]]; then
        # WPILib packages that inherit version from allwpilibSources
        grep -o 'version = "[^"]*"' "$REPO_ROOT/pkgs/wpilib/default.nix" | sed 's/version = "//; s/"//' || echo ""
    else
        # Regular packages with explicit version
        grep -o 'version = "[^"]*"' "$file" | sed 's/version = "//; s/"//' || echo ""
    fi
}

# Update version in Nix file
update_version() {
    local file="$1"
    local new_version="$2"

    if [[ "$DRY_RUN" == "true" ]]; then
        return 0
    fi

    # Only update files that don't inherit version from a parent scope
    # Check for patterns like "inherit (lib) version" or "inherit version" in function parameters
    if ! grep -q 'inherit.*(.*).*version\|inherit.*version.*from\|version.*=.*inherit' "$file"; then
        sed -i "s|version = \"[^\"]*\"|version = \"$new_version\"|" "$file"
    fi
}

# Fetch hash for a URL by downloading and computing SHA256
fetch_url_hash() {
    local url="$1"
    verbose "Fetching hash for $url"
    # Use a more robust method to ensure we get the complete hash
    local hash_hex
    hash_hex=$(curl -sL "$url" | sha256sum | cut -d ' ' -f1 | tr -d '\n')
    # Convert to SRI format, ensuring no line breaks
    # Convert to SRI format using hex_to_sri
    hex_to_sri "$hash_hex"
}

# Convert hex SHA256 to SRI format
hex_to_sri() {
    local hex="$1"
    nix-hash --type sha256 --to-sri "$hex" | tr -d '\n'
}

# Update allwpilibSources hash in WPILib default.nix
update_allwpilib_sources_hash() {
    local version="$1"
    local file="$REPO_ROOT/pkgs/wpilib/default.nix"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        return 0
    fi
    
    verbose "Fetching allwpilibSources hash for version $version"
    
    # Fetch the GitHub tarball and compute its hash
    local url="https://github.com/wpilibsuite/allwpilib/archive/refs/tags/v${version}.tar.gz"
    local hash
    hash=$(nix-prefetch-url --unpack "$url" 2>/dev/null | tail -1)
    
    if [[ -z "$hash" ]]; then
        error "Failed to fetch allwpilibSources hash for version $version"
    fi
    
    # Convert to SRI format
    hash=$(nix hash convert --hash-algo sha256 --to sri "$hash" | tr -d '\n')
    
    verbose "Got hash: $hash"
    
    # Update the hash in default.nix
    sed -i "s|hash = \"sha256-[^\"]*\"|hash = \"$hash\"|" "$file"
}

# Fetch hashes for GitHub releases
fetch_github_hashes() {
    local tool="$1"
    local version="$2"

    case "$tool" in
        "vscode-wpilib")
            local url="https://github.com/wpilibsuite/vscode-wpilib/releases/download/v${version}/vscode-wpilib-${version}.vsix"
            local hash
            hash=$(fetch_url_hash "$url")
            echo "hash = \"$hash\";"
            ;;
        "Choreo")
            local url="https://github.com/SleipnirGroup/Choreo/releases/download/v${version}/Choreo-v${version}-Linux-x86_64-standalone.zip"
            local hash
            hash=$(fetch_url_hash "$url")
            echo "hash = \"$hash\";"
            ;;
        "AdvantageScope")
            local url_x64="https://github.com/Mechanical-Advantage/AdvantageScope/releases/download/v${version}/advantagescope-linux-x64-v${version}.AppImage"
            local url_arm64="https://github.com/Mechanical-Advantage/AdvantageScope/releases/download/v${version}/advantagescope-linux-arm64-v${version}.AppImage"
            local hash_x64 hash_arm64
            hash_x64=$(fetch_url_hash "$url_x64")
            hash_arm64=$(fetch_url_hash "$url_arm64")
            echo "x86_64-linux = \"$hash_x64\";"
            echo "aarch64-linux = \"$hash_arm64\";"
            ;;
        "Elastic")
            local url="https://github.com/Gold872/elastic_dashboard/releases/download/v${version}/Elastic-Linux.zip"
            local hash
            hash=$(fetch_url_hash "$url")
            echo "hash = \"$hash\";"
            ;;
        "PathPlanner")
            local hash
            # Fetch the GitHub tarball and compute its hash
            local url="https://github.com/mjansen4857/pathplanner/archive/refs/tags/v${version}.tar.gz"
            hash=$(nix-prefetch-url --unpack "$url" 2>/dev/null | tail -1)
            
            if [[ -z "$hash" ]]; then
                echo "Error: Failed to fetch hash for PathPlanner v${version}" >&2
                return 1
            fi
            
            # Convert to SRI format
            hash=$(nix hash convert --hash-algo sha256 --to sri "$hash" | tr -d '\n')
            echo "hash = \"$hash\";"
            ;;
    esac
}

# Fetch hashes for WPILib Maven artifacts
fetch_wpilib_hashes() {
    local tool="$1"
    local version="$2"
    local branch="${3:-release}"

    local program_url="https://frcmaven.wpi.edu/artifactory/api/storage/${branch}/edu/wpi/first/tools/${tool}/${version}"
    local program_response
    program_response=$(curl -s "$program_url")

    if ! echo "$program_response" | jq -e '.children' >/dev/null 2>&1; then
        error "Failed to fetch WPILib artifacts for $tool $version"
    fi

    # Process each file
    while IFS= read -r file_uri; do
        [[ "$file_uri" == *.pom ]] && continue
        [[ "$file_uri" == *windows* ]] && continue
        [[ "$file_uri" == *win* ]] && continue

        local file_url="https://frcmaven.wpi.edu/artifactory/api/storage/${branch}/edu/wpi/first/tools/${tool}/${version}${file_uri}"
        local file_response
        file_response=$(curl -s "$file_url")

        local sha256_hex
        sha256_hex=$(echo "$file_response" | jq -r '.checksums.sha256')
        [[ "$sha256_hex" == "null" ]] && continue

        # Extract platform name
        local platform
        if [[ "$file_uri" == *"linuxx86-64"* ]]; then
            platform="linuxx86-64"
        elif [[ "$tool" == "RobotBuilder" ]]; then
            platform="all"
        else
            # Extract platform from filename like "Tool-version-platform.ext"
            local basename="${file_uri##*/}"  # Remove path
            basename="${basename%.*}"         # Remove extension
            platform="${basename##*-}"       # Get last part after dash
        fi

        local hash
        hash=$(hex_to_sri "$sha256_hex")
        echo "  $platform = \"$hash\";"

    done < <(echo "$program_response" | jq -r '.children[] | select(.folder == false) | .uri') | sort
}

# Format a Nix file using nix fmt
format_nix_file() {
    local file="$1"

    if [[ "$DRY_RUN" == "true" ]]; then
        return 0
    fi

    verbose "Formatting $file with nix fmt"

    # Run nix fmt on the file, but only if it exists and is a .nix file
    if [[ -f "$file" && "$file" == *.nix ]]; then
        # Change to repo root to ensure nix fmt can find flake.nix
        if ! (cd "$REPO_ROOT" && nix fmt "$file" >/dev/null 2>&1); then
            echo "Warning: nix fmt failed for $file" >&2
        fi
    fi
}
update_hashes() {
    local file="$1"
    local tool="$2"
    local version="$3"
    local type="$4"
    local branch="${5:-}"

    if [[ "$DRY_RUN" == "true" ]]; then
        return 0
    fi

    verbose "Fetching hashes for $tool $version"

    # Fetch hashes based on type
    local hash_output
    case "$type" in
        "github")
            hash_output=$(fetch_github_hashes "$tool" "$version")
            ;;
        "native"|"java")
            hash_output=$(fetch_wpilib_hashes "$tool" "$version" "$branch")
            ;;
        *)
            error "Unknown hash type: $type"
            ;;
    esac

    if [[ -z "$hash_output" ]]; then
        error "Failed to fetch hashes for $tool $version"
    fi

    # Update the file based on hash format
    if echo "$hash_output" | grep -q "="; then
        if [[ $(echo "$hash_output" | wc -l) -gt 1 ]]; then
            # Multiple hashes - check if this is AdvantageScope or artifactHashes format
            if [[ "$tool" == "AdvantageScope" ]]; then
                # AdvantageScope uses individual hash lines within src block
                while IFS= read -r hash_line; do
                    if [[ "$hash_line" =~ ^([^=]+)\ =\ \"([^\"]+)\"\;$ ]]; then
                        local platform="${BASH_REMATCH[1]}"
                        local hash_value="${BASH_REMATCH[2]}"
                        # Replace hash within the specific platform's fetchurl block
                        sed -i "/$platform = fetchurl {/,/};/{s|hash = \"[^\"]*\"|hash = \"$hash_value\"|}" "$file"
                    fi
                done <<< "$hash_output"
            else
                # Other packages use artifactHashes block
                local temp_file
                temp_file=$(mktemp)
                echo "artifactHashes = {" > "$temp_file"
                echo "$hash_output" >> "$temp_file"
                echo "};" >> "$temp_file"

                awk '
                /artifactHashes = \{/ {
                    system("cat '"$temp_file"'")
                    skip=1
                    next
                }
                skip && /^\s*\};/ {
                    skip=0
                    next
                }
                !skip { print }
                ' "$file" > "$file.tmp" && mv "$file.tmp" "$file"

                rm -f "$temp_file"
            fi
        else
            # Single hash - replace hash line
            local hash_value
            # Extract just the hash value from 'platform = "sha256-...";' or 'hash = "sha256-...";'
            if [[ "$hash_output" =~ \"([^\"]+)\" ]]; then
                hash_value="${BASH_REMATCH[1]}"
            else
                hash_value=${hash_output#*\"}
                hash_value=${hash_value%\"*}
            fi

            # For Choreo, only update the src hash (first occurrence)
            if [[ "$tool" == "Choreo" ]]; then
                # Use sed with address to update only the first hash occurrence
                sed -i '0,/hash = "[^"]*"/{s|hash = "[^"]*"|hash = "'"${hash_value}"'"|;}' "$file"
            # For RobotBuilder, update the fetchurl hash
            elif [[ "$tool" == "RobotBuilder" ]]; then
                sed -i '0,/hash = "[^"]*"/{s|hash = "[^"]*"|hash = "'"${hash_value}"'"|;}' "$file"
            else
                # Use | as delimiter to avoid issues with / in hash
                sed -i "s|hash = \"[^\"]*\"|hash = \"${hash_value}\"|" "$file"
            fi
        fi
    fi
}

# Check if package is marked as broken
is_package_broken() {
    local file="$1"
    grep -q 'broken = true' "$file"
}

# Update a GitHub-based package
update_github_package() {
    local name="$1"
    local repo="$2"
    local file="$3"
    local tool_name="$4"

    log "Checking $name..."

    # Skip if package is marked as broken
    if is_package_broken "$file"; then
        echo "  $name is marked as broken, skipping"
        return 1  # Not updated
    fi

    local current_version
    current_version=$(get_current_version "$file")

    if [[ -z "$current_version" ]]; then
        error "Could not find current version in $file"
    fi

    local latest_version
    latest_version=$(get_github_latest "$repo")

    if [[ "$current_version" == "$latest_version" ]]; then
        if [[ "$FORCE" == "true" ]]; then
            echo "  $name: force refetching hashes ($current_version)"
            update_hashes "$file" "$tool_name" "$current_version" "github"
            format_nix_file "$file"
            return 0  # Updated
        fi
        echo "  $name is up to date ($current_version)"
        return 1  # Not updated
    fi

    echo "  $name: $current_version -> $latest_version"

    update_version "$file" "$latest_version"
    update_hashes "$file" "$tool_name" "$latest_version" "github"
    format_nix_file "$file"

    return 0  # Updated
}

# Update a WPILib package
update_wpilib_package() {
    local name="$1"
    local file="$2"
    local tool_name="$3"
    local version_already_checked="${4:-false}"
    local new_version="${5:-}"

    verbose "Checking $name..."

    # Skip if package is marked as broken
    if is_package_broken "$file"; then
        echo "  $name is marked as broken, skipping"
        return 1  # Not updated
    fi

    # If version wasn't checked centrally, check it now
    if [[ "$version_already_checked" != "true" ]]; then
        local current_version
        current_version=$(get_current_version "$REPO_ROOT/pkgs/wpilib/default.nix")
        current_version=$(echo "$current_version" | head -1 | tr -d '[:space:]')

        if [[ -z "$current_version" ]]; then
            error "Could not find current WPILib version"
        fi

        local latest_version
        latest_version=$(get_wpilib_latest "release")
        latest_version=$(echo "$latest_version" | head -1 | tr -d '[:space:]')

        if ! version_less_than "$current_version" "$latest_version"; then
            echo "  $name is up to date ($current_version)"
            return 1  # Not updated
        fi

        new_version="$latest_version"
        echo "  $name: $current_version -> $latest_version"

        # Update WPILib default.nix version
        update_version "$REPO_ROOT/pkgs/wpilib/default.nix" "$new_version"
        format_nix_file "$REPO_ROOT/pkgs/wpilib/default.nix"
    else
        echo "  Updating $name hashes for version $new_version"
    fi

    # Determine if this is a Java or native tool, or vscode extension
    local tool_type="native"
    if [[ "$name" == "vscode-wpilib" ]]; then
        tool_type="github"
    elif grep -q "buildJavaTool" "$file"; then
        tool_type="java"
    fi

    # Update hashes if the file contains artifactHashes or a single hash field
    if grep -q "artifactHashes\|hash = " "$file"; then
        update_hashes "$file" "$tool_name" "$new_version" "$tool_type" "release"
        format_nix_file "$file"
    fi

    return 0  # Updated
}

# Discover and update all packages
update_all_packages() {
    local updated=()

    # GitHub packages
    declare -A github_packages=(
        ["advantagescope"]="Mechanical-Advantage/AdvantageScope:pkgs/advantagescope/default.nix:AdvantageScope"
        ["choreo"]="SleipnirGroup/Choreo:pkgs/choreo/default.nix:Choreo"
        ["elastic-dashboard"]="Gold872/elastic_dashboard:pkgs/elastic-dashboard/default.nix:Elastic"
        ["pathplanner"]="mjansen4857/pathplanner:pkgs/pathplanner/default.nix:PathPlanner"
        ["vscode-wpilib"]="wpilibsuite/vscode-wpilib:pkgs/wpilib/vscode-extension.nix:vscode-wpilib"
    )

    for package in "${!github_packages[@]}"; do
        if [[ ${#PACKAGES[@]} -eq 0 ]] || printf '%s\n' "${PACKAGES[@]}" | grep -Fxq "$package"; then
            IFS=':' read -r repo file tool_name <<< "${github_packages[$package]}"
            if update_github_package "$package" "$repo" "$REPO_ROOT/$file" "$tool_name"; then
                updated+=("$package")
            fi
        fi
    done

    # WPILib packages
    declare -A wpilib_packages=(
        ["glass"]="pkgs/wpilib/glass.nix:Glass"
        ["datalogtool"]="pkgs/wpilib/datalogtool.nix:DataLogTool"
        ["outlineviewer"]="pkgs/wpilib/outlineviewer.nix:OutlineViewer"
        ["pathweaver"]="pkgs/wpilib/pathweaver.nix:PathWeaver"
        ["roborioteamnumbersetter"]="pkgs/wpilib/roborioteamnumbersetter.nix:roboRIOTeamNumberSetter"
        ["robotbuilder"]="pkgs/wpilib/robotbuilder.nix:RobotBuilder"
        ["shuffleboard"]="pkgs/wpilib/shuffleboard.nix:Shuffleboard"
        ["smartdashboard"]="pkgs/wpilib/smartdashboard.nix:SmartDashboard"
        ["sysid"]="pkgs/wpilib/sysid.nix:SysId"
        ["wpical"]="pkgs/wpilib/wpical.nix:wpical"
    )

    # Check WPILib version once for all packages
    local wpilib_needs_update=false
    local wpilib_current_version=""
    local wpilib_latest_version=""
    
    # Determine if any WPILib packages need to be checked
    local check_wpilib=false
    if [[ ${#PACKAGES[@]} -eq 0 ]]; then
        check_wpilib=true
    else
        for package in "${!wpilib_packages[@]}"; do
            if printf '%s\n' "${PACKAGES[@]}" | grep -Fxq "$package"; then
                check_wpilib=true
                break
            fi
        done
    fi

    if [[ "$check_wpilib" == "true" ]]; then
        log "Checking WPILib version..."
        wpilib_current_version=$(get_current_version "$REPO_ROOT/pkgs/wpilib/default.nix")
        wpilib_current_version=$(echo "$wpilib_current_version" | head -1 | tr -d '[:space:]')
        
        if [[ -z "$wpilib_current_version" ]]; then
            error "Could not find current WPILib version"
        fi
        
        wpilib_latest_version=$(get_wpilib_latest "release")
        wpilib_latest_version=$(echo "$wpilib_latest_version" | head -1 | tr -d '[:space:]')
        
        verbose "Current WPILib version: $wpilib_current_version"
        verbose "Latest WPILib version: $wpilib_latest_version"
        
        if version_less_than "$wpilib_current_version" "$wpilib_latest_version"; then
            wpilib_needs_update=true
            log "WPILib update detected: $wpilib_current_version -> $wpilib_latest_version"
            
            # Update default.nix version once
            echo "  Updating WPILib version in default.nix"
            update_version "$REPO_ROOT/pkgs/wpilib/default.nix" "$wpilib_latest_version"
            
            # Update allwpilibSources hash
            echo "  Updating allwpilibSources hash"
            update_allwpilib_sources_hash "$wpilib_latest_version"
            
            format_nix_file "$REPO_ROOT/pkgs/wpilib/default.nix"
        elif [[ "$FORCE" == "true" ]]; then
            wpilib_needs_update=true
            wpilib_latest_version="$wpilib_current_version"
            log "WPILib: force refetching hashes ($wpilib_current_version)"
            
            # Update allwpilibSources hash even when forcing
            echo "  Updating allwpilibSources hash"
            update_allwpilib_sources_hash "$wpilib_latest_version"
            
            format_nix_file "$REPO_ROOT/pkgs/wpilib/default.nix"
        else
            log "WPILib is up to date ($wpilib_current_version)"
        fi
    fi

    # Now update individual WPILib packages
    for package in "${!wpilib_packages[@]}"; do
        if [[ ${#PACKAGES[@]} -eq 0 ]] || printf '%s\n' "${PACKAGES[@]}" | grep -Fxq "$package"; then
            IFS=':' read -r file tool_name <<< "${wpilib_packages[$package]}"
            if [[ -f "$REPO_ROOT/$file" ]]; then
                if [[ "$wpilib_needs_update" == "true" ]]; then
                    # Version already checked and updated, just update hashes
                    if update_wpilib_package "$package" "$REPO_ROOT/$file" "$tool_name" "true" "$wpilib_latest_version"; then
                        updated+=("$package")
                    fi
                elif [[ "$FORCE" == "true" ]]; then
                    # Force refetch hashes even if version hasn't changed
                    echo "  $package: force refetching hashes ($wpilib_current_version)"
                    if update_wpilib_package "$package" "$REPO_ROOT/$file" "$tool_name" "true" "$wpilib_current_version"; then
                        updated+=("$package")
                    fi
                else
                    # Skip - already up to date
                    verbose "  $package is up to date ($wpilib_current_version)"
                fi
            fi
        fi
    done

    # Summary
    if [[ ${#updated[@]} -gt 0 ]]; then
        log "Updated packages: ${updated[*]}"
        if [[ "$DRY_RUN" == "false" ]]; then
            log "Run 'nix flake check' to verify the updates"
        fi
    else
        log "All packages are up to date"
    fi
}

# Check dependencies
check_deps() {
    local missing=()

    for cmd in curl jq sed awk nix; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            missing+=("$cmd")
        fi
    done

    if [[ ${#missing[@]} -gt 0 ]]; then
        error "Missing required dependencies: ${missing[*]}"
    fi
}

main() {
    check_deps

    if [[ "$DRY_RUN" == "true" ]]; then
        log "DRY RUN - no changes will be made"
    fi

    update_all_packages

    nix fmt "$REPO_ROOT" >/dev/null 2>&1
}

main "$@"
