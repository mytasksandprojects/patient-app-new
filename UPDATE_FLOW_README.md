# App Update Flow Implementation

This document describes the force update functionality implemented in the patient app.

## Overview

The app now supports force update functionality based on configuration values stored in the backend. The system checks for updates on app startup and shows appropriate dialogs to users.

## Configuration Keys

The following configuration keys are used to control the update flow:

1. **`android_update_box_enable`**: Controls whether the update dialog should be shown
   - Values: `"true"` or `"false"`
   - When `"true"`: Shows update dialog to users
   - When `"false"`: No update dialog is shown

2. **`android_force_update_box_enable`**: Controls whether the update is mandatory
   - Values: `"true"` or `"false"`
   - When `"true"`: Users must update (cannot dismiss dialog)
   - When `"false"`: Users can choose to update later

## Optional Configuration Keys

You can also add these configuration keys for better customization:

3. **`android_update_message`**: Custom message for regular updates
4. **`android_update_url`**: Custom URL for app store/download link
5. **`android_force_update_message`**: Custom message for force updates

## How It Works

### 1. App Startup Flow
- When the app starts, the splash screen loads
- After animations complete, the system checks for updates
- Based on configuration values, appropriate action is taken:
  - No update required → Navigate to home
  - Optional update → Show update dialog with "Later" option
  - Force update → Show update dialog without "Later" option

### 2. Update Dialog Behavior
- **Optional Update**: Users can choose "Update Now" or "Later"
- **Force Update**: Users can only choose "Update Now", app won't proceed without update
- Clicking "Update Now" opens the app store/play store

### 3. Update Check Logic
```dart
// Check configuration values
final updateBoxConfig = await ConfigurationService.getDataById(
  idName: "android_update_box_enable"
);
final forceUpdateConfig = await ConfigurationService.getDataById(
  idName: "android_force_update_box_enable"
);

// Determine update behavior
final isUpdateBoxEnabled = updateBoxConfig?.value?.toLowerCase() == "true";
final isForceUpdateEnabled = forceUpdateConfig?.value?.toLowerCase() == "true";
```

## Implementation Files

### Core Files
- `lib/services/app_update_service.dart`: Main service for checking updates
- `lib/widget/app_update_dialog.dart`: Update dialog UI component
- `lib/pages/splash_screen.dart`: Integration point in splash screen
- `lib/helpers/update_helper.dart`: Utility functions for manual update checks

### Modified Files
- Updated splash screen to include update check flow

## Usage Examples

### Testing the Update Flow

1. **Enable Update Dialog**:
   ```sql
   UPDATE configurations SET value = 'true' WHERE id_name = 'android_update_box_enable';
   ```

2. **Enable Force Update**:
   ```sql
   UPDATE configurations SET value = 'true' WHERE id_name = 'android_force_update_box_enable';
   ```

3. **Disable Updates**:
   ```sql
   UPDATE configurations SET value = 'false' WHERE id_name = 'android_update_box_enable';
   ```

### Manual Update Check
You can also trigger update checks manually in any part of the app:

```dart
import '../helpers/update_helper.dart';

// Trigger manual update check
await UpdateHelper.checkForUpdatesManually(context);
```

## Update Scenarios

| android_update_box_enable | android_force_update_box_enable | Behavior |
|---------------------------|-----------------------------------|----------|
| `false` | `false` | No update dialog shown |
| `false` | `true` | No update dialog shown |
| `true` | `false` | Optional update dialog with "Later" button |
| `true` | `true` | Force update dialog without "Later" button |

## Best Practices

1. **Gradual Rollout**: Start with `force_update = false` to allow users to update voluntarily
2. **Critical Updates**: Use `force_update = true` only for critical security updates or breaking changes
3. **Communication**: Use custom messages to explain why the update is necessary
4. **Testing**: Test both scenarios in development before releasing

## Customization

### Custom Update Messages
Add these configurations to customize messages:

```sql
INSERT INTO configurations (id_name, value, group_name) VALUES 
('android_update_message', 'A new version with exciting features is available!', 'Mobile App'),
('android_force_update_message', 'This version contains critical security updates. Please update immediately.', 'Mobile App'),
('android_update_url', 'https://play.google.com/store/apps/details?id=your.package.name', 'Mobile App');
```

### For iOS Support
Similar configurations can be added for iOS:
- `ios_update_box_enable`
- `ios_force_update_box_enable`
- `ios_update_message`
- `ios_force_update_message`
- `ios_update_url`

The service automatically detects the platform and uses appropriate configurations.

## Troubleshooting

1. **Update dialog not showing**: Check if `android_update_box_enable` is set to `"true"`
2. **Cannot open store**: Verify the `android_update_url` configuration
3. **Force update not working**: Ensure `android_force_update_box_enable` is set to `"true"`

## Security Considerations

- Always use HTTPS for update URLs
- Validate configuration values on the backend
- Consider implementing app version checking for more sophisticated update logic
- Monitor update compliance through analytics
