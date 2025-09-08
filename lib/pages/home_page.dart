import 'dart:io';
import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:userapp/Language.dart';
import 'package:userapp/generated/l10n.dart';
import 'package:userapp/pages/contact_us_page.dart';
import '../controller/depratment_controller.dart';
import '../controller/doctors_controller.dart';
import '../controller/notification_dot_controller.dart';
import '../helpers/route_helper.dart';
import '../model/department_model.dart';
import '../model/doctors_model.dart';
import '../pages/auth/login_page.dart';
import '../pages/my_booking_page.dart';
import '../pages/wallet_page.dart';
import '../services/configuration_service.dart';
import '../services/notification_seen_service.dart';
import '../utilities/sharedpreference_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/user_controller.dart';
import '../utilities/api_content.dart';
import '../utilities/colors_constant.dart';
import '../utilities/image_constants.dart';
import '../widget/drawer_widget.dart';
import '../widget/image_box_widget.dart';
import '../widget/loading_Indicator_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final DepartmentController _departmentController =
      Get.put(DepartmentController(), tag: "department");
  final DoctorsController _doctorsController =
      Get.put(DoctorsController(), tag: "doctor");
  final ScrollController _scrollController = ScrollController();
  final NotificationDotController _notificationDotController =
      Get.find(tag: "notification_dot");
  bool isPressed = false;
  bool isBookButtonPressed = false;

  /// Controller to handle PageView and also handles initial page
  final PageController _pageController = PageController(initialPage: 1);

  /// Controller to handle bottom nav bar and also handles initial page
  final NotchBottomBarController _notchController = NotchBottomBarController(index: 1);

  bool _isLoading = false;
  UserController userController = Get.find(tag: "user");
  String appStoreUrl = "";
  String playStoreUrl = "";
  String doctorImage = "";
  String? clinicLat;

  //String? clinicLng;
  String? email;
  String? phone;
  String? whatsapp;
  String? ambulancePhone;
  DoctorsModel? doctorsModel;

  List<Map<String, dynamic>> getBoxCardItems(BuildContext context) {
    return [
      // {
      //   "title": S.of(context).LAppointment,
      //   "assets": FontAwesomeIcons.stethoscope,
      //   "onClick": () async {
      //     SharedPreferences preferences = await SharedPreferences.getInstance();
      //     final loggedIn =
      //         preferences.getBool(SharedPreferencesConstants.login) ?? false;
      //     final userId = preferences.getString(SharedPreferencesConstants.uid);
      //     if (loggedIn && userId != "" && userId != null) {
      //       Get.toNamed(RouteHelper.getMyBookingPageRoute());
      //     } else {
      //       Get.to(() => LoginPage(onSuccessLogin: () {
      //             Get.toNamed(RouteHelper.getMyBookingPageRoute());
      //           }));
      //       // Get.toNamed(RouteHelper.getLoginPageRoute());
      //     }
      //   }
      // },
      {
        "title": S.of(context).LVitals,
        "assets": FontAwesomeIcons.heartPulse,
        "onClick": () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          final loggedIn =
              preferences.getBool(SharedPreferencesConstants.login) ?? false;
          final userId = preferences.getString(SharedPreferencesConstants.uid);
          if (loggedIn && userId != "" && userId != null) {
            Get.toNamed(RouteHelper.getVitalsPageRoute());
          } else {
            Get.to(() => LoginPage(onSuccessLogin: () {
                  Get.toNamed(RouteHelper.getVitalsPageRoute());
                }));
            // Get.toNamed(RouteHelper.getLoginPageRoute());
          }
        }
      },
      {
        "title": S.of(context).LPrescription,
        "assets": FontAwesomeIcons.filePrescription,
        "onClick": () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          final loggedIn =
              preferences.getBool(SharedPreferencesConstants.login) ?? false;
          final userId = preferences.getString(SharedPreferencesConstants.uid);
          if (loggedIn && userId != "" && userId != null) {
            Get.toNamed(RouteHelper.getPrescriptionListPageRoute());
          } else {
            Get.to(() => LoginPage(onSuccessLogin: () {
                  Get.toNamed(RouteHelper.getPrescriptionListPageRoute());
                }));
            // Get.toNamed(RouteHelper.getLoginPageRoute());
          }
        }
      },
      // {
      //   "title": S.of(context).LProfile,
      //   "assets": FontAwesomeIcons.user,
      //   "onClick": () async {
      //     SharedPreferences preferences = await SharedPreferences.getInstance();
      //     final loggedIn =
      //         preferences.getBool(SharedPreferencesConstants.login) ?? false;
      //     final userId = preferences.getString(SharedPreferencesConstants.uid);
      //     if (loggedIn && userId != "" && userId != null) {
      //       Get.toNamed(RouteHelper.getEditUserProfilePageRoute());
      //     } else {
      //       Get.to(() => LoginPage(onSuccessLogin: () {
      //             Get.toNamed(RouteHelper.getEditUserProfilePageRoute());
      //           }));
      //       // Get.toNamed(RouteHelper.getLoginPageRoute());
      //     }
      //   }
      // },
      {
        "title": S.of(context).LFamilyMember,
        "assets": FontAwesomeIcons.peopleRoof,
        "onClick": () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          final loggedIn =
              preferences.getBool(SharedPreferencesConstants.login) ?? false;
          final userId = preferences.getString(SharedPreferencesConstants.uid);
          if (loggedIn && userId != "" && userId != null) {
            Get.toNamed(RouteHelper.getFamilyMemberListPageRoute());
          } else {
            Get.to(() => LoginPage(onSuccessLogin: () {
                  Get.toNamed(RouteHelper.getFamilyMemberListPageRoute());
                }));
            // Get.toNamed(RouteHelper.getLoginPageRoute());
          }
        }
      },
      // {
      //   "title": S.of(context).LWallet,
      //   "assets": FontAwesomeIcons.wallet,
      //   "onClick": () async {
      //     SharedPreferences preferences = await SharedPreferences.getInstance();
      //     final loggedIn =
      //         preferences.getBool(SharedPreferencesConstants.login) ?? false;
      //     final userId = preferences.getString(SharedPreferencesConstants.uid);
      //     if (loggedIn && userId != "" && userId != null) {
      //       Get.toNamed(RouteHelper.getWalletPageRoute());
      //     } else {
      //       Get.to(() => LoginPage(onSuccessLogin: () {
      //             Get.toNamed(RouteHelper.getWalletPageRoute());
      //           }));
      //       // Get.toNamed(RouteHelper.getLoginPageRoute());
      //     }
      //   }
      // },
      // {
      //   "title": S.of(context).LNotification,
      //   "assets": FontAwesomeIcons.bell,
      //   "onClick": () async {
      //     SharedPreferences preferences = await SharedPreferences.getInstance();
      //     final loggedIn =
      //         preferences.getBool(SharedPreferencesConstants.login) ?? false;
      //     final userId = preferences.getString(SharedPreferencesConstants.uid);
      //     if (loggedIn && userId != "" && userId != null) {
      //       Get.toNamed(RouteHelper.getNotificationPageRoute());
      //     } else {
      //       Get.to(() => LoginPage(onSuccessLogin: () {
      //             Get.toNamed(RouteHelper.getNotificationPageRoute());
      //           }));
      //       // Get.toNamed(RouteHelper.getLoginPageRoute());
      //     }
      //   }
      // },
      // {
      //   "title": S.of(context).LContactUs,
      //   "assets": FontAwesomeIcons.headset,
      //   "onClick": () async {
      //     Get.toNamed(RouteHelper.getContactUsPageRoute());
      //   }
      // },
      {
        "title": S.of(context).LFiles,
        "assets": FontAwesomeIcons.file,
        "onClick": () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          final loggedIn =
              preferences.getBool(SharedPreferencesConstants.login) ?? false;
          final userId = preferences.getString(SharedPreferencesConstants.uid);
          if (loggedIn && userId != "" && userId != null) {
            Get.toNamed(RouteHelper.getPatientFilePageRoute());
          } else {
            Get.to(() => LoginPage(onSuccessLogin: () {
                  Get.toNamed(RouteHelper.getPatientFilePageRoute());
                }));
            // Get.toNamed(RouteHelper.getLoginPageRoute());
          }
        }
      }
    ];
  }

  @override
  void initState() {
    // TODO: implement initState

    userController.getData();
    _departmentController.getData();
    _doctorsController.getData("");
    getAndSetData();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _notchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// widget list for bottom bar pages
    final List<Widget> bottomBarPages = [
      ContactUsPage(),
      _buildHomePage(),
      _buildAppointmentsPage(),
      //_buildWalletPage(),
    ];

    return PopScope(
      canPop: _notchController.index == 2 ? true : false,
      onPopInvokedWithResult: (didPop, dynamic) {
        if (_notchController.index == 2) {
        } else {
          _notchController.jumpTo(2);
          _pageController.jumpToPage(2);
        }
      },
      child: Scaffold(
        key: _key,
        drawer: IDrawerWidget()
            .buildDrawerWidget(userController, _notificationDotController,contactus: _buildContactIcons()),
        backgroundColor: ColorResources.bgColor,
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: _isLoading
            ? Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ColorResources.gradientStart,
                      ColorResources.gradientEnd
                    ],
                  ),
                ),
                child: const ILoadingIndicatorWidget(),
              )
            : PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(bottomBarPages.length, (index) => bottomBarPages[index]),
              ),
        bottomNavigationBar: _isLoading
            ? null
            : AnimatedNotchBottomBar(
                /// Provide NotchBottomBarController
                notchBottomBarController: _notchController,
                color: ColorResources.bgColor,
                showLabel: true,
                textOverflow: TextOverflow.visible,
                maxLine: 1,
                shadowElevation: 0,
                kBottomRadius: 12.0,
                notchColor: ColorResources.primaryColor,
                removeMargins: false,
                bottomBarWidth: MediaQuery.of(context).size.width,
                showShadow: false,
                durationInMilliSeconds: 300,
                itemLabelStyle: const TextStyle(
                  fontSize: 8,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                elevation: 0,
                bottomBarItems: [
                  BottomBarItem(
                    inActiveItem: Icon(
                      Icons.add_call,
                      color: ColorResources.secondaryFontColor,
                    ),
                    activeItem: Icon(
                      Icons.add_call,
                      color: ColorResources.bgColor,
                    ),
                    itemLabel: S.of(context).LContactUs,
                  ),
                  BottomBarItem(
                    inActiveItem: Icon(
                      Icons.home,
                      color: ColorResources.secondaryFontColor,
                    ),
                    activeItem: Icon(
                      Icons.home,
                      color: ColorResources.bgColor,
                    ),
                    itemLabel: S.of(context).LMenu,
                  ),
                  BottomBarItem(
                    inActiveItem: Icon(
                      Icons.calendar_month,
                      color: ColorResources.secondaryFontColor,
                    ),
                    activeItem: Icon(
                      Icons.calendar_month,
                      color: ColorResources.bgColor,
                    ),
                    itemLabel: S.of(context).LAppointment,
                  ),
                  // BottomBarItem(
                  //   inActiveItem: Icon(
                  //     Icons.account_balance_wallet,
                  //     color: ColorResources.secondaryFontColor,
                  //   ),
                  //   activeItem: Icon(
                  //     Icons.account_balance_wallet,
                  //     color: ColorResources.bgColor,
                  //   ),
                  //   itemLabel: S.of(context).LWallet,
                  // ),
                ],
                onTap: (index) async {
                  // Handle login check for appointments and wallet
                  if (index == 2) {
                    SharedPreferences preferences = await SharedPreferences.getInstance();
                    final loggedIn = preferences.getBool(SharedPreferencesConstants.login) ?? false;
                    final userId = preferences.getString(SharedPreferencesConstants.uid);

                    if (loggedIn && userId != "" && userId != null) {
                      _pageController.jumpToPage(index);
                    } else {
                      Get.to(LoginPage(
                        onSuccessLogin: () {
                          _pageController.jumpToPage(index);
                        },
                      ));
                    }
                  } else {
                    // Home page doesn't require login
                    _pageController.jumpToPage(index);
                  }
                },
                kIconSize: 20.0,
              ),
      ),
    );
  }

  _buildBody() {
    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.all(0),
      children: [
        // Status bar spacer
        const SizedBox(height: 30),
        _buildHeaderSection(),
        //_buildLocationSection(),
        if (userController.usersData.value.fName != null)
          _buildWelcomeCard(),
        //checkIsShowBox() ? _buildContactCard() : Container(),
        //_buildDepartment(),
        //_buildDoctor(),
        _buildCardBox(context),
        const SizedBox(height: 100)
      ],
    );
  }

  // Navigation Pages
  Widget _buildAppointmentsPage() {
    return const MyBookingPage();
  }

  // Widget _buildWalletPage() {
  //   return const WalletPage();
  // }

  Widget _buildHomePage() {
    return Container(
      decoration: const BoxDecoration(
        color: ColorResources.bgColor,
      ),
      child: _buildBody(),
    );
  }

  Widget _buildLocationSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: ColorResources.darkCardColor.withOpacity(0.8),
        border: Border.all(
          color: ColorResources.primaryColor.withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: ColorResources.primaryColor.withOpacity(0.1),
              border: Border.all(
                color: ColorResources.primaryColor.withOpacity(0.3),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.location_on,
              color: ColorResources.primaryColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).LCurrentLocation,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ColorResources.primaryColor,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "مصر الجديدة، شارع الحجاز، القاهرة",
                  style: TextStyle(
                    fontSize: 12,
                    color: ColorResources.secondaryFontColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: ColorResources.primaryColor.withOpacity(0.1),
              border: Border.all(
                color: ColorResources.primaryColor.withOpacity(0.3),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.edit,
                  color: ColorResources.primaryColor,
                  size: 12,
                ),
                const SizedBox(width: 6),
                Text(
                  S.of(context).LUpdate,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ColorResources.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorResources.primaryColor.withOpacity(0.15),
            ColorResources.darkCardColor.withOpacity(0.9),
          ],
        ),
        border: Border.all(
          color: ColorResources.primaryColor.withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width/4,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      ColorResources.primaryColor,
                      ColorResources.secondaryColor
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: ColorResources.primaryColor,
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Text(
                    userController.usersData.value.fName
                            ?.substring(0, 2)
                            .toString() ??
                        "",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0f0f0f),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      return Text(
                        "${userController.usersData.value.fName ?? ""} ${userController.usersData.value.lName ?? ''}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: ColorResources.primaryColor,
                        ),
                      );
                    }),
                    const SizedBox(height: 5),
                    Text(
                     S.of(context).LMembersince,
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorResources.secondaryFontColor,
                      ),
                    ),
                    Text(
                      userController.usersData.value.createdAt?.toString() ?? "",
                      style: TextStyle(
                        fontSize: 14,
                        color: ColorResources.secondaryFontColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // const SizedBox(height: 20),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     _buildStatItem("3", S.of(context).LAppointment),
          //     _buildStatItem("2", S.of(context).LPrescription),
          //     _buildStatItem("5", S.of(context).LFiles),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: ColorResources.primaryColor,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: ColorResources.secondaryFontColor,
          ),
        ),
      ],
    );
  }

  _buildCardBox(BuildContext context) {
    final items = getBoxCardItems(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  Text(
          //  S.of(context).Book,
          //   style: TextStyle(
          //     fontSize: 18,
          //     fontWeight: FontWeight.w700,
          //     color: Colors.white,
          //   ),
          // ),
          // const SizedBox(height: 15),
          GridView.builder(
            controller: _scrollController,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1.0,
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemBuilder: (BuildContext context, int index) {
              return _buildActionCard(
                items[index]['title'],
                items[index]['assets'],
                items[index]['onClick'],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, VoidCallback onTap) {
    return StatefulBuilder(
      builder: (context, setState) {

        return GestureDetector(
          onTap: onTap,
          onTapDown: (_) => setState(() => isPressed = true),
          onTapUp: (_) => setState(() => isPressed = false),
          onTapCancel: () => setState(() => isPressed = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeIn,
            transform: Matrix4.identity()
              ..scale(isPressed ? 1.0 : 1.0),
            decoration: BoxDecoration(
              color: isPressed
                  ? ColorResources.primaryColor.withOpacity(0.15)
                  : ColorResources.darkCardColor,
              border: Border.all(
                color: isPressed
                    ? ColorResources.primaryColor.withOpacity(0.8)
                    : ColorResources.primaryColor.withOpacity(0.3),
                width: isPressed ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: isPressed
                  ? [
                      BoxShadow(
                        color: ColorResources.primaryColor.withOpacity(0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      )
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: MediaQuery.of(context).size.width/6,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isPressed
                          ? [
                              ColorResources.primaryColor,
                              ColorResources.secondaryColor.withOpacity(0.8)
                            ]
                          : [
                              ColorResources.primaryColor,
                              ColorResources.secondaryColor
                            ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: isPressed
                        ? [
                            BoxShadow(
                              color: ColorResources.primaryColor.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            )
                          ]
                        : null,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    transform: Matrix4.identity()
                      ..scale(isPressed ? -0.1 : 1.0, 1.0), // Flip horizontally when pressed
                    child: Icon(
                      icon,
                      size: isPressed ? 22 : 20,
                      color: const Color(0xFF0f0f0f),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isPressed
                        ? Colors.white
                        : ColorResources.primaryColor,
                  ),
                ),
               // const SizedBox(height: 8),
                // Text(
                //   _getCardSubtitle(title),
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //     fontSize: 12,
                //     color: isPressed
                //         ? Colors.white.withOpacity(0.9)
                //         : ColorResources.secondaryFontColor,
                //     height: 1.4,
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  // _buildDepartmentBox(List dataList) {
  //   return Card(
  //     elevation: .1,
  //     color: ColorResources.bgColor,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(5.0),
  //     ),
  //     child: ListTile(
  //       contentPadding: const EdgeInsets.all(5),
  //       title: Padding(
  //           padding: const EdgeInsets.only(bottom: 10.0),
  //           child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Text(
  //                   S.of(context).LBranches,
  //                   style: TextStyle(
  //                       fontWeight: FontWeight.w600,
  //                       fontSize: 14,
  //                       color: ColorResources.primaryColor),
  //                 ),
  //                 dataList.length < 4
  //                     ? Container()
  //                     : Text(
  //                         S.of(context).LSwipeMore,
  //                         style: TextStyle(
  //                             color: ColorResources.primaryColor,
  //                             fontWeight: FontWeight.w600,
  //                             fontSize: 14),
  //                       ),
  //               ])),
  //       subtitle: SizedBox(
  //         height: 100,
  //         child: ListView.builder(
  //             padding: const EdgeInsets.all(0),
  //             itemCount: dataList.length,
  //             shrinkWrap: true,
  //             scrollDirection: Axis.horizontal,
  //             itemBuilder: (context, index) {
  //               final DepartmentModel departmentModel = dataList[index];
  //               return Padding(
  //                 padding: const EdgeInsets.fromLTRB(8, 8, 18, 8),
  //                 child: GestureDetector(
  //                   onTap: () {
  //                     final locations = [
  //                       LatLng(30.085571005422036, 31.331259271164864),
  //                       LatLng(30.04895049389527, 31.374475828835138),
  //                       LatLng(30.085571005422036, 31.331259271164864),
  //                       LatLng(30.054491740602852, 31.49202025397834),
  //                     ];
  //                     final location = locations[index];
  //                     Get.toNamed(RouteHelper.getHomeStateRoute(),
  //                         arguments: location);
  //                   },
  //                   child: Column(
  //                     children: [
  //                       departmentModel.image == null ||
  //                               departmentModel.image == ""
  //                           ? const CircleAvatar(
  //                               backgroundColor: Colors.white,
  //                               radius: 25,
  //                               child: Icon(
  //                                 Icons.location_on_sharp,
  //                                 color: ColorResources.primaryColor,
  //                                 //Color.fromARGB(255, 242, 25, 10),
  //                                 size: 35,
  //                               ),
  //                             )
  //                           : CircleAvatar(
  //                               backgroundColor: Colors.white,
  //                               radius: 25,
  //                               child: Container(
  //                                 decoration: BoxDecoration(
  //                                   shape: BoxShape.circle,
  //                                   image: DecorationImage(
  //                                     fit: BoxFit.fill,
  //                                     image: NetworkImage(
  //                                         '${ApiContents.imageUrl}/${departmentModel.image}'),
  //                                   ),
  //                                 ),
  //                               )),
  //                       const SizedBox(height: 5),
  //                       Text(
  //                         departmentModel.title ?? "--",
  //                         maxLines: 1, // Limit to 1 line
  //                         overflow: TextOverflow.ellipsis,
  //                         style:  TextStyle(
  //                             fontSize: 12,
  //                             fontWeight: FontWeight.w500,
  //                             color: Colors.white),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               );
  //             }),
  //       ),
  //     ),
  //   );
  // }

  _buildDoctorBox(List dataList) {
    return Card(
      elevation: .1,
      color: ColorResources.bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(5),
        title: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //const Text(
                  //   "Doctors",
                  //  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  // ),
                  //   dataList.length < 3
                  //    ? Container()
                  //   : const Text(
                  //     'Swipe More >>',
                  //    style: TextStyle(
                  //     color: Colors.grey,
                  //      fontWeight: FontWeight.w600,
                  //    fontSize: 14),
                  //   ),
                ])),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: SizedBox(
            height: 150,
            width: 150,
            child: _buildDoctorCard(dataList[0]),
          ),
        ),
      ),
    );
  }

///////////////////1//////////////////////
  _buildDoctorCard(DoctorsModel doctorsModel) {
    return GestureDetector(
      onTap: () async {
        //  SharedPreferences preferences = await SharedPreferences.getInstance();

        //  final loggedIn =
        //    preferences.getBool(SharedPreferencesConstants.login) ?? false;
        //  final userId = preferences.getString(SharedPreferencesConstants.uid);
        //   if (loggedIn && userId != "" && userId != null) {
        //   Get.toNamed(RouteHelper.getDoctorsDetailsPageRoute(
        //   doctId: doctorsModel.id.toString()));
        // } else {
        //  Get.to(() => LoginPage(onSuccessLogin: () {
        //      Get.toNamed(RouteHelper.getDoctorsDetailsPageRoute(
        //         doctId: doctorsModel.id.toString()));
        //   }));
        // Get.toNamed(RouteHelper.getLoginPageRoute());
        //  }
        //   Get.toNamed(RouteHelper.getDoctorsListPageRoute());
      },
      child: SizedBox(
        width: 240,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                    flex: 15,
                    child: Stack(
                      children: [
                        doctorsModel.image == null || doctorsModel.image == ""
                            ? const CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 30,
                                child: Icon(
                                  Icons.person,
                                  size: 40,
                                ),
                              )
                            : ClipOval(
                                child: SizedBox(
                                height: 110,
                                width: 110,
                                child: CircleAvatar(
                                  child: ImageBoxFillWidget(
                                    imageUrl:
                                        "${ApiContents.imageUrl}/${doctorsModel.image}",
                                    boxFit: BoxFit.fill,
                                  ),
                                ),
                              )),
                        const Positioned(
                          top: 5,
                          right: 2,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 8,
                            child: CircleAvatar(
                                backgroundColor: Colors.green, radius: 6),
                          ),
                        )
                      ],
                    )),
                const SizedBox(width: 10),
                Flexible(
                    flex: 40,
                    child: Column(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                "${doctorsModel.fName ?? "--"} ${doctorsModel.lName ?? "--"}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: ColorResources.primaryColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          doctorsModel.specialization ?? "",
                          maxLines: 3, // Limit to 1 line
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: ColorResources.secondaryFontColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 13),
                        ),
                        //    const SizedBox(height: 2),
                        //   Row(
                        //   children: [
                        //   StarRating(
                        //      mainAxisAlignment: MainAxisAlignment.center,
                        //       length: 5,
                        //      color: doctorsModel.averageRating == 0
                        //          ? Colors.grey
                        //         : Colors.amber,
                        //      rating: doctorsModel.averageRating ?? 0,
                        //    between: 5,
                        //    starSize: 15,
                        //     onRaitingTap: (rating) {},
                        //    ),
                        //   ],
                        //  ),
                        //   const SizedBox(height: 2),
                        // Text(
                        //   "${doctorsModel.averageRating} (${doctorsModel.numberOfReview} review)",
                        //  style: const TextStyle(
                        //    color: ColorResources.secondaryFontColor,
                        //    fontWeight: FontWeight.w500,
                        //    fontSize: 12),
                        //   )
                        const SizedBox(height: 5),

                        _buildSocialMediaSection(doctorsModel)
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // _buildDepartment() {
  //   return Obx(() {
  //     if (!_departmentController.isError.value) {
  //       // if no any error
  //       if (_departmentController.isLoading.value) {
  //         return const IVerticalListLongLoadingWidget();
  //       } else if (_departmentController.dataList.isEmpty) {
  //         return Container();
  //       } else {
  //         return _departmentController.dataList.length == 1
  //             ? Container()
  //             : _buildDepartmentBox(_departmentController.dataList);
  //       }
  //     } else {
  //       return Container();
  //     } //Error svg
  //   });
  // }

  _buildDoctor() {
    return Obx(() {
      if (!_doctorsController.isError.value) {
        // if no any error
        if (_doctorsController.isLoading.value) {
          return const IVerticalListLongLoadingWidget();
        } else if (_doctorsController.dataList.isEmpty) {
          return Container();
        } else {
          return _doctorsController.dataList.length == 1
              ? Container()
              : _buildDoctorBox(_doctorsController.dataList);
        }
      } else {
        return Container();
      } //Error svg
    });
  }

  _buildHeaderSection() {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            ColorResources.gradientStart,
            ColorResources.gradientEnd,
          ],
        ),
      ),
      child: Stack(
        children: [
          if (doctorImage != "")
            Positioned.fill(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5),
                  BlendMode.darken,
                ),
                child: ImageBoxFillWidget(
                  imageUrl: "${ApiContents.imageUrl}/$doctorImage",
                  boxFit: BoxFit.fill,
                ),
              ),
            ),
          // App Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: ColorResources.bgColor.withOpacity(0.95),
                border: Border(
                  bottom: BorderSide(
                    color: ColorResources.primaryColor.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _key.currentState!.openDrawer();
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: ColorResources.primaryColor.withOpacity(0.1),
                          border: Border.all(
                            color: ColorResources.primaryColor.withOpacity(0.3),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.settings,
                          color: ColorResources.primaryColor,
                          size: 20,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        final loggedIn = preferences
                                .getBool(SharedPreferencesConstants.login) ??
                            false;
                        final userId = preferences
                            .getString(SharedPreferencesConstants.uid);
                        if (loggedIn && userId != "" && userId != null) {
                          Get.toNamed(RouteHelper.getNotificationPageRoute());
                        } else {
                          Get.to(() => LoginPage(onSuccessLogin: () {
                                Get.toNamed(
                                    RouteHelper.getNotificationPageRoute());
                              }));
                        }
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: ColorResources.primaryColor.withOpacity(0.1),
                          border: Border.all(
                            color: ColorResources.primaryColor.withOpacity(0.3),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Center(
                              child: Icon(
                                Icons.notifications,
                                color: ColorResources.primaryColor,
                                size: 20,
                              ),
                            ),
                            Obx(() {
                              return _notificationDotController.isShow.value
                                  ? Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Container(
                                        width: 16,
                                        height: 16,
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Center(
                                          child: Text(
                                            "3",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container();
                            })
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        "${S.of(context).Welcome} ",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                      Obx(() {
                        return Text(
                          userController.usersData.value.fName ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        );
                      }),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    S.of(context).How,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      //Get.toNamed(RouteHelper.getAppointmentPackagePageRoute());
                      SharedPreferences preferences = await SharedPreferences.getInstance();
                      final loggedIn = preferences.getBool(SharedPreferencesConstants.login) ?? false;
                      final userId = preferences.getString(SharedPreferencesConstants.uid);

                      if (loggedIn && userId != "" && userId != null) {
                        Get.toNamed(RouteHelper.getDoctorsDetailsPageRoute(doctId: _doctorsController.dataList[0].id!.toString()));

                        //Get.toNamed(RouteHelper.getAppointmentPackagePageRoute());
                      } else {
                        Get.to(() => LoginPage(onSuccessLogin: () {
                          Get.toNamed(RouteHelper.getDoctorsDetailsPageRoute(doctId: _doctorsController.dataList[0].id!.toString()));

                          // Get.toNamed(RouteHelper.getAppointmentPackagePageRoute());
                        }));
                      }
                    },
                    onTapDown: (_) => setState(() => isBookButtonPressed = true),
                    onTapUp: (_) => setState(() => isBookButtonPressed = false),
                    onTapCancel: () => setState(() => isBookButtonPressed = false),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.easeIn,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      constraints: const BoxConstraints(minWidth: 120, minHeight: 35),
                      decoration: BoxDecoration(
                        color: isBookButtonPressed
                            ? ColorResources.primaryColor.withOpacity(0.15)
                            : ColorResources.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: isBookButtonPressed
                            ? [
                                BoxShadow(
                                  color: ColorResources.primaryColor.withOpacity(0.4),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                )
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          S.of(context).Book,
                          style: const TextStyle(
                            color: Color(0xFF0f0f0f),
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: _buildContactIcons(),
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _requestNotificationPermission() {
    //HandleLocalNotification.showWithOutImageNotification("ssss","slsls");
    if (Platform.isAndroid) {
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      // HandleLocalNotification.showWithOutImageNotification("hii", "ddd",);
    } else if (Platform.isIOS) {
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  void getAndSetData() async {
    setState(() {
      _isLoading = true;
    });
    final res = await NotificationSeenService.getDataById();
    if (res != null) {
      if (res.dotStatus == true) {
        _notificationDotController.setDotStatus(true);
      }
    }
    final doctorImageSetting =
        await ConfigurationService.getDataById(idName: "ma_doctor_image");
    if (doctorImageSetting != null) {
      doctorImage = doctorImageSetting.value ?? "";
      if (kDebugMode) {
        print("Doctor Image  ${'${ApiContents.imageUrl}/${doctorImageSetting.value??""}'}");
      }
    }

    if (Platform.isAndroid) {
      final webSetting =
          await ConfigurationService.getDataById(idName: "play_store_link");

      if (webSetting != null) {
        playStoreUrl = webSetting.value ?? "";
        if (kDebugMode) {
          print("Play store Url ${webSetting.value}");
        }
      }
      final issueSetting = await ConfigurationService.getDataById(
          idName: "android_technical_issue_enable");
      if (issueSetting != null) {
        if (issueSetting.value == "true") {
          _openDialogIssueBox();
        } else {
          final updateBox = await ConfigurationService.getDataById(
              idName: "android_update_box_enable");
          if (updateBox != null) {
            if (updateBox.value == "true") {
              final versionSetting = await ConfigurationService.getDataById(
                  idName: "android_android_app_version");
              if (versionSetting != null) {
                PackageInfo.fromPlatform()
                    .then((PackageInfo packageInfo) async {
                  String version = packageInfo.version;
                  if (kDebugMode) {
                    print("Version $version");
                    print("setting version ${versionSetting.value}");
                  }
                  if (version.toString() != versionSetting.value.toString()) {
                    final forceUpdateSetting =
                        await ConfigurationService.getDataById(
                            idName: "android_force_update_box_enable");
                    if (forceUpdateSetting != null) {
                      if (forceUpdateSetting.value == "true") {
                        _openDialogSettingBox(false);
                      } else {
                        _openDialogSettingBox(true);
                      }
                    }
                  }
                });
              }
            }
          }
        }
      }
    } else if (Platform.isIOS) {
      final webSetting =
          await ConfigurationService.getDataById(idName: "app_store_link");

      if (webSetting != null) {
        appStoreUrl = webSetting.value ?? "";
        if (kDebugMode) {
          print("app store Url ${webSetting.value}");
        }
      }
      final issueSetting = await ConfigurationService.getDataById(
          idName: "ios_technical_issue_enable");
      if (issueSetting != null) {
        if (issueSetting.value == "true") {
          _openDialogIssueBox();
        } else {
          final updateBox = await ConfigurationService.getDataById(
              idName: "ios_update_box_enable");
          if (updateBox != null) {
            if (updateBox.value == "true") {
              final versionSetting = await ConfigurationService.getDataById(
                  idName: "ios_app_version");
              if (versionSetting != null) {
                PackageInfo.fromPlatform()
                    .then((PackageInfo packageInfo) async {
                  String version = packageInfo.version;
                  if (kDebugMode) {
                    print("Version Ios $version");
                    print("setting version Ios ${versionSetting.value}");
                  }
                  if (version.toString() != versionSetting.value.toString()) {
                    final forceUpdateSetting =
                        await ConfigurationService.getDataById(
                            idName: "ios_force_update_box_enable");
                    if (forceUpdateSetting != null) {
                      if (forceUpdateSetting.value == "true") {
                        _openDialogSettingBox(false);
                      } else {
                        _openDialogSettingBox(true);
                      }
                    }
                  }
                });
              }
            }
          }
        }
      }
    }
    final configRes = await ConfigurationService.getDataByGroupName("Basic");
    if (configRes != null) {
      for (var e in configRes) {
        if (e.idName == "clinic_location_latitude") {
          clinicLat = e.value;
        }
        //  if (e.idName == "clinic_location_longitude") {
        //   clinicLng = e.value;
        //}
        if (e.idName == "whatsapp") {
          whatsapp = e.value;
        }
        if (e.idName == "phone") {
          phone = e.value;
        }
        if (e.idName == "email") {
          email = e.value;
        }
        if (e.idName == "ambulance_phone") {
          ambulancePhone = e.value;
        }
      }
    }
    _requestNotificationPermission();
    setState(() {
      _isLoading = false;
    });
  }

  _openDialogSettingBox(bool isCancel) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return PopScope(
          canPop: isCancel,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: const Text(
              "Update",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    isCancel
                        ? "New version is available, please update the app"
                        : "Sorry we are currently not supporting the old version of the app please update with new version",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 12)),
                const SizedBox(height: 10),
              ],
            ),
            actions: <Widget>[
              isCancel
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorResources.greyBtnColor,
                      ),
                      child: const Text("Cancel",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 12)),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                  : Container(),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorResources.greenFontColor,
                  ),
                  child: const Text(
                    "Update",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                  ),
                  onPressed: () async {
                    // Navigator.of(context).pop();
                    if (Platform.isAndroid) {
                      if (playStoreUrl != "") {
                        try {
                          await launchUrl(Uri.parse(playStoreUrl),
                              mode: LaunchMode.externalApplication);
                        } catch (e) {
                          if (kDebugMode) {
                            print(e);
                          }
                        }
                      }
                    } else if (Platform.isIOS) {
                      if (appStoreUrl != "") {
                        try {
                          await launchUrl(Uri.parse(appStoreUrl),
                              mode: LaunchMode.externalApplication);
                        } catch (e) {
                          if (kDebugMode) {
                            print(e);
                          }
                        }
                      }
                    }
                  }),
              // usually buttons at the bottom of the dialog
            ],
          ),
        );
      },
    );
  }

  _openDialogIssueBox() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return PopScope(
          canPop: false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: const Text(
              "Sorry!",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    "We are facing some technical issues. our team trying to solve problems. hope we will come back very soon.",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 12)),
                SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      color: ColorResources.cardBgColor,
      elevation: .1,
      child: Directionality(
        textDirection: LanguageController.to.isArabic.value
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).LContactUs,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              _buildContactIcons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactIcons() {
    final contactItems = <Widget>[];

    if (phone != null && phone!.isNotEmpty) {
      contactItems.add(
        _buildContactIcon(
          icon: ImageConstants.telephoneImageBox,
          label: S.of(context).LCall,
          onTap: () => launchUrl(Uri.parse("tel:$phone")),
        ),
      );
    }

    if (whatsapp != null && whatsapp!.isNotEmpty) {
      contactItems.add(
        _buildContactIcon(
          icon: ImageConstants.whatsappImageBox,
          label: S.of(context).LWhatsapp,
          onTap: () => launchUrl(
            Uri.parse("https://wa.me/$whatsapp?text=Hello"),
            mode: LaunchMode.externalApplication,
          ),
        ),
      );
    }

    if (email != null && email!.isNotEmpty) {
      contactItems.add(
        _buildContactIcon(
          icon: ImageConstants.emailImageBox,
          label: S.of(context).LEmail,
          onTap: () => launchUrl(Uri.parse("mailto:$email")),
        ),
      );
    }

    if (ambulancePhone != null && ambulancePhone!.isNotEmpty) {
      contactItems.add(
        _buildContactIcon(
          icon: null,
          label: S.of(context).LWebsite,
          onTap: () => launchUrl(Uri.parse("https://dr-amrsheta.com/en/")),
          isIcon: true,
        ),
      );
    }

    return Wrap(
      spacing: 20.0,
      runSpacing: 15.0,
      children: contactItems,
    );
  }

  Widget _buildContactIcon({
    required String? icon,
    required String label,
    required VoidCallback onTap,
    bool isIcon = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          isIcon
              ? const Icon(FontAwesomeIcons.google, size: 30,color: Colors.red,)
              : SizedBox(
                  height: 30,
                  width: 30,
                  child: Image.asset(icon!),
                ),
          const SizedBox(height: 5),
          Text(
            label,
            style:  TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: Colors.white
            ),
          ),
        ],
      ),
    );
  }

  _buildTapBox(String imageAsset, String title, GestureTapCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(height: 30, child: Image.asset(imageAsset)),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          )
        ],
      ),
    );
  }

  bool checkIsShowBox() {
    if ( //clinicLng == null &&
        // clinicLat == null &&
        phone == null &&
            email == null &&
            whatsapp == null &&
            ambulancePhone == null) {
      return false;
    } else {
      return true;
    }
  }
}

Widget _buildSocialMediaSection(DoctorsModel doctorsModel) {
  final socialMediaItems = <Widget>[];

  // يوتيوب
  if (doctorsModel.youtubeLink != null &&
      doctorsModel.youtubeLink!.isNotEmpty) {
    socialMediaItems.add(
      _buildSocialMediaIcon(
        icon: ImageConstants.youtubeImageBox,
        onTap: () => _launchUrl(doctorsModel.youtubeLink!),
      ),
    );
  }

  // فيسبوك
  if (doctorsModel.fbLink != null && doctorsModel.fbLink!.isNotEmpty) {
    socialMediaItems.add(
      _buildSocialMediaIcon(
        icon: ImageConstants.facebookImageBox,
        onTap: () => _launchUrl(doctorsModel.fbLink!),
      ),
    );
  }

  if (doctorsModel.instaLink != null && doctorsModel.instaLink!.isNotEmpty) {
    socialMediaItems.add(
      _buildSocialMediaIcon(
        icon: ImageConstants.instagramImageBox,
        onTap: () => _launchUrl(doctorsModel.instaLink!),
      ),
    );
  }

  if (doctorsModel.twitterLink != null &&
      doctorsModel.twitterLink!.isNotEmpty) {
    socialMediaItems.add(
      _buildSocialMediaIcon(
        icon: ImageConstants.twitterImageBox,
        onTap: () => _launchUrl(doctorsModel.twitterLink!),
      ),
    );
  }

  return Directionality(
    textDirection: LanguageController.to.isArabic.value
        ? TextDirection.rtl
        : TextDirection.ltr,
    child: Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Wrap(
        spacing: 20.0,
        runSpacing: 10.0,
        children: socialMediaItems,
      ),
    ),
  );
}

Widget _buildSocialMediaIcon({
  required String icon,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Image.asset(
      icon,
      width: 30,
      height: 30,
    ),
  );
}

Future<void> _launchUrl(String url) async {
  try {
    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  } catch (e) {
    if (kDebugMode) {
      print('Failed to launch URL: $e');
    }
  }
}
