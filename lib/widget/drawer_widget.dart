import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userapp/Language.dart';
import 'package:userapp/generated/l10n.dart';
import 'package:userapp/services/user_service.dart';
import 'package:userapp/services/user_subscription.dart';
import '../controller/user_controller.dart';
import '../helpers/version_control.dart';
import '../pages/auth/login_page.dart';
import 'package:get/get.dart';
import '../utilities/api_content.dart';
import '../utilities/image_constants.dart';
import '../widget/toast_message.dart';
import '../controller/notification_dot_controller.dart';
import '../helpers/date_time_helper.dart';
import '../helpers/route_helper.dart';
import '../utilities/colors_constant.dart';
import '../utilities/sharedpreference_constants.dart';
import 'image_box_widget.dart';

class IDrawerWidget {
  buildDrawerWidget(UserController userController,
      NotificationDotController notificationDotController,{Widget? contactus}) {
    return Drawer(
        backgroundColor: ColorResources.bgColor,
        child: Builder(
          builder: (context) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 20),
              _buildProfileSection(userController, context),
              const SizedBox(height: 24),
              Obx(() => _buildCardBox(
                    Get.find<LanguageController>().isArabic.value
                        ? 'English'
                        : 'العربية',
                    Get.find<LanguageController>().isArabic.value
                        ? Icons.language
                        : Icons.translate,
                    () {
                      Get.find<LanguageController>().toggleLanguage();
                      Get.back();
                    },
                  )),
              const SizedBox(height: 8),
              Builder(
                builder: (context) => _buildCardBox(
                    S.of(context).LProfile, Icons.person, () async {
                  Get.back();
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  final loggedIn =
                      preferences.getBool(SharedPreferencesConstants.login) ??
                          false;
                  final userId =
                      preferences.getString(SharedPreferencesConstants.uid);
                  if (loggedIn && userId != "" && userId != null) {
                    Get.toNamed(RouteHelper.getEditUserProfilePageRoute());
                  } else {
                    Get.to(() => LoginPage(onSuccessLogin: () {
                          Get.toNamed(
                              RouteHelper.getEditUserProfilePageRoute());
                        }));
                  }
                }),
              ),
              Builder(
                builder: (context) => _buildCardBox(
                    S.of(context).LFamilyMember, Icons.face, () async {
                  Get.back();
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();

                  final loggedIn =
                      preferences.getBool(SharedPreferencesConstants.login) ??
                          false;
                  final userId =
                      preferences.getString(SharedPreferencesConstants.uid);
                  if (loggedIn && userId != "" && userId != null) {
                    Get.toNamed(RouteHelper.getFamilyMemberListPageRoute());
                  } else {
                    Get.to(() => LoginPage(onSuccessLogin: () {
                          Get.toNamed(
                              RouteHelper.getFamilyMemberListPageRoute());
                        }));
                  }
                }),
              ),
              Builder(
                builder: (context) => _buildCardBox(
                    S.of(context).LAppointment, Icons.home_repair_service, () async {
                  Get.back();
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();

                  final loggedIn =
                      preferences.getBool(SharedPreferencesConstants.login) ??
                          false;
                  final userId =
                      preferences.getString(SharedPreferencesConstants.uid);
                  if (loggedIn && userId != "" && userId != null) {
                    Get.toNamed(RouteHelper.getMyBookingPageRoute());
                  } else {
                    Get.to(() => LoginPage(onSuccessLogin: () {
                          Get.toNamed(RouteHelper.getMyBookingPageRoute());
                        }));
                  }
                }),
              ),
              Builder(
                builder: (context) => _buildCardBox(
                    S.of(context).LVitals, Icons.show_chart, () async {
                  Get.back();
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();

                  final loggedIn =
                      preferences.getBool(SharedPreferencesConstants.login) ??
                          false;
                  final userId =
                      preferences.getString(SharedPreferencesConstants.uid);
                  if (loggedIn && userId != "" && userId != null) {
                    Get.toNamed(RouteHelper.getVitalsPageRoute());
                  } else {
                    Get.to(() => LoginPage(onSuccessLogin: () {
                          Get.toNamed(RouteHelper.getVitalsPageRoute());
                        }));
                  }
                }),
              ),
              Builder(
                builder: (context) => _buildCardBox(
                    S.of(context).LPrescription, Icons.article_outlined, () async {
                  Get.back();
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();

                  final loggedIn =
                      preferences.getBool(SharedPreferencesConstants.login) ??
                          false;
                  final userId =
                      preferences.getString(SharedPreferencesConstants.uid);
                  if (loggedIn && userId != "" && userId != null) {
                    Get.toNamed(RouteHelper.getPrescriptionListPageRoute());
                  } else {
                    Get.to(() => LoginPage(onSuccessLogin: () {
                          Get.toNamed(
                              RouteHelper.getPrescriptionListPageRoute());
                        }));
                  }
                }),
              ),
              Builder(
                builder: (context) =>
                    _buildCardBox(S.of(context).LFiles, Icons.file_copy, () async {
                  Get.back();
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();

                  final loggedIn =
                      preferences.getBool(SharedPreferencesConstants.login) ??
                          false;
                  final userId =
                      preferences.getString(SharedPreferencesConstants.uid);
                  if (loggedIn && userId != "" && userId != null) {
                    Get.toNamed(RouteHelper.getPatientFilePageRoute());
                  } else {
                    Get.to(() => LoginPage(onSuccessLogin: () {
                          Get.toNamed(RouteHelper.getPatientFilePageRoute());
                        }));
                  }
                }),
              ),
              // Medical History - NEW TAB
              Builder(
                builder: (context) => _buildCardBox(
                    S.of(context).LMedicalHistory, Icons.history_edu, () async {
                  Get.back();
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();

                  final loggedIn =
                      preferences.getBool(SharedPreferencesConstants.login) ??
                          false;
                  final userId =
                      preferences.getString(SharedPreferencesConstants.uid);
                  if (loggedIn && userId != "" && userId != null) {
                    Get.toNamed(RouteHelper.getMedicalHistoryPageRoute());
                  } else {
                    Get.to(() => LoginPage(onSuccessLogin: () {
                          Get.toNamed(RouteHelper.getMedicalHistoryPageRoute());
                        }));
                  }
                }),
              ),
              Builder(
                builder: (context) => _buildCardBox(
                    S.of(context).LNotification, Icons.notifications, () async {
                  Get.back();
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  final loggedIn =
                      preferences.getBool(SharedPreferencesConstants.login) ??
                          false;
                  final userId =
                      preferences.getString(SharedPreferencesConstants.uid);
                  if (loggedIn && userId != "" && userId != null) {
                    Get.toNamed(RouteHelper.getNotificationPageRoute());
                  } else {
                    Get.to(() => LoginPage(onSuccessLogin: () {
                          Get.toNamed(RouteHelper.getNotificationPageRoute());
                        }));
                  }
                }),
              ),
              // Builder(
              //   builder: (context) => _buildCardBox(
              //       S.of(context).LWallet, Icons.wallet, () async {
              //     Get.back();
              //     SharedPreferences preferences =
              //         await SharedPreferences.getInstance();
              //     final loggedIn =
              //         preferences.getBool(SharedPreferencesConstants.login) ??
              //             false;
              //     final userId =
              //         preferences.getString(SharedPreferencesConstants.uid);
              //     if (loggedIn && userId != "" && userId != null) {
              //       Get.toNamed(RouteHelper.getWalletPageRoute());
              //     } else {
              //       Get.to(() => LoginPage(onSuccessLogin: () {
              //             Get.toNamed(RouteHelper.getWalletPageRoute());
              //           }));
              //     }
              //   }),
              // ),
              // Builder(
              //   builder: (context) => _buildCardBox(
              //       S.of(context).LContactUs, Icons.call, () async {
              //     Get.back();
              //     Get.toNamed(RouteHelper.getContactUsPageRoute());
              //   }),
              // ),
              Builder(
                builder: (context) =>
                    _buildCardBox(S.of(context).LShare, Icons.share, () async {
                  Get.back();
                  Get.toNamed(RouteHelper.getShareAppPageRoute());
                }),
              ),
              //const Divider(),
              Builder(
                builder: (context) => _buildCardBox(
                    S.of(context).LTestimonials, Icons.inventory_sharp, () async {
                  Get.back();
                  Get.toNamed(RouteHelper.getTestimonialPageRoute());
                }),
              ),
             // const Divider(),
              Builder(
                builder: (context) => _buildCardBox(
                    S.of(context).LAboutUs, Icons.info_outline, () async {
                  Get.back();
                  Get.toNamed(RouteHelper.getAboutUsPageRoute());
                }),
              ),
              Builder(
                builder: (context) => _buildCardBox(
                    S.of(context).LPrivacyPolicy, Icons.privacy_tip_outlined, () async {
                  Get.back();
                  Get.toNamed(RouteHelper.getPrivacyPagePageRoute());
                }),
              ),
              Builder(
                builder: (context) => _buildCardBox(
                    S.of(context).LTermsCondition, Icons.sim_card_alert, () async {
                  Get.back();
                  Get.toNamed(RouteHelper.getTermCondPageRoute());
                }),
              ),
              //here it's
              Builder(
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(child: contactus,),
                ),
              ),
             // const Divider(),
              if(userController.usersData.value.id!=null)
              Builder(
                builder: (context) {
                  return _buildCardBox(
                      S.of(context).LLogout, Icons.power_settings_new,
                      () async {
                    final res = await UserService.logOutUser();
                    if (res != null) {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.clear();
                      IToastMsg.showMessage("Logout");
                      final NotificationDotController
                          notificationDotController =
                          Get.find(tag: "notification_dot");
                      final UserController userController0 =
                          Get.find(tag: "user");
                      // Clear user data instead of fetching it
                      userController0.clearUserData();
                      notificationDotController.setDotStatus(false);
                      
                      // Force update the UI by triggering a rebuild
                     // userController0.update();
                      
                      Get.offAllNamed(RouteHelper.getHomePageRoute());
                      UserSubscribe.deleteToTopi(topicName: "PATIENT_APP");
                    }
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: FutureBuilder(
                    future: VersionControl.getVersionName(),
                    builder: (context, snapshot) {
                      return Text(
                        "${S.of(context).LVersion} - ${snapshot.data}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      );
                    }),
              )
            ],
          ),
        ));
  }

  static Widget _buildProfileSection(
      UserController userController, BuildContext context) {
    return Obx(() {
      if (userController.isError.value) {
        return _buildErrorSection(context);
      }

      if (userController.isLoading.value) {
        return const Text("--");
      }

      if(userController.usersData.value.id==null){
        return _buildErrorSection(context);
      }

      return _buildProfileContent(userController, context);
    });
  }

  static Widget _buildErrorSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: ListTile(
        onTap: () async {
          Get.back();
          SharedPreferences preferences = await SharedPreferences.getInstance();
          final loggedIn =
              preferences.getBool(SharedPreferencesConstants.login) ?? false;
          final userId = preferences.getString(SharedPreferencesConstants.uid);

          if (loggedIn && userId != "" && userId != null) {
            Get.toNamed(RouteHelper.getEditUserProfilePageRoute());
          } else {
            Get.to(() => LoginPage(
                  onSuccessLogin: () {
                    Get.toNamed(RouteHelper.getEditUserProfilePageRoute());
                  },
                ));
          }
        },
        leading: const Icon(Icons.login,color: Colors.white,),
        title: Text(
          S.of(context).LLoginSignup,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white
          ),
        ),
      ),
    );
  }

  static Widget _buildProfileContent(
      UserController userController, BuildContext context) {
    return SizedBox(
      height: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 70,
                width: 70,
                child: ClipOval(
                  child: userController.usersData.value.imageUrl == null ||
                          userController.usersData.value.imageUrl == ""
                      ? const Icon(Icons.person, size: 50,color: Colors.white,)
                      : ImageBoxFillWidget(
                          imageUrl:
                              "${ApiContents.imageUrl}/${userController.usersData.value.imageUrl}",
                        ),
                ),
              ),
              Row(
                children: [
                  Image.asset(
                    ImageConstants.crownImage,
                    width: 40,
                    height: 20,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: ColorResources.containerBgColor,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        S.of(context).LMember,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "${S.of(context).LHello}, ${userController.usersData.value.fName ?? "--"}",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white
            ),
          ),
          Text(
            "${S.of(context).LMembershipsince} ${DateTimeHelper.getDataFormat(userController.usersData.value.createdAt)}",
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.white
            ),
          ),
        ],
      ),
    );
  }

  static _buildCardBox(String title, IconData icon, onPressed, [selected]) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: selected ?? false ? ColorResources.primaryColor : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8B931).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: const Color(0xFFE8B931),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: selected ?? false ? Colors.black : Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withOpacity(0.4),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static _buildNotificationCardBox(
      NotificationDotController notificationDotController,
      String title,
      IconData icon,
      onPressed,
      [selected]) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: selected ?? false ? ColorResources.primaryColor : null,
          borderRadius: const BorderRadius.all(
              Radius.circular(5.0) //                 <--- border radius here
              ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 8, 20),
          child: Row(
            children: [
              Stack(
                children: [
                  Icon(
                    icon,
                    size: 20,
                    color: selected ?? false ? Colors.white : Colors.grey,
                  ),
                  Obx(() {
                    return notificationDotController.isShow.value
                        ? const Icon(
                            Icons.circle,
                            size: 10,
                            color: Colors.red,
                          )
                        : Container();
                  })
                ],
              ),
              const SizedBox(width: 20),
              Text(
                title,
                style: TextStyle(
                    color: selected ?? false ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
