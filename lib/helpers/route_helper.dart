import 'package:get/get.dart';
import 'package:userapp/maps.dart';
import 'package:userapp/pages/patient_file_page.dart';
import 'package:userapp/pages/medical_history_page.dart';
import '../pages/appointment_details_page.dart';
import '../pages/contact_us_page.dart';
import '../pages/doctors_details_page.dart';
import '../pages/doctors_list_page.dart';
import '../pages/edit_profile_page.dart';
import '../pages/family_member_list_page.dart';
import '../pages/home_page.dart';
import '../pages/my_booking_page.dart';
import '../pages/notification_details_page.dart';
import '../pages/notification_page.dart';
import '../pages/prescription_list_page.dart';
import '../pages/share_page.dart';
import '../pages/testimonial_page.dart';
import '../pages/vital_details_page.dart';
import '../pages/vitals_page.dart';
import '../pages/wallet_page.dart';
import '../pages/web_pages/about_us_page.dart';
import '../pages/web_pages/privacy_page.dart';
import '../pages/web_pages/term_cond_page.dart';
import '../pages/splash_screen.dart';

// New booking flow pages
// import '../pages/appointment_package_page.dart';
// import '../pages/appointment_branch_page.dart';
// import '../pages/appointment_datetime_page.dart';
// import '../pages/appointment_summary_page.dart';
import '../pages/appointment_success_page.dart';

class RouteHelper {
  //Auth pages
  
  //Splash page
  static const String splashPage = '/SplashPage';

  //Home page
  static const String homePage = '/HomePage';

  //Others pages
  static const String loginPage = '/LoginPage';
  static const String doctorsListPage = '/DoctorsListPage';
  static const String doctorsDetailsPage = '/DoctorsDetailsPage';
  // static const String patientListPage = '/PatientListPage';
  static const String myBookingPage = '/MyBookingPage';
  static const String appointmentDetailsPagePage = '/AppointmentDetailsPage';
  static const String walletPage = '/WalletPage';
  static const String familyMemberListPage = '/FamilyMemberListPage';
  static const String editUserProfilePage = '/EditUserProfilePage';
  static const String aboutUsPagePage = '/AboutUsPage';
  static const String privacyPage = '/PrivacyPage';
  static const String termCondPage = '/TermCondPage';
  static const String testimonialPage = '/TestimonialPage';
  static const String shareAppPage = '/ShareAppPage';
  static const String contactUsPage = '/ContactUsPage';
  static const String notificationPage = '/NotificationPage';
  static const String notificationDetailsPage = '/NotificationDetailsPage';
  static const String vitalsPage = '/VitalsPage';
  static const String vitalsDetailsPage = '/VitalsDetailsPage';
  static const String prescriptionListPage = '/PrescriptionListPage';
  static const String patientFilePage = '/PatientFilePage';
  static const String medicalHistoryPage = '/MedicalHistoryPage';
  static const String homeState = '/HomeState'; // New route
  
  // New booking flow routes
  // static const String appointmentPackagePage = '/AppointmentPackagePage';
  // static const String appointmentBranchPage = '/AppointmentBranchPage';
  // static const String appointmentDateTimePage = '/AppointmentDateTimePage';
  // static const String appointmentSummaryPage = '/AppointmentSummaryPage';
  static const String appointmentSuccessPage = '/AppointmentSuccessPage';





  //---------------------------------------------------------------//

  static String getSplashPageRoute() => splashPage;
  static String getHomePageRoute() => homePage;
  static String getLoginPageRoute() => loginPage;
  static String getDoctorsListPageRoute({
    required String selectedDeptTitle,
    required String selectedDeptId
  }) => "$doctorsListPage?selectedDeptTitle=$selectedDeptTitle&selectedDeptId=$selectedDeptId";
  static String getDoctorsDetailsPageRoute({required String doctId}) => "$doctorsDetailsPage?doctId=$doctId";
  static String getEditUserProfilePageRoute() => editUserProfilePage;
  static String getContactUsPageRoute() => contactUsPage;
  static String getPatientFilePageRoute() => patientFilePage;
  static String getMedicalHistoryPageRoute() => medicalHistoryPage;
  // static String getPatientListPageRoute() => patientListPage;

  static String getMyBookingPageRoute() => myBookingPage;
  static String getAppointmentDetailsPageRoute({required String appId}) => "$appointmentDetailsPagePage?appId=$appId";

  static String getVitalsPageRoute() => vitalsPage;

  static String getShareAppPageRoute() => shareAppPage;
  static String getWalletPageRoute() => walletPage;
  static String getAboutUsPageRoute() => aboutUsPagePage;
  static String getPrivacyPagePageRoute() => privacyPage;
  static String getTermCondPageRoute() => termCondPage;

  static String getFamilyMemberListPageRoute() => familyMemberListPage;
  static String getTestimonialPageRoute() => testimonialPage;
  static String getNotificationPageRoute() => notificationPage;
  static String getNotificationDetailsPageRoute({
    required String? notificationId,
  }) => "$notificationDetailsPage?notificationId=$notificationId";
  static String getVitalsDetailsPageRoute({
    required String? notificationId,
  }) => "$vitalsDetailsPage?vitalName=$notificationId";
  static String getPrescriptionListPageRoute() => prescriptionListPage;
  static String getHomeStateRoute() => homeState; // New route method

  // New booking flow route methods
  // static String getAppointmentPackagePageRoute() => appointmentPackagePage;
  // static String getAppointmentBranchPageRoute({
  //   required String packageId,
  //   required String packageTitle,
  //   required String packageFee,
  // }) => "$appointmentBranchPage?packageId=$packageId&packageTitle=$packageTitle&packageFee=$packageFee";
  // static String getAppointmentDateTimePageRoute({
  //   required String packageId,
  //   required String packageTitle,
  //   required String packageFee,
  //   required String branchId,
  //   required String branchTitle,
  // }) => "$appointmentDateTimePage?packageId=$packageId&packageTitle=$packageTitle&packageFee=$packageFee&branchId=$branchId&branchTitle=$branchTitle";
  // static String getAppointmentSummaryPageRoute({
  //   required String packageId,
  //   required String packageTitle,
  //   required String packageFee,
  //   required String branchId,
  //   required String branchTitle,
  //   required String selectedDate,
  //   required String selectedTime,
  //   required String selectedEndTime,
  // }) => "$appointmentSummaryPage?packageId=$packageId&packageTitle=$packageTitle&packageFee=$packageFee&branchId=$branchId&branchTitle=$branchTitle&selectedDate=$selectedDate&selectedTime=$selectedTime&selectedEndTime=$selectedEndTime";

  static String getAppointmentSuccessPageRoute({
    required String appointmentId,
  }) => "$appointmentSuccessPage?appointmentId=$appointmentId";



  //---------------------------------------------------------------//

  static List<GetPage> routes = [
    //Splash Page
    GetPage(name: splashPage, page: () => const SplashScreen()),
    
    //Home Page
    GetPage(name: homePage, page: () => const HomePage()),

    GetPage(name: editUserProfilePage, page: () => const EditProfilePage()),
    GetPage(name: doctorsListPage, page: () =>  DoctorsListPage(
      selectedDeptId:  Get.parameters['selectedDeptId'],
      selectedDeptTitle:  Get.parameters['selectedDeptTitle']
    )),
    GetPage(name: doctorsDetailsPage, page: () =>  DoctorsDetailsPage(
      doctId: Get.parameters['doctId'],
    )),

    // GetPage(name: patientListPage, page: () => const PatientListPage()),

    GetPage(name: myBookingPage, page: () => const MyBookingPage()),
    GetPage(name: appointmentDetailsPagePage, page: () =>  AppointmentDetailsPage(
      appId: Get.parameters['appId'],
    )),

    GetPage(name: walletPage, page: () => const WalletPage()),

    GetPage(name: contactUsPage, page: () => const ContactUsPage()),

    GetPage(name: familyMemberListPage, page: () => const FamilyMemberListPage()),
    GetPage(name: aboutUsPagePage, page: () => const AboutUsPage()),
    GetPage(name: privacyPage, page: () => const PrivacyPage()),
    GetPage(name: termCondPage, page: () => const TermCondPage()),
    GetPage(name: testimonialPage, page: () => const TestimonialPage()),
    GetPage(name: shareAppPage, page: () => const ShareAppPage()),
    GetPage(name: notificationPage, page: () => const NotificationPage()),
    GetPage(name: notificationDetailsPage, page: () =>  NotificationDetailsPage(notificationId: Get.parameters['notificationId'] )),
    GetPage(name: vitalsPage, page: () =>  const VitalsPage()),
    GetPage(name: vitalsDetailsPage, page: () =>  VitalsDetailsPage(
      vitalName: Get.parameters['vitalName'],
    )),
    GetPage(name: prescriptionListPage, page: () =>  const PrescriptionListPage()),
    GetPage(name: patientFilePage, page: () =>  const PatientFilePage()),
    GetPage(name: medicalHistoryPage, page: () =>  const MedicalHistoryPage()),
    //GetPage(name: homeState, page: () =>  const HomeState()), // New route
    
    // New booking flow routes
    // GetPage(name: appointmentPackagePage, page: () => const AppointmentPackagePage()),
    // GetPage(name: appointmentBranchPage, page: () => AppointmentBranchPage(
    //   packageId: Get.parameters['packageId'] ?? '',
    //   packageTitle: Get.parameters['packageTitle'] ?? '',
    //   packageFee: Get.parameters['packageFee'] ?? '',
    // )),
    // GetPage(name: appointmentDateTimePage, page: () => AppointmentDateTimePage(
    //   packageId: Get.parameters['packageId'] ?? '',
    //   packageTitle: Get.parameters['packageTitle'] ?? '',
    //   packageFee: Get.parameters['packageFee'] ?? '',
    //   branchId: Get.parameters['branchId'] ?? '',
    //   branchTitle: Get.parameters['branchTitle'] ?? '',
    // )),
    // GetPage(name: appointmentSummaryPage, page: () => AppointmentSummaryPage(
    //   packageId: Get.parameters['packageId'] ?? '',
    //   packageTitle: Get.parameters['packageTitle'] ?? '',
    //   packageFee: Get.parameters['packageFee'] ?? '',
    //   branchId: Get.parameters['branchId'] ?? '',
    //   branchTitle: Get.parameters['branchTitle'] ?? '',
    //   selectedDate: Get.parameters['selectedDate'] ?? '',
    //   selectedTime: Get.parameters['selectedTime'] ?? '',
    //   selectedEndTime: Get.parameters['selectedEndTime'] ?? '',
    // )),
    GetPage(name: appointmentSuccessPage, page: () => AppointmentSuccessPage(
      appointmentId: Get.parameters['appointmentId'] ?? '',
    )),


  ];



}