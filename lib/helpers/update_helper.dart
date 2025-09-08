import 'package:flutter/material.dart';
import '../services/app_update_service.dart';
import '../widget/app_update_dialog.dart';

class UpdateHelper {
  /// Manually trigger update check (useful for testing)
  static Future<void> checkForUpdatesManually(BuildContext context) async {
    try {
      final updateResult = await AppUpdateService.checkForUpdates();
      
      if (updateResult.updateRequired) {
        final updateConfig = await AppUpdateService.getUpdateConfig();
        
        await AppUpdateDialog.show(
          context,
          updateResult: updateResult,
          updateConfig: updateConfig,
        );
      } else {
        // Show message that no update is required
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("App is up to date"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to check for updates"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Check for updates on app resume (useful for checking when app comes back from background)
  static Future<void> checkForUpdatesOnResume(BuildContext context) async {
    try {
      final updateResult = await AppUpdateService.checkForUpdates();
      
      if (updateResult.updateRequired) {
        final updateConfig = await AppUpdateService.getUpdateConfig();
        
        await AppUpdateDialog.show(
          context,
          updateResult: updateResult,
          updateConfig: updateConfig,
        );
      }
    } catch (e) {
      // Silently fail for background checks
    }
  }
}
