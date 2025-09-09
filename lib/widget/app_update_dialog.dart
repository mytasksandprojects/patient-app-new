import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utilities/colors_constant.dart';
import '../utilities/image_constants.dart';
import '../generated/l10n.dart';
import '../services/app_update_service.dart';
import 'button_widget.dart';

class AppUpdateDialog extends StatelessWidget {
  final AppUpdateResult updateResult;
  final AppUpdateConfig updateConfig;
  final VoidCallback? onLater;

  const AppUpdateDialog({
    Key? key,
    required this.updateResult,
    required this.updateConfig,
    this.onLater,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevent back button for force updates
        return !updateResult.forceUpdate;
      },
      child: AlertDialog(
        backgroundColor: ColorResources.bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: EdgeInsets.zero,
        content: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: ColorResources.bgColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: ColorResources.primaryColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              _buildContent(context),
              _buildActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorResources.primaryColor,
            ColorResources.secondaryColor,
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              updateResult.forceUpdate 
                ? Icons.system_update_alt_rounded
                : Icons.update_rounded,
              size: 30,
              color: const Color(0xFF0f0f0f),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            updateResult.forceUpdate 
              ? "Update Required"
              : "Update Available",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0f0f0f),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Version ${updateResult.currentVersion}",
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFF0f0f0f).withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(
            updateResult.forceUpdate ? Icons.warning_amber_rounded : Icons.info_outline,
            size: 50,
            color: updateResult.forceUpdate ? Colors.orange : ColorResources.primaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            updateResult.forceUpdate 
              ? updateConfig.forceUpdateMessage
              : updateConfig.updateMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              height: 1.5,
            ),
          ),
          if (updateResult.forceUpdate) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.orange.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.block,
                    color: Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "App will not function until updated",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
            SizedBox(
              width: double.infinity,
              child: SmallButtonsWidget(
                title: S.of(context).LUpdate,
                onPressed: () => _launchStore(context),
              ),
            ),
          if (!updateResult.forceUpdate) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onLater != null) onLater!();
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: ColorResources.primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
                child: Text(
                  "Later",
                  style: const TextStyle(
                    color: ColorResources.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _launchStore(BuildContext context) async {
    try {
      String storeUrl = updateConfig.updateUrl;
      
      // If no custom URL provided, use default store URLs
      if (storeUrl.isEmpty || storeUrl == "https://play.google.com/store/apps") {
        if (Platform.isAndroid) {
          // Try to get package name dynamically
          storeUrl = "https://play.google.com/store/apps/details?id=com.dramr.userapp"; // Replace with your actual package name
          // Fallback to web version
          if (!await canLaunch(storeUrl)) {
            storeUrl = "https://play.google.com/store/apps/details?id=com.dramr.userapp";
          }
        } else if (Platform.isIOS) {
          storeUrl = "https://apps.apple.com/app/id123456789"; // Replace with your App Store ID
        }
      }
      
      if (await canLaunch(storeUrl)) {
        await launch(storeUrl);
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Cannot open app store"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).LSomethingwentwrong),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Show the update dialog
  static Future<void> show(
    BuildContext context, {
    required AppUpdateResult updateResult,
    required AppUpdateConfig updateConfig,
    VoidCallback? onLater,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: !updateResult.forceUpdate,
      builder: (context) => AppUpdateDialog(
        updateResult: updateResult,
        updateConfig: updateConfig,
        onLater: onLater,
      ),
    );
  }
}
