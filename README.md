# FocusShield

iOS screen time app that shields any app after you hit your daily usage limit. Built with SwiftUI and Apple's Screen Time APIs.

Pick the apps you waste time on, set a daily limit, and when you hit it a shield pops up guilt-tripping you into doing something else instead.

## How it works

1. User picks apps via the native `FamilyActivityPicker`
2. `DeviceActivityMonitor` tracks cumulative usage against a daily threshold
3. When the threshold hits, the monitor extension applies a `ManagedSettingsStore` shield to the selected apps
4. Shield shows a random activity suggestion from the user's todo list and two buttons — bypass temporarily or close the app

## Project structure

```
FocusShield/                        # Main app target
├── Models/                         # TodoItem, UsageSettings, AppGroup constants
├── Services/                       # ScreenTimeManager, TodoStore
└── Views/                          # SwiftUI views (onboarding, shield settings, todos, settings)

DeviceActivityMonitorExtension/     # Fires when usage threshold is reached
ShieldConfigurationExtension/       # Custom shield UI (title, subtitle, buttons)
ShieldActionExtension/              # Handles shield button taps (defer vs close)
```

All four targets share data through an App Group (`group.com.focusshield.shared`) using `UserDefaults`.

## Key files

- `ScreenTimeManager.swift` — auth, monitoring schedule, shield apply/remove
- `ShieldSettingsView.swift` — app picker + daily limit UI
- `DeviceActivityMonitorExtension.swift` — threshold detection, reads saved selection and shields apps
- `ShieldConfigurationExtension.swift` — builds the shield screen (pulls a random incomplete todo as a suggestion)

## Stack

- SwiftUI + `@Observable` (iOS 17+)
- FamilyControls / DeviceActivity / ManagedSettings / ManagedSettingsUI
- Deployment target: iOS 18.0

## Contributing

The codebase is pretty small and straightforward. A few areas that could use work:

- Per-app limits (right now it's one shared limit across all selected apps)
- Usage stats / history view
- Schedule-based blocking (e.g. block during work hours regardless of usage)
- Better shield UI (animations, custom illustrations)
- Widget showing remaining time

PRs welcome. Just make sure you test on a real device — none of the Screen Time stuff works in the simulator.
