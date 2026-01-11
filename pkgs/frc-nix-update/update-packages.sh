#!/usr/bin/env bash
set -euo pipefail

# FRC Nix Package Updater
# Similar to nix-update, automatically updates package versions and hashes

# Set defaults if not already set by wrapper
REPO_ROOT="${REPO_ROOT:-$(pwd)}"
DRY_RUN=false
PACKAGES=()
VERBOSE=false

WPILIB_BRANCH="release"
WPILIB_SKIP_BETA_ALPHA=true

usage() {
    cat << EOF
Usage: $0 [OPTIONS] [PACKAGE...]

Update FRC Nix packages to their latest versions.

OPTIONS:
    --dry-run       Show what would be updated without making changes
    --verbose       Show detailed output
    --help          Show this help message

EXAMPLES:
    $0                          # Update all packages
    $0 --dry-run                # Show what would be updated
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

get_wpilib_versions() {
    curl -s "https://frcmaven.wpi.edu/artifactory/api/storage/${WPILIB_BRANCH}/edu/wpi/first/wpilibj/wpilibj-java" \
        | jq -r '.children[] | select(.folder == true) | .uri' \
        | sed 's|^/||; s|/$||' \
        | sort -V
}

# Get latest WPILib version
get_wpilib_latest() {
    if [[ $WPILIB_SKIP_BETA_ALPHA == true ]]; then
        get_wpilib_versions | grep -v '\-[alpha|beta]' | tail -1
    else
        get_wpilib_versions | tail -1
    fi
}

# Extract current version from Nix file
get_current_version() {
    local file="$1"
    # Try different version patterns
    if [[ "$file" == *"/wpilib/"* && ! "$file" == *"/default.nix" ]]; then
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

# Fetch hashes for GitHub releases
fetch_github_hashes() {
    local tool="$1"
    local version="$2"

    case "$tool" in
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
            local url="https://github.com/Gold872/elastic-dashboard/releases/download/v${version}/Elastic-Linux.zip"
            local hash
            hash=$(fetch_url_hash "$url")
            echo "hash = \"$hash\";"
            ;;
        "PathPlanner")
            local output hash
            if ! output=$(nix-prefetch-git "https://github.com/mjansen4857/pathplanner" "v${version}") || [ -z "$output" ]; then
                echo "Error: nix-prefetch-git failed for PathPlanner v${version}" >&2
                return 1
            fi
            hash=$(echo "$output" | jq -r '.hash')
            echo "hash = \"$hash\";"
            ;;
    esac
}

# Fetch hashes for WPILib Maven artifacts
fetch_wpilib_hashes() {
    local tool="$1"
    local version="$2"

    local program_url="https://frcmaven.wpi.edu/artifactory/api/storage/${WPILIB_BRANCH}/edu/wpi/first/tools/${tool}/${version}"
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

        local file_url="https://frcmaven.wpi.edu/artifactory/api/storage/${WPILIB_BRANCH}/edu/wpi/first/tools/${tool}/${version}${file_uri}"
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
        if ! (cd "$REPO_ROOT" && nix fmt "$file" 2>/dev/null); then
            echo "Warning: nix fmt failed for $file" >&2
        fi
    fi
}

update_hashes() {
    local file="$1"
    local tool="$2"
    local version="$3"
    local type="$4"

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
            hash_output=$(fetch_wpilib_hashes "$tool" "$version" "$WPILIB_BRANCH")
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
            # Extract just the hash value from 'hash = "sha256-...";'
            hash_value=${hash_output#*\"}
            hash_value=${hash_value%\"*}

            # For Choreo, only update the src hash (first occurrence)
            if [[ "$tool" == "Choreo" ]]; then
                # Use sed with address to update only the first hash occurrence
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
    echo "  $name is up to date ($current_version)"
    return 1  # Not updated
    fi

    echo "  $name: $current_version -> $latest_version"

    update_version "$file" "$latest_version"
    update_hashes "$file" "$tool_name" "$latest_version" "github"
    format_nix_file "$file"

    return 0  # Updated
}

update_wpilib_packages() {
    declare -n wpilib_packages_ref="$1"
    declare -n updated_ref="$2"

    local WPILIB_FILE="${REPO_ROOT}/pkgs/wpilib/default.nix"

    log "Checking WPILib..."

    local current_version
    current_version=$(get_current_version "$WPILIB_FILE")
    current_version=$(echo "$current_version" | head -1 | tr -d '[:space:]')

    if [[ -z "$current_version" ]]; then
        error "Could not find current WPILib version"
    fi

    local latest_version
    latest_version=$(get_wpilib_latest "release")
    latest_version=$(echo "$latest_version" | tr -d '[:space:]')

    if [[ "$current_version" == "$latest_version" ]]; then
        echo "  WPILib is up to date ($current_version)"
        return 1  # Not updated
    fi

    # Update WPILib default.nix version
    update_version "$WPILIB_FILE" "$latest_version"

    for package_name in "${!wpilib_packages_ref[@]}"; do
        local tool_name="${wpilib_packages_ref[${package_name}]}"
        local file="${REPO_ROOT}/pkgs/wpilib/${package_name}.nix"

        if [[ -f "$file" ]]; then
            echo "  $package_name: $current_version -> $latest_version"

            # Determine if this is a Java or native tool
            local tool_type="native"
            if grep -q "buildJavaTool" "$file"; then
                tool_type="java"
            fi

            # Update hashes if the file contains artifactHashes
            if grep -q "artifactHashes" "$file"; then
                update_hashes "$file" "$tool_name" "$latest_version" "$tool_type" "release"
            fi

            updated_ref+=("$package_name")
        fi
    done

    return 0  # Updated
}

# Discover and update all packages
update_all_packages() {
    local updated=()

    # GitHub packages
    declare -A github_packages=(
        ["advantagescope"]="Mechanical-Advantage/AdvantageScope:pkgs/advantagescope/default.nix:AdvantageScope"
        ["choreo"]="SleipnirGroup/Choreo:pkgs/choreo/default.nix:Choreo"
        ["elastic-dashboard"]="Gold872/elastic-dashboard:pkgs/elastic-dashboard/default.nix:Elastic"
        ["pathplanner"]="mjansen4857/pathplanner:pkgs/pathplanner/default.nix:PathPlanner"
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
    # shellcheck disable=SC2034
    # ^^ We do some weird stuff with -n
    #    in update_wpilib_packages to pass this by "reference"
    declare -A wpilib_packages=(
        ["glass"]="Glass"
        ["datalogtool"]="DataLogTool"
        ["outlineviewer"]="OutlineViewer"
        ["pathweaver"]="PathWeaver"
        ["roborioteamnumbersetter"]="roboRIOTeamNumberSetter"
        ["robotbuilder"]="RobotBuilder"
        ["shuffleboard"]="Shuffleboard"
        ["smartdashboard"]="SmartDashboard"
        ["sysid"]="SysId"
        ["wpical"]="wpical"
    )

    update_wpilib_packages "wpilib_packages" "updated"

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

    for cmd in curl jq sed awk nix-prefetch-git nix; do
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

    log "Formatting"
    nix fmt "$REPO_ROOT" >/dev/null
}

main "$@"
