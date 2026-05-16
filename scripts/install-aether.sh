#!/bin/sh
set -eu

REPO="kasissnu/aether"
APP_NAME="Aether"
INSTALL_DIR="/Applications"
APP_PATH="$INSTALL_DIR/$APP_NAME.app"

info() {
    printf '%s\n' "$*"
}

fail() {
    printf 'Error: %s\n' "$*" >&2
    exit 1
}

need_command() {
    command -v "$1" >/dev/null 2>&1 || fail "$1 is required."
}

run_privileged() {
    if [ -w "$INSTALL_DIR" ]; then
        "$@"
    else
        sudo "$@"
    fi
}

need_command curl
need_command awk
need_command ditto

TMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/aether-install.XXXXXX")
trap 'rm -rf "$TMP_DIR"' EXIT INT TERM

RELEASE_JSON="$TMP_DIR/release.json"
ZIP_PATH="$TMP_DIR/aether.zip"
EXTRACT_DIR="$TMP_DIR/extract"

info "Fetching latest Aether release..."
curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" -o "$RELEASE_JSON"

ASSET_URL=$(awk -F'"' '/"browser_download_url":/ && /Aether-.*\.zip/ { print $4; exit }' "$RELEASE_JSON")

if [ -z "$ASSET_URL" ]; then
    fail "latest release does not include an Aether-*.zip asset."
fi

info "Downloading $ASSET_URL"
curl -fL "$ASSET_URL" -o "$ZIP_PATH"

mkdir -p "$EXTRACT_DIR"
ditto -x -k "$ZIP_PATH" "$EXTRACT_DIR"

DOWNLOADED_APP=$(find "$EXTRACT_DIR" -maxdepth 2 -name "$APP_NAME.app" -type d -print -quit)

if [ -z "$DOWNLOADED_APP" ]; then
    fail "downloaded archive does not contain $APP_NAME.app."
fi

if pgrep -x "$APP_NAME" >/dev/null 2>&1; then
    info "$APP_NAME is running. Quitting it before update..."
    osascript -e 'tell application "Aether" to quit' >/dev/null 2>&1 || true
    sleep 1
fi

info "Installing $APP_NAME to $INSTALL_DIR..."
run_privileged rm -rf "$APP_PATH"
run_privileged ditto "$DOWNLOADED_APP" "$APP_PATH"

if command -v xattr >/dev/null 2>&1; then
    run_privileged xattr -dr com.apple.quarantine "$APP_PATH" >/dev/null 2>&1 || true
fi

VERSION=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$APP_PATH/Contents/Info.plist" 2>/dev/null || printf 'unknown')

info "$APP_NAME $VERSION installed at $APP_PATH"
info "Open it from Launchpad, Spotlight, or Finder."
