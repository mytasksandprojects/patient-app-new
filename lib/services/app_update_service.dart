import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'configuration_service.dart';

class AppUpdateService {
  /// Check if force update is required
  static Future<AppUpdateResult> checkForUpdates() async {
    try {
      // Get current app version
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      final currentBuildNumber = packageInfo.buildNumber;
      
      if (kDebugMode) {
        print('Current app version: $currentVersion+$currentBuildNumber');
      }
      
      // Get configuration for update box enable
      final updateBoxConfig = await ConfigurationService.getDataById(
        idName: "android_update_box_enable"
      );
      
      // Get configuration for force update
      final forceUpdateConfig = await ConfigurationService.getDataById(
        idName: "android_force_update_box_enable"
      );
      
      // Check if update box is enabled
      final isUpdateBoxEnabled = updateBoxConfig?.value?.toLowerCase() == "true";
      final isForceUpdateEnabled = forceUpdateConfig?.value?.toLowerCase() == "true";
      
      if (kDebugMode) {
        print('Update box enabled: $isUpdateBoxEnabled');
        print('Force update enabled: $isForceUpdateEnabled');
      }
      
      if (!isUpdateBoxEnabled) {
        return AppUpdateResult(
          updateRequired: false,
          forceUpdate: false,
          currentVersion: currentVersion,
        );
      }
      
      return AppUpdateResult(
        updateRequired: isUpdateBoxEnabled,
        forceUpdate: isForceUpdateEnabled,
        currentVersion: currentVersion,
        buildNumber: currentBuildNumber,
      );
      
    } catch (e) {
      if (kDebugMode) {
        print('Error checking for updates: $e');
      }
      return AppUpdateResult(
        updateRequired: false,
        forceUpdate: false,
        currentVersion: "Unknown",
      );
    }
  }
  
  /// Get additional configuration for update messages and links
  static Future<AppUpdateConfig> getUpdateConfig() async {
    try {
      // You can add more configuration keys as needed
      final configs = await Future.wait([
        ConfigurationService.getDataById(idName: "android_update_message"),
        ConfigurationService.getDataById(idName: "android_update_url"),
        ConfigurationService.getDataById(idName: "android_force_update_message"),
      ]);
      
      return AppUpdateConfig(
        updateMessage: configs[0]?.value ?? "A new version is available. Please update to continue using the app.",
        updateUrl: configs[1]?.value ?? "https://play.google.com/store/apps",
        forceUpdateMessage: configs[2]?.value ?? "This version is no longer supported. Please update to the latest version.",
      );
      
    } catch (e) {
      if (kDebugMode) {
        print('Error getting update config: $e');
      }
      return AppUpdateConfig(
        updateMessage: "A new version is available. Please update to continue using the app.",
        updateUrl: "https://play.google.com/store/apps",
        forceUpdateMessage: "This version is no longer supported. Please update to the latest version.",
      );
    }
  }
}

class AppUpdateResult {
  final bool updateRequired;
  final bool forceUpdate;
  final String currentVersion;
  final String? buildNumber;
  final String? latestVersion;
  
  AppUpdateResult({
    required this.updateRequired,
    required this.forceUpdate,
    required this.currentVersion,
    this.buildNumber,
    this.latestVersion,
  });
  
  @override
  String toString() {
    return 'AppUpdateResult(updateRequired: $updateRequired, forceUpdate: $forceUpdate, currentVersion: $currentVersion)';
  }
}

class AppUpdateConfig {
  final String updateMessage;
  final String updateUrl;
  final String forceUpdateMessage;
  
  AppUpdateConfig({
    required this.updateMessage,
    required this.updateUrl,
    required this.forceUpdateMessage,
  });
}
