# FocusShield - Xcode Project Setup Guide

## Prerequisites
1. Apple developer account - [Aint paying for this now]
2. **Screen Time API entitlement** - You must request this from Apple:
   - Go to https://developer.apple.com/contact/request/family-controls-distribution
   - Fill out the form explaining your app's purpose
   - Apple typically approves within a few days
   - For **development/testing**, you can use the entitlement immediately without approval
3. **Xcode 16+** installed on your Mac
4. **iPhone 17 Pro** running iOS 18+

## Step 1: Create the Xcode Project

1. Open Xcode → File → New → Project
2. Choose **iOS → App**
3. Settings:
   - Product Name: `FocusShield`
   - Team: Select your Apple Developer team
   - Organization Identifier: `com.focusshield` (or your own)
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: **None**
4. Save to `~/Documents/FocusShield/` (replace the generated folder)

## Step 2: Add Source Files

1. In Xcode, delete the auto-generated `ContentView.swift` and `FocusShieldApp.swift`
2. Drag in the files from the `FocusShield/` folder:
   - `FocusShieldApp.swift`
   - `ContentView.swift`
   - `Models/` folder
   - `Views/` folder
   - `Services/` folder
3. Make sure "Copy items if needed" is unchecked (files are already in place)

## Step 3: Add Extensions

For each extension, do the following:

### Device Activity Monitor Extension
1. File → New → Target → **Device Activity Monitor Extension**
2. Product Name: `DeviceActivityMonitorExtension`
3. Delete the auto-generated Swift file
4. Add `DeviceActivityMonitorExtension/DeviceActivityMonitorExtension.swift`

### Shield Configuration Extension
1. File → New → Target → **Shield Configuration Extension**
2. Product Name: `ShieldConfigurationExtension`
3. Delete the auto-generated Swift file
4. Add `ShieldConfigurationExtension/ShieldConfigurationExtension.swift`

### Shield Action Extension
1. File → New → Target → **Shield Action Extension**
2. Product Name: `ShieldActionExtension`
3. Delete the auto-generated Swift file
4. Add `ShieldActionExtension/ShieldActionExtension.swift`

## Step 4: Configure Entitlements

For **each target** (main app + 3 extensions):

1. Select the target → Signing & Capabilities
2. Click "+ Capability" and add:
   - **Family Controls**
   - **App Groups** → Add group: `group.com.focusshield.shared`
3. The entitlements files in this project already have the correct values

## Step 5: Configure Info.plist for Extensions

Each extension has an `Info.plist` in its folder. Make sure Xcode uses these by:
1. Select extension target → Build Settings
2. Search for "Info.plist File"
3. Set it to the path of the corresponding Info.plist

## Step 6: Set Deployment Target

For all targets:
1. Select target → General → Minimum Deployments
2. Set to **iOS 18.0**

## Step 7: Build & Run

1. Connect your iPhone 17 Pro
2. Select it as the run destination
3. Build and run (Cmd+R)
4. On first launch, the app will ask for Screen Time authorization
5. After authorizing, go to the Shield tab and select WhatsApp
6. Set your daily limit (default 60 minutes)
7. Tap "Start Monitoring"

## How It Works

1. **Daily Reset**: Each day at midnight, the usage counter resets automatically
2. **Threshold Hit**: When you've used WhatsApp for your set limit, the Device Activity Monitor extension triggers
3. **Shield Appears**: A custom shield covers WhatsApp showing:
   - "Time's Up!" header
   - A random activity suggestion from your TODO list
   - "Do you REALLY REALLY REALLY need WhatsApp right now?"
   - Two buttons: "I really need it" (red) and "You're right, I'll do something else" (indigo)
4. **User Choice**:
   - "I really need it" → temporarily lets you through
   - "You're right" → closes WhatsApp

## Troubleshooting

- **Shield not appearing**: Make sure Family Controls is authorized in Settings → Screen Time
- **Extension not running**: Check that the extension targets are embedded in the main app (Build Phases → Embed App Extensions)
- **App Group not working**: Verify the group identifier matches exactly across all targets
- **Can't select WhatsApp**: The Family Activity Picker uses opaque tokens — you won't see app names, but icons are shown
