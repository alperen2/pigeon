# Getting Started

## Install

Get Pigeon from the [Mac App Store](https://apps.apple.com/app/pigeon-agentic-to-do/id6760581883). It needs macOS 14 or later.

## Build from source

### Requirements

- macOS 14+
- Xcode 16+

### Run locally

```bash
open quickbox.xcodeproj
```

Select `quickbox` scheme and run.

### Run tests

```bash
xcodebuild test -project quickbox.xcodeproj -scheme quickbox-AppStore -destination 'platform=macOS' -only-testing:quickboxTests
```
