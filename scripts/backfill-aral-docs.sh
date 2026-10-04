#!/usr/bin/env bash
# Generates Dokka HTML docs for every aral tag where the build succeeds,
# then copies the output into static/doc/aral/<major>.<minor>/ in this repo.
# Later patch releases overwrite earlier ones, so the folder always ends up
# with the docs for the most recent patch in that minor line.
# Each build receives all previously generated doc sets as olderVersionsDir,
# so the version dropdown accumulates across tags.
#
# The build configuration (including the versioning plugin) always comes from
# the cloned branch HEAD. Only aral/src is restored per tag so that the
# versioning plugin is available for all historical builds.
#
# Requirements: JDK 21, git
# Usage: run from the root of csanfilippo.github.io
#   ./scripts/backfill-aral-docs.sh              # clones main
#   ./scripts/backfill-aral-docs.sh my-branch    # clones a specific branch

set -uo pipefail

ARAL_BRANCH="${1:-main}"
SITE_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SITE_DOC_DIR="$SITE_ROOT/static/doc/aral"
ARAL_REPO="https://github.com/csanfilippo/aral.git"
DOKKA_COMMIT="0facb6c60d54f41330fbca956d3a4ab0abb04955"
WORK_DIR=$(mktemp -d)
VERSIONS_ARCHIVE="$WORK_DIR/versions_archive"

# Resolve ANDROID_HOME if not already set
if [ -z "${ANDROID_HOME:-}" ]; then
    for candidate in \
        "$HOME/Library/Android/sdk" \
        "$HOME/Android/Sdk" \
        "/usr/local/lib/android/sdk"; \
    do
        if [ -d "$candidate" ]; then
            export ANDROID_HOME="$candidate"
            break
        fi
    done
fi
if [ -z "${ANDROID_HOME:-}" ]; then
    echo "Error: Android SDK not found. Set ANDROID_HOME and retry."
    exit 1
fi
echo "Using Android SDK at $ANDROID_HOME"

cleanup() { rm -rf "$WORK_DIR"; }
trap cleanup EXIT

mkdir -p "$VERSIONS_ARCHIVE"

echo "Cloning aral ($ARAL_BRANCH) into $WORK_DIR ..."
git clone --quiet --branch "$ARAL_BRANCH" "$ARAL_REPO" "$WORK_DIR/aral"
cd "$WORK_DIR/aral"

tags=$(git tag --sort=version:refname)
if [ -z "$tags" ]; then
    echo "No tags found — nothing to do."
    exit 0
fi

for tag in $tags; do
    major=$(echo "$tag" | cut -d. -f1)
    minor=$(echo "$tag" | cut -d. -f2)
    doc_version="${major}.${minor}"
    target="$SITE_DOC_DIR/${doc_version}"

    printf "%-20s → %s  " "$tag" "$doc_version"

    if ! git merge-base --is-ancestor "$DOKKA_COMMIT" "$tag" 2>/dev/null; then
        echo "SKIP (predates Dokka)"
        continue
    fi

    # Restore only the library source at this tag; keep the build config
    # from the branch HEAD so the versioning plugin is always present.
    git checkout --quiet "$tag" -- aral/src
    git clean -fdxq -- aral/build 2>/dev/null || true

    built=false
    for task in ":aral:dokkaGenerateHtml" "dokkaGenerateHtml"; do
        if ./gradlew "$task" \
            --no-daemon --no-configuration-cache -q \
            -PdokkaVersion="${doc_version}" \
            -PdokkaOlderVersionsDir="$VERSIONS_ARCHIVE" \
            2>/dev/null; then
            built=true
            break
        fi
    done

    # Restore aral/src to branch HEAD before next iteration.
    git checkout --quiet HEAD -- aral/src

    if ! $built; then
        echo "SKIP (build failed)"
        ./gradlew clean --no-daemon -q 2>/dev/null || true
        continue
    fi

    dokka_out=""
    for candidate in \
        "aral/build/dokka/html" \
        "build/dokka/html"; \
    do
        if [ -d "$candidate" ] && [ -n "$(ls -A "$candidate" 2>/dev/null)" ]; then
            dokka_out="$candidate"
            break
        fi
    done

    if [ -z "$dokka_out" ]; then
        echo "SKIP (no output found)"
        ./gradlew clean --no-daemon -q 2>/dev/null || true
        continue
    fi

    # Update the versions archive so subsequent builds see this minor line.
    rm -rf "$VERSIONS_ARCHIVE/${doc_version}"
    mkdir -p "$VERSIONS_ARCHIVE/${doc_version}"
    cp -r "$dokka_out/." "$VERSIONS_ARCHIVE/${doc_version}/"

    # Copy to the site.
    rm -rf "$target"
    mkdir -p "$target"
    cp -r "$dokka_out/." "$target/"
    echo "OK  ($dokka_out)"

    ./gradlew clean --no-daemon -q 2>/dev/null || true
done

echo ""
echo "Done. Review changes in static/doc/aral/ then commit."
