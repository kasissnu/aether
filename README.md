<h1 align="center">Aether</h1>

<p align="center">
  <a href="https://github.com/kasissnu/aether/releases/latest">
    <img src="https://img.shields.io/github/v/release/kasissnu/aether?label=release" alt="Latest release">
  </a>
  <img src="https://img.shields.io/badge/macOS-14%2B-0b0f19" alt="macOS 14+">
  <img src="https://img.shields.io/badge/Swift-5.9-f05138" alt="Swift 5.9">
</p>

Aether turns the top of your Mac display into a native Dynamic Island-style notch. It gives you fast media controls, live playback status, AirPods-style Bluetooth battery, Mac battery and volume activity, and fullscreen-aware behavior without constantly burning CPU in the background.

![Aether demo](docs/assets/aether-demo.gif)

---

## Installation

**System requirements**

- macOS 14 Sonoma or later
- Apple Silicon or Intel Mac

### Option 1: One-line install or update

Install Aether for the first time, or update it after a new release:

```bash
curl -fsSL https://github.com/kasissnu/aether/releases/latest/download/install-aether.sh | bash
```

The script downloads the latest `Aether-*.zip` release, installs `Aether.app` into `/Applications`, removes the macOS quarantine flag, and prints the installed version.

### Option 2: Manual install

1. Download the latest `Aether-*.zip` from [GitHub Releases](https://github.com/kasissnu/aether/releases/latest).
2. Unzip it.
3. Move `Aether.app` to `/Applications`.
4. Open Aether from Launchpad, Spotlight, or Finder.

> [!IMPORTANT]
> Current releases are unsigned/ad-hoc signed. macOS may warn that Aether is from an unidentified developer on first launch. This is expected for now.

#### Recommended Gatekeeper fix: Terminal

After moving Aether to `/Applications`, run:

```bash
xattr -dr com.apple.quarantine /Applications/Aether.app
```

Then open Aether normally.

#### Alternative: System Settings or right-click

1. Try to open Aether and dismiss the macOS warning.
2. Open **System Settings** > **Privacy & Security**.
3. Click **Open Anyway** for Aether if macOS shows that option.
4. Or right-click `Aether.app` in Finder, choose **Open**, then confirm.

## Usage

- Launch Aether and look for the capsule icon in the macOS menu bar.
- Hover over the notch to expand it.
- Control playback directly from the notch.
- Open **Preferences** from the menu bar icon to configure media, display, battery, and behavior settings.

## Features

- Native Dynamic Island-style notch for macOS.
- Media activity with artwork, waveform, elapsed time, progress seeking, play/pause, previous/next, shuffle, and repeat.
- Low-overhead **Now Playing** integration by default.
- Explicit Spotify, Apple Music, and YouTube Music controller options.
- Shelf: drag-and-drop a file/link/text into the notch to keep it handy, share it, or compress it.
- Onboarding flow for first-run setup.
- In-app update checking.
- AirPods-style Bluetooth battery status with layered fallbacks.
- Mac battery and volume live activity.
- Fullscreen-aware hiding and multi-display placement options.
- Adaptive polling and event-driven refresh paths to reduce idle CPU and battery use.

## Media Support

Aether can display and control playback from:

- **Now Playing**: the default low-power system media source.
- **Spotify**: app-specific controls when selected in Preferences.
- **Apple Music**: app-specific controls when selected in Preferences.
- **YouTube Music**: the `th-ch/youtube-music` desktop app with its companion API.

Choose the active controller in **Preferences** > **Media** > **Media controller**.

If the UI shows one app but controls another, switch from **Automatic** to the specific player you want Aether to control.

## Permissions

Aether may ask macOS for:

- **Automation / Apple Events**: required for Spotify and Apple Music app-specific controls.
- **Bluetooth**: required for AirPods/Bluetooth battery status in the packaged app.

If you denied a permission, open **System Settings** > **Privacy & Security**, then enable Aether under **Automation** or **Bluetooth**.

## AirPods and Bluetooth Battery

AirPods battery is best-effort because macOS does not provide a stable public API for every Bluetooth audio device. Aether detects Bluetooth audio through CoreAudio and `system_profiler`, then reads battery through layered sources:

- `privateBluetooth`: preferred fast path.
- `ioRegistry`: fallback when HID battery is exposed.
- `cache`: last known value.
- `unavailable`: no usable source for the current device/session.

AirPods battery works best from the packaged `.app`, not from `swift run`.


## Troubleshooting

**Aether does not open**

- If macOS blocks it, run `xattr -dr com.apple.quarantine /Applications/Aether.app`.
- If that does not work, use **System Settings** > **Privacy & Security** > **Open Anyway**.

**The notch does not appear**

- Confirm Aether is running by checking the menu bar icon.
- Enable **Show idle notch** in Preferences.
- If you use multiple displays, try **Show on all displays** or set a **Preferred display**.

**Media looks stale or controls the wrong app**

- Open **Preferences** > **Media**.
- Change **Media controller** from **Automatic** to Spotify, Apple Music, or YouTube Music.
- Quit and relaunch Aether if macOS media state is stale.

**YouTube Music does not respond**

- Install and run the `YouTube Music` desktop app with bundle identifier `com.github.th-ch.youtube-music`.
- Enable its companion API.

**AirPods battery is missing**

- Use the packaged `.app`, not `swift run`.
- Confirm Bluetooth permission is enabled for Aether.
- Open **Preferences** > **Battery** > **Diagnostics** to see which source Aether can access.

## Source Code

Aether is currently distributed as a packaged app via GitHub Releases. The core source code is not published in this repository.
