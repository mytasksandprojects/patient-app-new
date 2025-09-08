// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Welcome!`
  String get Welcome {
    return Intl.message('Welcome!', name: 'Welcome', desc: '', args: []);
  }

  /// `How it's going today`
  String get How {
    return Intl.message(
      'How it\'s going today',
      name: 'How',
      desc: '',
      args: [],
    );
  }

  /// `Book Appointment`
  String get Book {
    return Intl.message('Book Appointment', name: 'Book', desc: '', args: []);
  }

  /// `Appointment`
  String get LAppointment {
    return Intl.message(
      'Appointment',
      name: 'LAppointment',
      desc: '',
      args: [],
    );
  }

  /// `Vitals`
  String get LVitals {
    return Intl.message('Vitals', name: 'LVitals', desc: '', args: []);
  }

  /// `Prescription`
  String get LPrescription {
    return Intl.message(
      'Prescription',
      name: 'LPrescription',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get LProfile {
    return Intl.message('Profile', name: 'LProfile', desc: '', args: []);
  }

  /// `Family Member`
  String get LFamilyMember {
    return Intl.message(
      'Family Member',
      name: 'LFamilyMember',
      desc: '',
      args: [],
    );
  }

  /// `Wallet`
  String get LWallet {
    return Intl.message('Wallet', name: 'LWallet', desc: '', args: []);
  }

  /// `Notification`
  String get LNotification {
    return Intl.message(
      'Notification',
      name: 'LNotification',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get LContactUs {
    return Intl.message('Contact Us', name: 'LContactUs', desc: '', args: []);
  }

  /// `Files`
  String get LFiles {
    return Intl.message('Files', name: 'LFiles', desc: '', args: []);
  }

  /// `Menu`
  String get LMenu {
    return Intl.message('Menu', name: 'LMenu', desc: '', args: []);
  }

  /// `Search`
  String get LSearch {
    return Intl.message('Search', name: 'LSearch', desc: '', args: []);
  }

  /// `Search for doctor, specialty, or hospital...`
  String get LSearchPlaceholder {
    return Intl.message(
      'Search for doctor, specialty, or hospital...',
      name: 'LSearchPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Branches`
  String get LBranches {
    return Intl.message('Branches', name: 'LBranches', desc: '', args: []);
  }

  /// `Select Branch`
  String get LSelectBranch {
    return Intl.message(
      'Select Branch',
      name: 'LSelectBranch',
      desc: '',
      args: [],
    );
  }

  /// `Tap to select branch`
  String get LTapToSelectBranch {
    return Intl.message(
      'Tap to select branch',
      name: 'LTapToSelectBranch',
      desc: '',
      args: [],
    );
  }

  /// `Current Location`
  String get LCurrentLocation {
    return Intl.message(
      'Current Location',
      name: 'LCurrentLocation',
      desc: '',
      args: [],
    );
  }

  /// `Swipe More>>`
  String get LSwipeMore {
    return Intl.message('Swipe More>>', name: 'LSwipeMore', desc: '', args: []);
  }

  /// `Share`
  String get LShare {
    return Intl.message('Share', name: 'LShare', desc: '', args: []);
  }

  /// `Testimonials`
  String get LTestimonials {
    return Intl.message(
      'Testimonials',
      name: 'LTestimonials',
      desc: '',
      args: [],
    );
  }

  /// `About Us`
  String get LAboutUs {
    return Intl.message('About Us', name: 'LAboutUs', desc: '', args: []);
  }

  /// `Privacy Policy`
  String get LPrivacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'LPrivacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Terms & Condition`
  String get LTermsCondition {
    return Intl.message(
      'Terms & Condition',
      name: 'LTermsCondition',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get LLogout {
    return Intl.message('Logout', name: 'LLogout', desc: '', args: []);
  }

  /// `Login`
  String get LLogin {
    return Intl.message('Login', name: 'LLogin', desc: '', args: []);
  }

  /// `Version`
  String get LVersion {
    return Intl.message('Version', name: 'LVersion', desc: '', args: []);
  }

  /// `My Booking`
  String get LMyBooking {
    return Intl.message('My Booking', name: 'LMyBooking', desc: '', args: []);
  }

  /// `Up coming`
  String get LUpcoming {
    return Intl.message('Up coming', name: 'LUpcoming', desc: '', args: []);
  }

  /// `Closed`
  String get LClosed {
    return Intl.message('Closed', name: 'LClosed', desc: '', args: []);
  }

  /// `Rebook`
  String get LRebook {
    return Intl.message('Rebook', name: 'LRebook', desc: '', args: []);
  }

  /// `Time: `
  String get LTime {
    return Intl.message('Time: ', name: 'LTime', desc: '', args: []);
  }

  /// `Name: `
  String get LName {
    return Intl.message('Name: ', name: 'LName', desc: '', args: []);
  }

  /// `JAN`
  String get month_jan {
    return Intl.message('JAN', name: 'month_jan', desc: '', args: []);
  }

  /// `FEB`
  String get month_feb {
    return Intl.message('FEB', name: 'month_feb', desc: '', args: []);
  }

  /// `MAR`
  String get month_mar {
    return Intl.message('MAR', name: 'month_mar', desc: '', args: []);
  }

  /// `APR`
  String get month_apr {
    return Intl.message('APR', name: 'month_apr', desc: '', args: []);
  }

  /// `MAY`
  String get month_may {
    return Intl.message('MAY', name: 'month_may', desc: '', args: []);
  }

  /// `JUN`
  String get month_jun {
    return Intl.message('JUN', name: 'month_jun', desc: '', args: []);
  }

  /// `JUL`
  String get month_jul {
    return Intl.message('JUL', name: 'month_jul', desc: '', args: []);
  }

  /// `AUG`
  String get month_aug {
    return Intl.message('AUG', name: 'month_aug', desc: '', args: []);
  }

  /// `SEP`
  String get month_sep {
    return Intl.message('SEP', name: 'month_sep', desc: '', args: []);
  }

  /// `OCT`
  String get month_oct {
    return Intl.message('OCT', name: 'month_oct', desc: '', args: []);
  }

  /// `NOV`
  String get month_nov {
    return Intl.message('NOV', name: 'month_nov', desc: '', args: []);
  }

  /// `DEC`
  String get month_dec {
    return Intl.message('DEC', name: 'month_dec', desc: '', args: []);
  }

  /// `Enter Conditionals to login`
  String get LEnterConditionalstologin {
    return Intl.message(
      'Enter Conditionals to login',
      name: 'LEnterConditionalstologin',
      desc: '',
      args: [],
    );
  }

  /// `Enter Phone Number`
  String get LEnterPhoneNumber {
    return Intl.message(
      'Enter Phone Number',
      name: 'LEnterPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get LSubmit {
    return Intl.message('Submit', name: 'LSubmit', desc: '', args: []);
  }

  /// `Enter valid number`
  String get LEntervalidnumber {
    return Intl.message(
      'Enter valid number',
      name: 'LEntervalidnumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter OTP`
  String get LEnterOTP {
    return Intl.message('Enter OTP', name: 'LEnterOTP', desc: '', args: []);
  }

  /// `OTP sent to`
  String get LOTPsentto {
    return Intl.message('OTP sent to', name: 'LOTPsentto', desc: '', args: []);
  }

  /// `Enter valid otp`
  String get LEntervalidOtp {
    return Intl.message(
      'Enter valid otp',
      name: 'LEntervalidOtp',
      desc: '',
      args: [],
    );
  }

  /// `OTP `
  String get LOTP {
    return Intl.message('OTP ', name: 'LOTP', desc: '', args: []);
  }

  /// `Cancel`
  String get LCancel {
    return Intl.message('Cancel', name: 'LCancel', desc: '', args: []);
  }

  /// `Resend`
  String get LResend {
    return Intl.message('Resend', name: 'LResend', desc: '', args: []);
  }

  /// `Register`
  String get LRegister {
    return Intl.message('Register', name: 'LRegister', desc: '', args: []);
  }

  /// `Enter first name`
  String get LEnterfirstname {
    return Intl.message(
      'Enter first name',
      name: 'LEnterfirstname',
      desc: '',
      args: [],
    );
  }

  /// `Enter Last name`
  String get LEnterLastname {
    return Intl.message(
      'Enter Last name',
      name: 'LEnterLastname',
      desc: '',
      args: [],
    );
  }

  /// `First Name*`
  String get LFirstName {
    return Intl.message('First Name*', name: 'LFirstName', desc: '', args: []);
  }

  /// `Last Name`
  String get LLastName {
    return Intl.message('Last Name', name: 'LLastName', desc: '', args: []);
  }

  /// `Verified`
  String get LVerified {
    return Intl.message('Verified', name: 'LVerified', desc: '', args: []);
  }

  /// `Something went wrong`
  String get LSomethingwentwrong {
    return Intl.message(
      'Something went wrong',
      name: 'LSomethingwentwrong',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid otp`
  String get LPleaseenteravalidotp {
    return Intl.message(
      'Please enter a valid otp',
      name: 'LPleaseenteravalidotp',
      desc: '',
      args: [],
    );
  }

  /// `Successfully Registered`
  String get LSuccessfullyRegistered {
    return Intl.message(
      'Successfully Registered',
      name: 'LSuccessfullyRegistered',
      desc: '',
      args: [],
    );
  }

  /// `Logged in`
  String get LLoggedin {
    return Intl.message('Logged in', name: 'LLoggedin', desc: '', args: []);
  }

  /// ` verId!`
  String get LverId {
    return Intl.message(' verId!', name: 'LverId', desc: '', args: []);
  }

  /// `Member since`
  String get LMembersince {
    return Intl.message(
      'Member since',
      name: 'LMembersince',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get LEditProfile {
    return Intl.message(
      'Edit Profile',
      name: 'LEditProfile',
      desc: '',
      args: [],
    );
  }

  /// `Length must be greater than 5 letters`
  String get LLengthValidation {
    return Intl.message(
      'Length must be greater than 5 letters',
      name: 'LLengthValidation',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get LEmail {
    return Intl.message('Email', name: 'LEmail', desc: '', args: []);
  }

  /// `Please enter a valid email`
  String get LEmailInvalid {
    return Intl.message(
      'Please enter a valid email',
      name: 'LEmailInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Date of Birth`
  String get LDOB {
    return Intl.message('Date of Birth', name: 'LDOB', desc: '', args: []);
  }

  /// `Gender`
  String get LGender {
    return Intl.message('Gender', name: 'LGender', desc: '', args: []);
  }

  /// `Select Gender*`
  String get LSelectGender {
    return Intl.message(
      'Select Gender*',
      name: 'LSelectGender',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get LMale {
    return Intl.message('Male', name: 'LMale', desc: '', args: []);
  }

  /// `Female`
  String get LFemale {
    return Intl.message('Female', name: 'LFemale', desc: '', args: []);
  }

  /// `Other`
  String get LOther {
    return Intl.message('Other', name: 'LOther', desc: '', args: []);
  }

  /// `Update`
  String get LUpdate {
    return Intl.message('Update', name: 'LUpdate', desc: '', args: []);
  }

  /// `Delete Profile`
  String get LDeleteProfile {
    return Intl.message(
      'Delete Profile',
      name: 'LDeleteProfile',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your profile?\nYou can't undo this action`
  String get LDeleteProfileConfirmation {
    return Intl.message(
      'Are you sure you want to delete your profile?\nYou can\'t undo this action',
      name: 'LDeleteProfileConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Warning`
  String get LWarning {
    return Intl.message('Warning', name: 'LWarning', desc: '', args: []);
  }

  /// `By deleting this profile, all details and points will also be deleted`
  String get LDeleteProfileWarning {
    return Intl.message(
      'By deleting this profile, all details and points will also be deleted',
      name: 'LDeleteProfileWarning',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get LSuccess {
    return Intl.message('Success', name: 'LSuccess', desc: '', args: []);
  }

  /// `Deleted successfully!`
  String get LSuccessDeleted {
    return Intl.message(
      'Deleted successfully!',
      name: 'LSuccessDeleted',
      desc: '',
      args: [],
    );
  }

  /// `New notifications`
  String get LNotificationDot {
    return Intl.message(
      'New notifications',
      name: 'LNotificationDot',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get LUser {
    return Intl.message('User', name: 'LUser', desc: '', args: []);
  }

  /// `Save`
  String get LSave {
    return Intl.message('Save', name: 'LSave', desc: '', args: []);
  }

  /// `Delete`
  String get LDelete {
    return Intl.message('Delete', name: 'LDelete', desc: '', args: []);
  }

  /// `Yes`
  String get LYes {
    return Intl.message('Yes', name: 'LYes', desc: '', args: []);
  }

  /// `No`
  String get LNo {
    return Intl.message('No', name: 'LNo', desc: '', args: []);
  }

  /// `No family member found . Click the + button at the bottom to add a new one`
  String get LNoFamilyMembers {
    return Intl.message(
      'No family member found . Click the + button at the bottom to add a new one',
      name: 'LNoFamilyMembers',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete?`
  String get LDeleteConfirmation {
    return Intl.message(
      'Are you sure you want to delete?',
      name: 'LDeleteConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Delete Family Member`
  String get LDeleteFamilyMember {
    return Intl.message(
      'Delete Family Member',
      name: 'LDeleteFamilyMember',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get LAddress {
    return Intl.message('Address', name: 'LAddress', desc: '', args: []);
  }

  /// `Phone`
  String get LPhone {
    return Intl.message('Phone', name: 'LPhone', desc: '', args: []);
  }

  /// `Search Report`
  String get LSearchReport {
    return Intl.message(
      'Search Report',
      name: 'LSearchReport',
      desc: '',
      args: [],
    );
  }

  /// `Current balance`
  String get LCurrentbalance {
    return Intl.message(
      'Current balance',
      name: 'LCurrentbalance',
      desc: '',
      args: [],
    );
  }

  /// `+ Add Money`
  String get LAddMoney {
    return Intl.message('+ Add Money', name: 'LAddMoney', desc: '', args: []);
  }

  /// `Transaction History`
  String get LTransactionHistory {
    return Intl.message(
      'Transaction History',
      name: 'LTransactionHistory',
      desc: '',
      args: [],
    );
  }

  /// `No transaction found`
  String get LNotransactionfound {
    return Intl.message(
      'No transaction found',
      name: 'LNotransactionfound',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message('Add', name: 'add', desc: '', args: []);
  }

  /// `Update`
  String get update {
    return Intl.message('Update', name: 'update', desc: '', args: []);
  }

  /// `New Family Member`
  String get new_family_member {
    return Intl.message(
      'New Family Member',
      name: 'new_family_member',
      desc: '',
      args: [],
    );
  }

  /// `Enter Valid Amount`
  String get LEnterValidAmount {
    return Intl.message(
      'Enter Valid Amount',
      name: 'LEnterValidAmount',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get LAmount {
    return Intl.message('Amount', name: 'LAmount', desc: '', args: []);
  }

  /// `Process`
  String get LProcess {
    return Intl.message('Process', name: 'LProcess', desc: '', args: []);
  }

  /// `No active payment gateway`
  String get LNoactivepaymentgateway {
    return Intl.message(
      'No active payment gateway',
      name: 'LNoactivepaymentgateway',
      desc: '',
      args: [],
    );
  }

  /// `Stripe`
  String get LStripe {
    return Intl.message('Stripe', name: 'LStripe', desc: '', args: []);
  }

  /// `Razorpay`
  String get LRazorpay {
    return Intl.message('Razorpay', name: 'LRazorpay', desc: '', args: []);
  }

  /// `Amount credited to user wallet`
  String get LAmountcreditedtouserwallet {
    return Intl.message(
      'Amount credited to user wallet',
      name: 'LAmountcreditedtouserwallet',
      desc: '',
      args: [],
    );
  }

  /// `Please fill the details`
  String get LPleasefillthedetails {
    return Intl.message(
      'Please fill the details',
      name: 'LPleasefillthedetails',
      desc: '',
      args: [],
    );
  }

  /// `Enter address`
  String get LEnteraddress {
    return Intl.message(
      'Enter address',
      name: 'LEnteraddress',
      desc: '',
      args: [],
    );
  }

  /// `Enter city`
  String get LEntercity {
    return Intl.message('Enter city', name: 'LEntercity', desc: '', args: []);
  }

  /// `City`
  String get LCity {
    return Intl.message('City', name: 'LCity', desc: '', args: []);
  }

  /// `Enter State`
  String get LEnterState {
    return Intl.message('Enter State', name: 'LEnterState', desc: '', args: []);
  }

  /// `State`
  String get LState {
    return Intl.message('State', name: 'LState', desc: '', args: []);
  }

  /// `Enter Country`
  String get LEnterCountry {
    return Intl.message(
      'Enter Country',
      name: 'LEnterCountry',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get LCountry {
    return Intl.message('Country', name: 'LCountry', desc: '', args: []);
  }

  /// `Proceed to pay`
  String get LProceedtopay {
    return Intl.message(
      'Proceed to pay',
      name: 'LProceedtopay',
      desc: '',
      args: [],
    );
  }

  /// `Share app with friends`
  String get LShareappwithfriends {
    return Intl.message(
      'Share app with friends',
      name: 'LShareappwithfriends',
      desc: '',
      args: [],
    );
  }

  /// `knock knock`
  String get Lknockknock {
    return Intl.message('knock knock', name: 'Lknockknock', desc: '', args: []);
  }

  /// `Acme Logo`
  String get LAcmeLogo {
    return Intl.message('Acme Logo', name: 'LAcmeLogo', desc: '', args: []);
  }

  /// `Blood Pressure`
  String get LBloodPressure {
    return Intl.message(
      'Blood Pressure',
      name: 'LBloodPressure',
      desc: '',
      args: [],
    );
  }

  /// `Sugar`
  String get LSugar {
    return Intl.message('Sugar', name: 'LSugar', desc: '', args: []);
  }

  /// `Weight`
  String get LWeight {
    return Intl.message('Weight', name: 'LWeight', desc: '', args: []);
  }

  /// `Temperature`
  String get LTemperature {
    return Intl.message(
      'Temperature',
      name: 'LTemperature',
      desc: '',
      args: [],
    );
  }

  /// `SpO2`
  String get LSpO2 {
    return Intl.message('SpO2', name: 'LSpO2', desc: '', args: []);
  }

  /// `Family Members`
  String get LFamilyMembers {
    return Intl.message(
      'Family Members',
      name: 'LFamilyMembers',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'LSelectVital*' key

  /// `Select Vital`
  String get LSelectVital {
    return Intl.message(
      'Select Vital',
      name: 'LSelectVital',
      desc: '',
      args: [],
    );
  }

  /// `BP Systolic`
  String get LBPSystolic {
    return Intl.message('BP Systolic', name: 'LBPSystolic', desc: '', args: []);
  }

  /// `BP Diastolic`
  String get LBPDiastolic {
    return Intl.message(
      'BP Diastolic',
      name: 'LBPDiastolic',
      desc: '',
      args: [],
    );
  }

  /// `Doctor Amr`
  String get LDoctorAmr {
    return Intl.message('Doctor Amr', name: 'LDoctorAmr', desc: '', args: []);
  }

  /// `Showing doctor from`
  String get LShowingdoctorfrom {
    return Intl.message(
      'Showing doctor from',
      name: 'LShowingdoctorfrom',
      desc: '',
      args: [],
    );
  }

  /// `Book Now`
  String get LBookNow {
    return Intl.message('Book Now', name: 'LBookNow', desc: '', args: []);
  }

  /// `Experience`
  String get LExperience {
    return Intl.message('Experience', name: 'LExperience', desc: '', args: []);
  }

  /// ` Year`
  String get LYear {
    return Intl.message(' Year', name: 'LYear', desc: '', args: []);
  }

  /// `Book Appointment`
  String get LBookAppointment {
    return Intl.message(
      'Book Appointment',
      name: 'LBookAppointment',
      desc: '',
      args: [],
    );
  }

  /// `Login/Signup`
  String get LLoginSignup {
    return Intl.message(
      'Login/Signup',
      name: 'LLoginSignup',
      desc: '',
      args: [],
    );
  }

  /// `Hello`
  String get LHello {
    return Intl.message('Hello', name: 'LHello', desc: '', args: []);
  }

  /// `Member`
  String get LMember {
    return Intl.message('Member', name: 'LMember', desc: '', args: []);
  }

  /// `Membership since`
  String get LMembershipsince {
    return Intl.message(
      'Membership since',
      name: 'LMembershipsince',
      desc: '',
      args: [],
    );
  }

  /// `Call`
  String get LCall {
    return Intl.message('Call', name: 'LCall', desc: '', args: []);
  }

  /// `Whatsapp`
  String get LWhatsapp {
    return Intl.message('Whatsapp', name: 'LWhatsapp', desc: '', args: []);
  }

  /// `Website`
  String get LWebsite {
    return Intl.message('Website', name: 'LWebsite', desc: '', args: []);
  }

  /// `Error parsing selected date`
  String get LErrorparsingselecteddate {
    return Intl.message(
      'Error parsing selected date',
      name: 'LErrorparsingselecteddate',
      desc: '',
      args: [],
    );
  }

  /// `Add New`
  String get LAddNew {
    return Intl.message('Add New', name: 'LAddNew', desc: '', args: []);
  }

  /// `Sorry, no available time slots were found for the selected date`
  String get LSorrynoavailable {
    return Intl.message(
      'Sorry, no available time slots were found for the selected date',
      name: 'LSorrynoavailable',
      desc: '',
      args: [],
    );
  }

  /// `Choose Date And Time`
  String get LChooseDateAndTime {
    return Intl.message(
      'Choose Date And Time',
      name: 'LChooseDateAndTime',
      desc: '',
      args: [],
    );
  }

  /// `Add/Select Family Member`
  String get LAddSelectFamilyMember {
    return Intl.message(
      'Add/Select Family Member',
      name: 'LAddSelectFamilyMember',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get LDate {
    return Intl.message('Date', name: 'LDate', desc: '', args: []);
  }

  /// `Appointments Done`
  String get LAppointmentsDone {
    return Intl.message(
      'Appointments Done',
      name: 'LAppointmentsDone',
      desc: '',
      args: [],
    );
  }

  /// `review`
  String get Lreview {
    return Intl.message('review', name: 'Lreview', desc: '', args: []);
  }

  /// `About`
  String get LAbout {
    return Intl.message('About', name: 'LAbout', desc: '', args: []);
  }

  /// `stop_booking`
  String get Lstopbooking {
    return Intl.message(
      'stop_booking',
      name: 'Lstopbooking',
      desc: '',
      args: [],
    );
  }

  /// `Patient`
  String get LPatient {
    return Intl.message('Patient', name: 'LPatient', desc: '', args: []);
  }

  /// `Register New Member`
  String get LRegisterNewMember {
    return Intl.message(
      'Register New Member',
      name: 'LRegisterNewMember',
      desc: '',
      args: [],
    );
  }

  /// `Enter last name`
  String get LEnterlastname {
    return Intl.message(
      'Enter last name',
      name: 'LEnterlastname',
      desc: '',
      args: [],
    );
  }

  /// `Only one step away,Pay and book your appointment.`
  String get LOnlyonestepawayPayandbookyourappointment {
    return Intl.message(
      'Only one step away,Pay and book your appointment.',
      name: 'LOnlyonestepawayPayandbookyourappointment',
      desc: '',
      args: [],
    );
  }

  /// `Doctor:`
  String get LDoctor {
    return Intl.message('Doctor:', name: 'LDoctor', desc: '', args: []);
  }

  /// `Date - Time:`
  String get LDateTime {
    return Intl.message('Date - Time:', name: 'LDateTime', desc: '', args: []);
  }

  /// `Appointment Fee:`
  String get LAppointmentFee {
    return Intl.message(
      'Appointment Fee:',
      name: 'LAppointmentFee',
      desc: '',
      args: [],
    );
  }

  /// `Coupon`
  String get LCoupon {
    return Intl.message('Coupon', name: 'LCoupon', desc: '', args: []);
  }

  /// `OFF`
  String get LOFF {
    return Intl.message('OFF', name: 'LOFF', desc: '', args: []);
  }

  /// `Total Amount:`
  String get LTotalAmount {
    return Intl.message(
      'Total Amount:',
      name: 'LTotalAmount',
      desc: '',
      args: [],
    );
  }

  /// `-$offPrice`
  String get LoffPrice {
    return Intl.message('-\$offPrice', name: 'LoffPrice', desc: '', args: []);
  }

  /// `Pay Now`
  String get LPayNow {
    return Intl.message('Pay Now', name: 'LPayNow', desc: '', args: []);
  }

  /// `Pay At clinic`
  String get LPayAtclinic {
    return Intl.message(
      'Pay At clinic',
      name: 'LPayAtclinic',
      desc: '',
      args: [],
    );
  }

  /// `Insufficient amount in your wallet`
  String get LInsufficientamountinyourwallet {
    return Intl.message(
      'Insufficient amount in your wallet',
      name: 'LInsufficientamountinyourwallet',
      desc: '',
      args: [],
    );
  }

  /// `Tap here to recharge wallet`
  String get LTapheretorechargewallet {
    return Intl.message(
      'Tap here to recharge wallet',
      name: 'LTapheretorechargewallet',
      desc: '',
      args: [],
    );
  }

  /// `The time has passed, please choose the different time`
  String get LThetimehaspassedpleasechoosethedifferenttime {
    return Intl.message(
      'The time has passed, please choose the different time',
      name: 'LThetimehaspassedpleasechoosethedifferenttime',
      desc: '',
      args: [],
    );
  }

  /// `Current not accepting appointment`
  String get LCurrentnotacceptingappointment {
    return Intl.message(
      'Current not accepting appointment',
      name: 'LCurrentnotacceptingappointment',
      desc: '',
      args: [],
    );
  }

  /// `Pay From Wallet (Available Balance {currency}{amount})`
  String LPayFromWallet(Object currency, Object amount) {
    return Intl.message(
      'Pay From Wallet (Available Balance $currency$amount)',
      name: 'LPayFromWallet',
      desc: '',
      args: [currency, amount],
    );
  }

  /// `Blood Pressure`
  String get blood_pressure {
    return Intl.message(
      'Blood Pressure',
      name: 'blood_pressure',
      desc: '',
      args: [],
    );
  }

  /// `Sugar`
  String get sugar {
    return Intl.message('Sugar', name: 'sugar', desc: '', args: []);
  }

  /// `Weight`
  String get weight {
    return Intl.message('Weight', name: 'weight', desc: '', args: []);
  }

  /// `Temperature`
  String get temperature {
    return Intl.message('Temperature', name: 'temperature', desc: '', args: []);
  }

  /// `SpO2`
  String get spo2 {
    return Intl.message('SpO2', name: 'spo2', desc: '', args: []);
  }

  /// `Family Members`
  String get family_members {
    return Intl.message(
      'Family Members',
      name: 'family_members',
      desc: '',
      args: [],
    );
  }

  /// `Add/Select Family Member`
  String get add_select_family_member {
    return Intl.message(
      'Add/Select Family Member',
      name: 'add_select_family_member',
      desc: '',
      args: [],
    );
  }

  /// `Add New`
  String get add_new {
    return Intl.message('Add New', name: 'add_new', desc: '', args: []);
  }

  /// `Register New Family Member`
  String get register_new_family_member {
    return Intl.message(
      'Register New Family Member',
      name: 'register_new_family_member',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get first_name {
    return Intl.message('First Name', name: 'first_name', desc: '', args: []);
  }

  /// `Last Name`
  String get last_name {
    return Intl.message('Last Name', name: 'last_name', desc: '', args: []);
  }

  /// `Enter first name`
  String get enter_first_name {
    return Intl.message(
      'Enter first name',
      name: 'enter_first_name',
      desc: '',
      args: [],
    );
  }

  /// `Enter last name`
  String get enter_last_name {
    return Intl.message(
      'Enter last name',
      name: 'enter_last_name',
      desc: '',
      args: [],
    );
  }

  /// `Enter valid number`
  String get enter_valid_number {
    return Intl.message(
      'Enter valid number',
      name: 'enter_valid_number',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
  }

  /// `Time`
  String get time {
    return Intl.message('Time', name: 'time', desc: '', args: []);
  }

  /// `Systolic`
  String get systolic {
    return Intl.message('Systolic', name: 'systolic', desc: '', args: []);
  }

  /// `mmHg`
  String get mmHg {
    return Intl.message('mmHg', name: 'mmHg', desc: '', args: []);
  }

  /// `Random`
  String get random {
    return Intl.message('Random', name: 'random', desc: '', args: []);
  }

  /// `Fasting`
  String get fasting {
    return Intl.message('Fasting', name: 'fasting', desc: '', args: []);
  }

  // skipped getter for the 'Mg/dl' key

  /// `KG`
  String get KG {
    return Intl.message('KG', name: 'KG', desc: '', args: []);
  }

  /// `F`
  String get F {
    return Intl.message('F', name: 'F', desc: '', args: []);
  }

  /// `%`
  String get percent {
    return Intl.message('%', name: 'percent', desc: '', args: []);
  }

  /// `Select Vital`
  String get select_vital {
    return Intl.message(
      'Select Vital',
      name: 'select_vital',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Are you sure want to delete this record?`
  String get delete_confirmation {
    return Intl.message(
      'Are you sure want to delete this record?',
      name: 'delete_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
  }

  /// `No`
  String get no {
    return Intl.message('No', name: 'no', desc: '', args: []);
  }

  /// `Select Date`
  String get select_date {
    return Intl.message('Select Date', name: 'select_date', desc: '', args: []);
  }

  /// `Submit`
  String get submit {
    return Intl.message('Submit', name: 'submit', desc: '', args: []);
  }

  /// `Temp`
  String get temp {
    return Intl.message('Temp', name: 'temp', desc: '', args: []);
  }

  /// `Are you sure?`
  String get are_you_sure {
    return Intl.message(
      'Are you sure?',
      name: 'are_you_sure',
      desc: '',
      args: [],
    );
  }

  /// `Please fill at least one filed`
  String get please_fill_at_least_one_field {
    return Intl.message(
      'Please fill at least one filed',
      name: 'please_fill_at_least_one_field',
      desc: '',
      args: [],
    );
  }

  /// `Enter value`
  String get enter_value {
    return Intl.message('Enter value', name: 'enter_value', desc: '', args: []);
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Ex 1234567890`
  String get ex_mobile {
    return Intl.message('Ex 1234567890', name: 'ex_mobile', desc: '', args: []);
  }

  /// `Add Blood Pressure`
  String get add_blood_pressure {
    return Intl.message(
      'Add Blood Pressure',
      name: 'add_blood_pressure',
      desc: '',
      args: [],
    );
  }

  /// `Add Weight`
  String get add_weight {
    return Intl.message('Add Weight', name: 'add_weight', desc: '', args: []);
  }

  /// `Add Temperature`
  String get add_temperature {
    return Intl.message(
      'Add Temperature',
      name: 'add_temperature',
      desc: '',
      args: [],
    );
  }

  /// `Add SpO2`
  String get add_spo2 {
    return Intl.message('Add SpO2', name: 'add_spo2', desc: '', args: []);
  }

  /// `Add Sugar`
  String get add_sugar {
    return Intl.message('Add Sugar', name: 'add_sugar', desc: '', args: []);
  }

  /// `Sugar Random`
  String get sugar_random {
    return Intl.message(
      'Sugar Random',
      name: 'sugar_random',
      desc: '',
      args: [],
    );
  }

  /// `Sugar Fasting`
  String get sugar_fasting {
    return Intl.message(
      'Sugar Fasting',
      name: 'sugar_fasting',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message('Clear', name: 'clear', desc: '', args: []);
  }

  /// `Success`
  String get success {
    return Intl.message('Success', name: 'success', desc: '', args: []);
  }

  /// `BP Systolic`
  String get bp_systolic {
    return Intl.message('BP Systolic', name: 'bp_systolic', desc: '', args: []);
  }

  /// `BP Diastolic`
  String get bp_diastolic {
    return Intl.message(
      'BP Diastolic',
      name: 'bp_diastolic',
      desc: '',
      args: [],
    );
  }

  /// `Mg/dl`
  String get units_Mgdl {
    return Intl.message('Mg/dl', name: 'units_Mgdl', desc: '', args: []);
  }

  /// `KG`
  String get units_KG {
    return Intl.message('KG', name: 'units_KG', desc: '', args: []);
  }

  /// `F`
  String get units_F {
    return Intl.message('F', name: 'units_F', desc: '', args: []);
  }

  /// `%`
  String get units_percent {
    return Intl.message('%', name: 'units_percent', desc: '', args: []);
  }

  /// `Add/Select Family Member`
  String get add_family_member {
    return Intl.message(
      'Add/Select Family Member',
      name: 'add_family_member',
      desc: '',
      args: [],
    );
  }

  /// `SpO2 (%)`
  String get SpO2 {
    return Intl.message('SpO2 (%)', name: 'SpO2', desc: '', args: []);
  }

  /// `Temp (°F)`
  String get temp_with_unit {
    return Intl.message(
      'Temp (°F)',
      name: 'temp_with_unit',
      desc: '',
      args: [],
    );
  }

  /// `Weight (KG)`
  String get weight_with_unit {
    return Intl.message(
      'Weight (KG)',
      name: 'weight_with_unit',
      desc: '',
      args: [],
    );
  }

  /// `Diastolic`
  String get diastolic {
    return Intl.message('Diastolic', name: 'diastolic', desc: '', args: []);
  }

  /// `Diastolic (mmHg)`
  String get diastolic_with_unit {
    return Intl.message(
      'Diastolic (mmHg)',
      name: 'diastolic_with_unit',
      desc: '',
      args: [],
    );
  }

  /// `mmHg`
  String get units_mmHg {
    return Intl.message('mmHg', name: 'units_mmHg', desc: '', args: []);
  }

  /// `Payment successful! Please don't close the app while we process your transaction.`
  String get Lpayment_success_message {
    return Intl.message(
      'Payment successful! Please don\'t close the app while we process your transaction.',
      name: 'Lpayment_success_message',
      desc: '',
      args: [],
    );
  }

  /// `Payment`
  String get LPayment {
    return Intl.message('Payment', name: 'LPayment', desc: '', args: []);
  }

  /// `Are you sure want to delete`
  String get LAreyousure {
    return Intl.message(
      'Are you sure want to delete',
      name: 'LAreyousure',
      desc: '',
      args: [],
    );
  }

  /// ` from family members list.`
  String get Lfromfamilymembers {
    return Intl.message(
      ' from family members list.',
      name: 'Lfromfamilymembers',
      desc: '',
      args: [],
    );
  }

  /// `Payment Success`
  String get LPaymentSuccess {
    return Intl.message(
      'Payment Success',
      name: 'LPaymentSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Please wait, while we are processing order id`
  String get LPleasewaitwhilewe {
    return Intl.message(
      'Please wait, while we are processing order id',
      name: 'LPleasewaitwhilewe',
      desc: '',
      args: [],
    );
  }

  /// `Transaction Id`
  String get LTransactionId {
    return Intl.message(
      'Transaction Id',
      name: 'LTransactionId',
      desc: '',
      args: [],
    );
  }

  /// `Enter name`
  String get Entername {
    return Intl.message('Enter name', name: 'Entername', desc: '', args: []);
  }

  /// `Payment success don't close the app`
  String get LPaymentsuccessdon {
    return Intl.message(
      'Payment success don\'t close the app',
      name: 'LPaymentsuccessdon',
      desc: '',
      args: [],
    );
  }

  /// `Payment error`
  String get LPaymenterror {
    return Intl.message(
      'Payment error',
      name: 'LPaymenterror',
      desc: '',
      args: [],
    );
  }

  /// `Coupon Removed`
  String get CouponRemoved {
    return Intl.message(
      'Coupon Removed',
      name: 'CouponRemoved',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get LApply {
    return Intl.message('Apply', name: 'LApply', desc: '', args: []);
  }

  /// `Remove`
  String get LRemove {
    return Intl.message('Remove', name: 'LRemove', desc: '', args: []);
  }

  /// `Enter Coupon Code IF Any`
  String get EnterCouponCodeIFAny {
    return Intl.message(
      'Enter Coupon Code IF Any',
      name: 'EnterCouponCodeIFAny',
      desc: '',
      args: [],
    );
  }

  /// `Coupon Code`
  String get CouponCode {
    return Intl.message('Coupon Code', name: 'CouponCode', desc: '', args: []);
  }

  /// `Blood Pressure`
  String get bloodPressure {
    return Intl.message(
      'Blood Pressure',
      name: 'bloodPressure',
      desc: '',
      args: [],
    );
  }

  /// `Click here to download prescription`
  String get Clickheretodownloadprescription {
    return Intl.message(
      'Click here to download prescription',
      name: 'Clickheretodownloadprescription',
      desc: '',
      args: [],
    );
  }

  /// `mmHg`
  String get mmHgUnit {
    return Intl.message('mmHg', name: 'mmHgUnit', desc: '', args: []);
  }

  /// `mg/dL`
  String get mgdlUnit {
    return Intl.message('mg/dL', name: 'mgdlUnit', desc: '', args: []);
  }

  /// `kg`
  String get kgUnit {
    return Intl.message('kg', name: 'kgUnit', desc: '', args: []);
  }

  /// `°F`
  String get fahrenheitUnit {
    return Intl.message('°F', name: 'fahrenheitUnit', desc: '', args: []);
  }

  /// `%`
  String get percentUnit {
    return Intl.message('%', name: 'percentUnit', desc: '', args: []);
  }

  /// `Appointment Id`
  String get LAppointmentId {
    return Intl.message(
      'Appointment Id',
      name: 'LAppointmentId',
      desc: '',
      args: [],
    );
  }

  /// `No Prescription Found!`
  String get NoPrescriptionFound {
    return Intl.message(
      'No Prescription Found!',
      name: 'NoPrescriptionFound',
      desc: '',
      args: [],
    );
  }

  /// `Visit the clinic and scan the provided QR code to instantly generate your appointment queue number.`
  String get VisittheclinicandscantheprovidedQRcodetoinstantly {
    return Intl.message(
      'Visit the clinic and scan the provided QR code to instantly generate your appointment queue number.',
      name: 'VisittheclinicandscantheprovidedQRcodetoinstantly',
      desc: '',
      args: [],
    );
  }

  /// `Patient Files`
  String get LPatientFiles {
    return Intl.message(
      'Patient Files',
      name: 'LPatientFiles',
      desc: '',
      args: [],
    );
  }

  /// `Click here to check the patient files`
  String get Clickheretocheckthepatientfiles {
    return Intl.message(
      'Click here to check the patient files',
      name: 'Clickheretocheckthepatientfiles',
      desc: '',
      args: [],
    );
  }

  /// `Cancellation Request History`
  String get CancellationRequestHistory {
    return Intl.message(
      'Cancellation Request History',
      name: 'CancellationRequestHistory',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure want to delete the cancellation request`
  String get Areyousurewanttodeletethecancellationrequest {
    return Intl.message(
      'Are you sure want to delete the cancellation request',
      name: 'Areyousurewanttodeletethecancellationrequest',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure want to cancel this appointment`
  String get Areyousurewanttocancelthisappointment {
    return Intl.message(
      'Are you sure want to cancel this appointment',
      name: 'Areyousurewanttocancelthisappointment',
      desc: '',
      args: [],
    );
  }

  /// `Doctor Review`
  String get DoctorReview {
    return Intl.message(
      'Doctor Review',
      name: 'DoctorReview',
      desc: '',
      args: [],
    );
  }

  /// `Give review to`
  String get Givereviewto {
    return Intl.message(
      'Give review to',
      name: 'Givereviewto',
      desc: '',
      args: [],
    );
  }

  /// `Current Status`
  String get CurrentStatus {
    return Intl.message(
      'Current Status',
      name: 'CurrentStatus',
      desc: '',
      args: [],
    );
  }

  /// `Click here to delete cancellation request`
  String get Clickheretodeletecancellationrequest {
    return Intl.message(
      'Click here to delete cancellation request',
      name: 'Clickheretodeletecancellationrequest',
      desc: '',
      args: [],
    );
  }

  /// `Click here to create cancellation request`
  String get Clickheretocreatecancellationrequest {
    return Intl.message(
      'Click here to create cancellation request',
      name: 'Clickheretocreatecancellationrequest',
      desc: '',
      args: [],
    );
  }

  /// `Appointment Cancellation`
  String get AppointmentCancellation {
    return Intl.message(
      'Appointment Cancellation',
      name: 'AppointmentCancellation',
      desc: '',
      args: [],
    );
  }

  /// `Review`
  String get LReview {
    return Intl.message('Review', name: 'LReview', desc: '', args: []);
  }

  /// `Click here to give doctor review`
  String get Clickheretogivedoctorreview {
    return Intl.message(
      'Click here to give doctor review',
      name: 'Clickheretogivedoctorreview',
      desc: '',
      args: [],
    );
  }

  /// `Make direction to clinic location`
  String get Makedirectiontocliniclocation {
    return Intl.message(
      'Make direction to clinic location',
      name: 'Makedirectiontocliniclocation',
      desc: '',
      args: [],
    );
  }

  /// `Download Invoice`
  String get DownloadInvoice {
    return Intl.message(
      'Download Invoice',
      name: 'DownloadInvoice',
      desc: '',
      args: [],
    );
  }

  /// `Payment Status`
  String get LPaymentStatus {
    return Intl.message(
      'Payment Status',
      name: 'LPaymentStatus',
      desc: '',
      args: [],
    );
  }

  /// `Video Call`
  String get VideoCall {
    return Intl.message('Video Call', name: 'VideoCall', desc: '', args: []);
  }

  /// `Queue Number`
  String get QueueNumber {
    return Intl.message(
      'Queue Number',
      name: 'QueueNumber',
      desc: '',
      args: [],
    );
  }

  /// `Check-In`
  String get CheckIn {
    return Intl.message('Check-In', name: 'CheckIn', desc: '', args: []);
  }

  /// `Pay From Wallet (Available Balance`
  String get PayFromWalletAvailableBalance {
    return Intl.message(
      'Pay From Wallet (Available Balance',
      name: 'PayFromWalletAvailableBalance',
      desc: '',
      args: [],
    );
  }

  /// `Pay`
  String get Pay {
    return Intl.message('Pay', name: 'Pay', desc: '', args: []);
  }

  /// `LightMode`
  String get LLightMode {
    return Intl.message('LightMode', name: 'LLightMode', desc: '', args: []);
  }

  /// `DarkMode`
  String get LDarkMode {
    return Intl.message('DarkMode', name: 'LDarkMode', desc: '', args: []);
  }

  /// `Follow Us`
  String get LFollowUs {
    return Intl.message('Follow Us', name: 'LFollowUs', desc: '', args: []);
  }

  /// `No links available`
  String get LNoLinksAvailable {
    return Intl.message(
      'No links available',
      name: 'LNoLinksAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Click to visit`
  String get LClickToVisit {
    return Intl.message(
      'Click to visit',
      name: 'LClickToVisit',
      desc: '',
      args: [],
    );
  }

  /// `Medical History`
  String get LMedicalHistory {
    return Intl.message(
      'Medical History',
      name: 'LMedicalHistory',
      desc: '',
      args: [],
    );
  }

  /// `Total Records`
  String get LTotalRecords {
    return Intl.message(
      'Total Records',
      name: 'LTotalRecords',
      desc: '',
      args: [],
    );
  }

  /// `Record Types`
  String get LRecordTypes {
    return Intl.message(
      'Record Types',
      name: 'LRecordTypes',
      desc: '',
      args: [],
    );
  }

  /// `No medical history found`
  String get LNoMedicalHistory {
    return Intl.message(
      'No medical history found',
      name: 'LNoMedicalHistory',
      desc: '',
      args: [],
    );
  }

  /// `Error loading medical history`
  String get LErrorLoadingHistory {
    return Intl.message(
      'Error loading medical history',
      name: 'LErrorLoadingHistory',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get LRefresh {
    return Intl.message('Refresh', name: 'LRefresh', desc: '', args: []);
  }

  /// `Iris`
  String get LIris {
    return Intl.message('Iris', name: 'LIris', desc: '', args: []);
  }

  /// `Lenses`
  String get LLenses {
    return Intl.message('Lenses', name: 'LLenses', desc: '', args: []);
  }

  /// `YAG Laser`
  String get LYagLaser {
    return Intl.message('YAG Laser', name: 'LYagLaser', desc: '', args: []);
  }

  /// `Retina Laser`
  String get LRetinaLaser {
    return Intl.message(
      'Retina Laser',
      name: 'LRetinaLaser',
      desc: '',
      args: [],
    );
  }

  /// `Oculoplasty Laser`
  String get LOculoplastyLaser {
    return Intl.message(
      'Oculoplasty Laser',
      name: 'LOculoplastyLaser',
      desc: '',
      args: [],
    );
  }

  /// `Glaucoma Laser`
  String get LGlaucomaLaser {
    return Intl.message(
      'Glaucoma Laser',
      name: 'LGlaucomaLaser',
      desc: '',
      args: [],
    );
  }

  /// `Dilatation`
  String get LDilatation {
    return Intl.message('Dilatation', name: 'LDilatation', desc: '', args: []);
  }

  /// `Complaint`
  String get LComplaint {
    return Intl.message('Complaint', name: 'LComplaint', desc: '', args: []);
  }

  /// `Remarks`
  String get LRemarks {
    return Intl.message('Remarks', name: 'LRemarks', desc: '', args: []);
  }

  /// `Management Plan`
  String get LManagementPlan {
    return Intl.message(
      'Management Plan',
      name: 'LManagementPlan',
      desc: '',
      args: [],
    );
  }

  /// `Comment`
  String get LComment {
    return Intl.message('Comment', name: 'LComment', desc: '', args: []);
  }

  /// `IOP Air Puff`
  String get LIopAirPuff {
    return Intl.message(
      'IOP Air Puff',
      name: 'LIopAirPuff',
      desc: '',
      args: [],
    );
  }

  /// `IOP App`
  String get LIopApp {
    return Intl.message('IOP App', name: 'LIopApp', desc: '', args: []);
  }

  /// `Left`
  String get LLeft {
    return Intl.message('Left', name: 'LLeft', desc: '', args: []);
  }

  /// `Right`
  String get LRight {
    return Intl.message('Right', name: 'LRight', desc: '', args: []);
  }

  /// `Visual Acuity`
  String get LVisualAcuity {
    return Intl.message(
      'Visual Acuity',
      name: 'LVisualAcuity',
      desc: '',
      args: [],
    );
  }

  /// `UCVA`
  String get LUCVA {
    return Intl.message('UCVA', name: 'LUCVA', desc: '', args: []);
  }

  /// `BCVA`
  String get LBCVA {
    return Intl.message('BCVA', name: 'LBCVA', desc: '', args: []);
  }

  /// `Autorefraction`
  String get LAutorefraction {
    return Intl.message(
      'Autorefraction',
      name: 'LAutorefraction',
      desc: '',
      args: [],
    );
  }

  /// `Sphere`
  String get LSphere {
    return Intl.message('Sphere', name: 'LSphere', desc: '', args: []);
  }

  /// `Cylinder`
  String get LCylinder {
    return Intl.message('Cylinder', name: 'LCylinder', desc: '', args: []);
  }

  /// `Axis`
  String get LAxis {
    return Intl.message('Axis', name: 'LAxis', desc: '', args: []);
  }

  /// `Anterior Segment`
  String get LAnteriorSegment {
    return Intl.message(
      'Anterior Segment',
      name: 'LAnteriorSegment',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get LClear {
    return Intl.message('Clear', name: 'LClear', desc: '', args: []);
  }

  /// `Cataract`
  String get LCataract {
    return Intl.message('Cataract', name: 'LCataract', desc: '', args: []);
  }

  /// `Pseudo`
  String get LPseudo {
    return Intl.message('Pseudo', name: 'LPseudo', desc: '', args: []);
  }

  /// `Aphakic`
  String get LAphakic {
    return Intl.message('Aphakic', name: 'LAphakic', desc: '', args: []);
  }

  /// `Sluggish`
  String get LSluggish {
    return Intl.message('Sluggish', name: 'LSluggish', desc: '', args: []);
  }

  /// `RAPD`
  String get LRAPD {
    return Intl.message('RAPD', name: 'LRAPD', desc: '', args: []);
  }

  /// `RRR`
  String get LRRR {
    return Intl.message('RRR', name: 'LRRR', desc: '', args: []);
  }

  /// `Power`
  String get LPower {
    return Intl.message('Power', name: 'LPower', desc: '', args: []);
  }

  /// `Brand`
  String get LBrand {
    return Intl.message('Brand', name: 'LBrand', desc: '', args: []);
  }

  /// `Color`
  String get LColor {
    return Intl.message('Color', name: 'LColor', desc: '', args: []);
  }

  /// `Base Curve`
  String get LBaseCurve {
    return Intl.message('Base Curve', name: 'LBaseCurve', desc: '', args: []);
  }

  /// `Landing Zone`
  String get LLandingZone {
    return Intl.message(
      'Landing Zone',
      name: 'LLandingZone',
      desc: '',
      args: [],
    );
  }

  /// `Saggital`
  String get LSaggital {
    return Intl.message('Saggital', name: 'LSaggital', desc: '', args: []);
  }

  /// `Edge`
  String get LEdge {
    return Intl.message('Edge', name: 'LEdge', desc: '', args: []);
  }

  /// `Capsulotomy`
  String get LCapsulotomy {
    return Intl.message(
      'Capsulotomy',
      name: 'LCapsulotomy',
      desc: '',
      args: [],
    );
  }

  /// `Iridotomy`
  String get LIridotomy {
    return Intl.message('Iridotomy', name: 'LIridotomy', desc: '', args: []);
  }

  /// `Hyaloidotomy`
  String get LHyaloidotomy {
    return Intl.message(
      'Hyaloidotomy',
      name: 'LHyaloidotomy',
      desc: '',
      args: [],
    );
  }

  /// `OD`
  String get LOD {
    return Intl.message('OD', name: 'LOD', desc: '', args: []);
  }

  /// `OS`
  String get LOS {
    return Intl.message('OS', name: 'LOS', desc: '', args: []);
  }

  /// `OU`
  String get LOU {
    return Intl.message('OU', name: 'LOU', desc: '', args: []);
  }

  /// `Focal`
  String get LFocal {
    return Intl.message('Focal', name: 'LFocal', desc: '', args: []);
  }

  /// `PRP`
  String get LPRP {
    return Intl.message('PRP', name: 'LPRP', desc: '', args: []);
  }

  /// `Barrage`
  String get LBarrage {
    return Intl.message('Barrage', name: 'LBarrage', desc: '', args: []);
  }

  /// `Around Breaks`
  String get LAroundBreaks {
    return Intl.message(
      'Around Breaks',
      name: 'LAroundBreaks',
      desc: '',
      args: [],
    );
  }

  /// `Scattered`
  String get LScattered {
    return Intl.message('Scattered', name: 'LScattered', desc: '', args: []);
  }

  /// `Lashes Roots`
  String get LLashesRoots {
    return Intl.message(
      'Lashes Roots',
      name: 'LLashesRoots',
      desc: '',
      args: [],
    );
  }

  /// `Transcribed Text`
  String get LTranscribedText {
    return Intl.message(
      'Transcribed Text',
      name: 'LTranscribedText',
      desc: '',
      args: [],
    );
  }

  /// `ALT`
  String get LALT {
    return Intl.message('ALT', name: 'LALT', desc: '', args: []);
  }

  /// `Iridoplasty`
  String get LIridoplasty {
    return Intl.message(
      'Iridoplasty',
      name: 'LIridoplasty',
      desc: '',
      args: [],
    );
  }

  /// `Suture Lysis`
  String get LSutureLysis {
    return Intl.message(
      'Suture Lysis',
      name: 'LSutureLysis',
      desc: '',
      args: [],
    );
  }

  /// `Iridectomy`
  String get LIridectomy {
    return Intl.message('Iridectomy', name: 'LIridectomy', desc: '', args: []);
  }

  /// `Mydriacyl`
  String get LMydriacyl {
    return Intl.message('Mydriacyl', name: 'LMydriacyl', desc: '', args: []);
  }

  /// `Phenyl`
  String get LPhenyl {
    return Intl.message('Phenyl', name: 'LPhenyl', desc: '', args: []);
  }

  /// `Cyclo AR`
  String get LCycloAR {
    return Intl.message('Cyclo AR', name: 'LCycloAR', desc: '', args: []);
  }

  /// `Pilocarpine`
  String get LPilocarpine {
    return Intl.message(
      'Pilocarpine',
      name: 'LPilocarpine',
      desc: '',
      args: [],
    );
  }

  /// `Step`
  String get LStep {
    return Intl.message('Step', name: 'LStep', desc: '', args: []);
  }

  /// `Record Details`
  String get LRecordDetails {
    return Intl.message(
      'Record Details',
      name: 'LRecordDetails',
      desc: '',
      args: [],
    );
  }

  /// `Created At`
  String get LCreatedAt {
    return Intl.message('Created At', name: 'LCreatedAt', desc: '', args: []);
  }

  /// `Updated At`
  String get LUpdatedAt {
    return Intl.message('Updated At', name: 'LUpdatedAt', desc: '', args: []);
  }

  /// `Upload File`
  String get LUploadFile {
    return Intl.message('Upload File', name: 'LUploadFile', desc: '', args: []);
  }

  /// `Upload Patient File`
  String get LUploadPatientFile {
    return Intl.message('Upload Patient File', name: 'LUploadPatientFile', desc: '', args: []);
  }

  /// `Select File`
  String get LSelectFile {
    return Intl.message('Select File', name: 'LSelectFile', desc: '', args: []);
  }

  /// `File Name`
  String get LFileName {
    return Intl.message('File Name', name: 'LFileName', desc: '', args: []);
  }

  /// `Enter file name`
  String get LEnterFileName {
    return Intl.message('Enter file name', name: 'LEnterFileName', desc: '', args: []);
  }

  /// `Please enter a file name`
  String get LPleaseEnterFileName {
    return Intl.message('Please enter a file name', name: 'LPleaseEnterFileName', desc: '', args: []);
  }

  /// `Uploading...`
  String get LUploading {
    return Intl.message('Uploading...', name: 'LUploading', desc: '', args: []);
  }

  /// `Error picking file: `
  String get LErrorPickingFile {
    return Intl.message('Error picking file: ', name: 'LErrorPickingFile', desc: '', args: []);
  }

  /// `File Selected`
  String get LFileSelected {
    return Intl.message('File Selected', name: 'LFileSelected', desc: '', args: []);
  }

  /// `Tap to select file`
  String get LTapToSelectFile {
    return Intl.message('Tap to select file', name: 'LTapToSelectFile', desc: '', args: []);
  }

  /// `PDF, DOC, DOCX, JPG, PNG, TXT`
  String get LSupportedFormats {
    return Intl.message('PDF, DOC, DOCX, JPG, PNG, TXT', name: 'LSupportedFormats', desc: '', args: []);
  }

  /// `Unknown file`
  String get LUnknownFile {
    return Intl.message('Unknown file', name: 'LUnknownFile', desc: '', args: []);
  }

  /// `Uploading... {percent}%`
  String LUploadingProgress(Object percent) {
    return Intl.message('Uploading... $percent%', name: 'LUploadingProgress', desc: '', args: [percent]);
  }

  /// `Unknown size`
  String get LUnknownSize {
    return Intl.message('Unknown size', name: 'LUnknownSize', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
