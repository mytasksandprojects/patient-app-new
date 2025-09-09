import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:star_rating/star_rating.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:userapp/Language.dart';
import 'package:userapp/generated/l10n.dart';
import 'package:userapp/model/appointment_categories.dart';
import 'package:userapp/model/doctors_review_model.dart';
import 'package:userapp/pages/stripe_payment_page.dart';
import '../controller/boked_time_slot_controller.dart';
import '../controller/time_slots_controller.dart';
import '../controller/depratment_controller.dart';
import '../controller/branch_doctor_controller.dart';
import '../helpers/route_helper.dart';
import '../model/booked_time_slot_mdel.dart';
import '../model/time_slots_model.dart';
import '../model/user_model.dart';
import '../model/department_model.dart';
import '../pages/razor_pay_payment_page.dart';
import '../services/appointment_service.dart';
import '../services/coupon_service.dart';
import '../services/doctor_service.dart';
import '../services/department_service.dart';
import '../services/family_members_service.dart';
import '../services/stripe_service.dart';
import '../services/user_service.dart';
import '../services/branch_doctor_service.dart';
import '../services/patient_service.dart';
import '../utilities/app_constans.dart';
import '../widget/loading_Indicator_widget.dart';
import '../helpers/date_time_helper.dart';
import '../helpers/theme_helper.dart';
import '../model/doctors_model.dart';
import '../model/family_members_model.dart';
import '../model/branch_doctor_model.dart';
import '../services/configuration_service.dart';
import '../services/payment_gateway_service.dart';
import '../services/razor_pay_service.dart';
import '../utilities/api_content.dart';
import '../utilities/colors_constant.dart';
import '../utilities/image_constants.dart';
import '../widget/app_bar_widget.dart';
import '../widget/button_widget.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:intl/intl.dart';
import '../widget/image_box_widget.dart';
import '../widget/toast_message.dart';
import 'package:country_picker/country_picker.dart';

class DoctorsDetailsPage extends StatefulWidget {
  final String? doctId;

  const DoctorsDetailsPage({super.key, required this.doctId});

  @override
  State<DoctorsDetailsPage> createState() => _DoctorsDetailsPageState();
}

class _DoctorsDetailsPageState extends State<DoctorsDetailsPage> {
  UserModel? userModel;
  ScrollController scrollController = ScrollController();
  String _selectedDate = "";
  String _setTime = "";
  String _endTime = "";
  String phoneCode = "+";
  DoctorsModel? _doctorsModel;
  String _selectedAppointmentType = "0";
  List<FamilyMembersModel> familyModelList = [];
  FamilyMembersModel? selectedFamilyMemberModel;
  int payNow = 0;
  bool couponEnable = true;
  double appointmentFee = 0;
  double totalAmount = 0;
  double offPrice = 0;
  int? couponId;
  double? couponValue;
  double tax = 0;
  double unitTaxAmount = 0;
  double unitTotalAmount = 0;
  String? activePaymentGatewayName;
  String? activePaymentGatewayKey;
  String? activePaymentGatewaySecret;
  List<DoctorsReviewModel> doctorReviewModel = [];
  List<AppointmentCategory> _appointmentCategories = [];
  AppointmentCategory? _selectedAppointmentCategory;
  List<AppointmentType> _selectedCategoryTypes = [];
  int? _selectedCategoryId;
  int? _selectedSubTypeId;
  int? _selectedAppointmentId;

  // Branch/Department related variables
  List<DepartmentModel> _branches = [];
  DepartmentModel? _selectedBranch;
  BranchDoctorModel? _selectedBranchDoctor;
  String? _currentDoctorId; // Track the current doctor ID being used
  String? _patientId; // Store the correct patient ID from PatientsService

  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _couponNameController = TextEditingController();

  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  final DateTime _todayDayTime = DateTime.now();
  final TimeSlotsController _timeSlotsController =
      Get.put(TimeSlotsController());
  final BookedTimeSlotsController _bookedTimeSlotsController =
      Get.put(BookedTimeSlotsController());
  final DepartmentController _departmentController =
      Get.put(DepartmentController(), tag: "department_branches");
  final BranchDoctorController _branchDoctorController =
      Get.put(BranchDoctorController(), tag: "branch_doctors");
  double? clinicVisitFee;
  double? clinicVisitServiceCharge;
  double? videoFee;
  double? videoServiceCharge;
  double? emergencyFee;
  double? emergencyServiceCharge;
  bool stopBooking = false;

  @override
  void initState() {
    phoneCode = AppConstants.defaultCountyCode;
    getAndSetData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.bgColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: ColorResources.bgColor,
          elevation: 0,
          leading: IconButton(
            icon: Container(
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
                Icons.arrow_back,
                color: ColorResources.primaryColor,
                size: 20,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            S.of(context).LBookAppointment,
            style: const TextStyle(
              color: ColorResources.primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: _doctorsModel == null || _isLoading
          ? const ILoadingIndicatorWidget()
          : _buildBody(_doctorsModel!),
    );
  }

  _buildBody(DoctorsModel doctorsModel) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProfileSection(),
          //const SizedBox(height: 16),
          //_buildExReCard(),
          const SizedBox(height: 16),
          _buildBranchSelectionCard(),
          const SizedBox(height: 16),
          _buildDoctorSelectionCard(),
          const SizedBox(height: 16),
          buildAppointmentTypesGrid(doctorsModel),
          const SizedBox(height: 16),

          _buildFamilyMemberCard(),

          _selectedAppointmentType == "0" ? Container() : buildOpDetails(),
          doctorReviewModel.isEmpty ? Container() : _buildRatingReviewBox(),

          const SizedBox(height: 16),
          // doctorsModel.desc == null
          //     ? Container()
          //     : buildTitleAndDesBox(
          //         S.of(context).LAbout, doctorsModel.desc ?? ""),
        ],
      ),
    );
  }

  _buildProfileSection() {
    return Container(
      decoration: BoxDecoration(
        color: ColorResources.darkCardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorResources.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        ColorResources.primaryColor,
                        ColorResources.secondaryColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(3),
                  child: Stack(
                    children: [
                      Column(children: [
                        _doctorsModel!.image == null || _doctorsModel!.image == ""
                            ? Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: ColorResources.darkCardColor,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 40,
                            color: ColorResources.primaryColor,
                          ),
                        )
                            : ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: SizedBox(
                            height: 80,
                            width: 80,
                            child: ImageBoxFillWidget(
                              imageUrl:
                              "${ApiContents.imageUrl}/${_doctorsModel!.image}",
                              boxFit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Text(
                          S.of(context).LExperience,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: ColorResources.bgColor,
                          ),
                        ),
                        Text(
                          "${_doctorsModel?.exYear ?? "0"} ${S.of(context).LYear}",
                          style: const TextStyle(
                            color: ColorResources.bgColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],),

                      // Positioned(
                      //   bottom: 2,
                      //   right: 2,
                      //   child: Container(
                      //     width: 16,
                      //     height: 16,
                      //     decoration: BoxDecoration(
                      //       color: Colors.green,
                      //       shape: BoxShape.circle,
                      //       border: Border.all(
                      //         color: ColorResources.darkCardColor,
                      //         width: 2,
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${_doctorsModel?.fName ?? "--"} ${_doctorsModel?.lName ?? "--"}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: ColorResources.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: ColorResources.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: ColorResources.primaryColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _doctorsModel?.specialization ?? "",
                          style: TextStyle(
                            color: ColorResources.primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                     // const SizedBox(height: 8),
                      //    Row(
                      //      children: [
                      //        StarRating(
                      //          mainAxisAlignment: MainAxisAlignment.center,
                      //        length: 5,
                      //      color: _doctorsModel?.averageRating == 0
                      //        ? Colors.grey
                      //      : Colors.amber,
                      // rating: _doctorsModel?.averageRating ?? 0,
                      //     between: 5,
                      //    starSize: 15,
                      //    onRaitingTap: (rating) {},
                      //  ),
                      //  const SizedBox(width: 10),
                      //  Text(
                      //    "${_doctorsModel?.averageRating} (${_doctorsModel?.numberOfReview} ${S.of(context).Lreview})",
                      //    style: const TextStyle(
                      //        color: ColorResources.secondaryFontColor,
                      //        fontWeight: FontWeight.w500,
                      //        fontSize: 12),
                      //  )
                      //],
                      //   ),
                      const SizedBox(height: 5),
                      //   Row(
                      //       children: [
                      //           const Icon(Icons.person,
                      //              color: ColorResources.iconColor, size: 15),
                      //       const SizedBox(width: 5),
                      //      Text(
                      //        "${_doctorsModel?.totalAppointmentDone ?? "0"} ${S.of(context).LAppointmentsDone}",
                      //        style: const TextStyle(
                      //            color: ColorResources.secondaryFontColor,
                      //             fontWeight: FontWeight.w500,
                      //             fontSize: 12),
                      //       )
                      //     ],
                      //   ),
                      //   _buildSocialMediaSection()
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // buildTitleAndDesBox(String title, String subTitle) {
  //   return ListTile(
  //     title: Text(
  //       title,
  //       style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
  //     ),
  //     subtitle: Text(
  //       subTitle,
  //       style: const TextStyle(
  //           color: ColorResources.secondaryFontColor,
  //           fontWeight: FontWeight.w400,
  //           fontSize: 13),
  //     ),
  //   );
  // }

  Widget buildAppointmentTypesGrid(DoctorsModel doctorsModel) {
    if (_appointmentCategories.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.9,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: _appointmentCategories.length,
          itemBuilder: (context, index) {
            final category = _appointmentCategories[index];
           // _selectedAppointmentCategory=category;
            final isAvailable =
                isCategoryAvailable(doctorsModel, category); // <--
            return _buildTypeCard(category, isAvailable);
          },
        ),
        if (_selectedAppointmentType != "0" &&
            _selectedCategoryTypes.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 16),
            width: MediaQuery.of(context).size.width / 1.1,
            decoration: BoxDecoration(
              color: ColorResources.darkCardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: ColorResources.primaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _selectedCategoryTypes.map((type) {
                      final isSelected = _selectedSubTypeId == type.id;
                      _selectedAppointmentId=type.appointmentCategoryId;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedSubTypeId = isSelected ? null : type.id;
                            _selectedAppointmentId=type.appointmentCategoryId;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? ColorResources.primaryColor.withOpacity(0.1)
                                : ColorResources.bgColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? ColorResources.primaryColor
                                  : ColorResources.primaryColor
                                      .withOpacity(0.3),
                              width: isSelected ? 2 : 1,
                            ),
                            gradient: isSelected
                                ? LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      ColorResources.primaryColor
                                          .withOpacity(0.05),
                                      ColorResources.secondaryColor
                                          .withOpacity(0.02),
                                    ],
                                  )
                                : null,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isSelected)
                                Container(
                                  width: 16,
                                  height: 16,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        ColorResources.primaryColor,
                                        ColorResources.secondaryColor,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Color(0xFF0f0f0f),
                                    size: 12,
                                  ),
                                ),
                              Text(
                                LanguageController.to.isArabic.value
                                    ? type.labelAr ?? ""
                                    : type.label ?? "",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: isSelected
                                      ? ColorResources.primaryColor
                                      : ColorResources.primaryColor
                                          .withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTypeCard(AppointmentCategory category, bool isAvailable) {
    final isSelected = _selectedAppointmentType == category.id.toString();

    return GestureDetector(
      onTap: isAvailable
          ? () {
              setState(() {
                _selectedAppointmentType = category.id.toString();
                _selectedCategoryId = category.id;
                _selectedCategoryTypes = category.types ?? [];
                _selectedSubTypeId = null;
                _selectedAppointmentId=null;
                _selectedAppointmentCategory=category;
                appointmentFee = getFeeFilter(_selectedAppointmentType);
                amtCalculation();
                
                // Clear selected time when appointment type changes
                _setTime = "";
                
                // Refresh time slots for new appointment type (except emergency)
                if (_selectedAppointmentType != "3") {
                  _refreshTimeSlots();
                }
              });
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? ColorResources.darkCardColor
              : ColorResources.darkCardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? ColorResources.primaryColor
                : ColorResources.primaryColor.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    ColorResources.primaryColor.withOpacity(0.1),
                    ColorResources.secondaryColor.withOpacity(0.05),
                  ],
                )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 10,
                height: 40,
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [
                            ColorResources.primaryColor,
                            ColorResources.secondaryColor,
                          ],
                        )
                      : LinearGradient(
                          colors: [
                            ColorResources.primaryColor.withOpacity(0.1),
                            ColorResources.secondaryColor.withOpacity(0.1),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIconForCategory(category.id ?? 0),
                  size: 24,
                  color: !isAvailable
                      ? Colors.grey
                      : isSelected
                          ? const Color(0xFF0f0f0f)
                          : ColorResources.primaryColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                LanguageController.to.isArabic.value
                    ? category.labelAr ?? ""
                    : category.label ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: !isAvailable
                      ? Colors.grey
                      : isSelected
                          ? ColorResources.primaryColor
                          : ColorResources.primaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "${getFeeFilter(category.id.toString())} ${AppConstants.appCurrency}",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: !isAvailable
                      ? Colors.grey
                      : ColorResources.secondaryFontColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForCategory(int categoryId) {
    switch (categoryId) {
      case 1:
        return Icons.medical_services; // Examinations
      case 2:
        return Icons.medical_information; // Operations
      case 3:
        return Icons.visibility; // Detection
      case 4:
        return Icons.videocam; // Video Call
      case 5:
        return Icons.emergency; // Emergency
      case 6:
        return Icons.star; // VIP
      default:
        return Icons.calendar_today;
    }
  }

  buildOpDetails() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: ColorResources.darkCardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: ColorResources.primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          ColorResources.primaryColor,
                          ColorResources.secondaryColor,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getIconForCategory(
                          int.tryParse(_selectedAppointmentType) ?? 0),
                      color: const Color(0xFF0f0f0f),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      LanguageController.to.isArabic.value
                          ? _selectedAppointmentCategory?.labelAr ?? ""
                          : _selectedAppointmentCategory?.label ?? "",
                      //getAppTypeName(_selectedAppointmentType),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: ColorResources.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      ColorResources.primaryColor.withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).LDate,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: ColorResources.secondaryFontColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            _timeSlotsController.getData(
                                widget.doctId ?? "",
                                DateTimeHelper.getDayName(
                                    _todayDayTime.weekday),
                                _selectedAppointmentType,_selectedBranch?.id?.toString() ?? "");
                            _bookedTimeSlotsController.getData(
                                widget.doctId ?? "",
                                DateTimeHelper.getYYYMMDDFormatDate(
                                    _todayDayTime.toString()),_selectedBranch?.id?.toString() ?? "");
                            _openBottomSheet();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: ColorResources.bgColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: ColorResources.primaryColor
                                    .withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          ColorResources.primaryColor,
                                          ColorResources.secondaryColor,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.calendar_month,
                                      color: Color(0xFF0f0f0f),
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      _selectedDate == ""
                                          ? "--"
                                          : DateTimeHelper.getDataFormat(
                                              _selectedDate),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: ColorResources.primaryColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).LTime,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: ColorResources.secondaryFontColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            _timeSlotsController.getData(
                                widget.doctId ?? "",
                                DateTimeHelper.getDayName(
                                    _todayDayTime.weekday),
                                _selectedAppointmentType,_selectedBranch?.id?.toString() ?? "");
                            _bookedTimeSlotsController.getData(
                                widget.doctId ?? "",
                                DateTimeHelper.getYYYMMDDFormatDate(
                                    _todayDayTime.toString()),_selectedBranch?.id?.toString() ?? "");
                            _openBottomSheet();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: ColorResources.bgColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: ColorResources.primaryColor
                                    .withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          ColorResources.primaryColor,
                                          ColorResources.secondaryColor,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.access_time,
                                      color: Color(0xFF0f0f0f),
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      _setTime == ""
                                          ? "--"
                                        : DateTimeHelper
                                              .convertTo12HourFormat(_setTime),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: ColorResources.primaryColor,

                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SmallButtonsWidget(
                  title: S.of(context).LBookNow,
                  onPressed: _doctorsModel?.stopBooking == 1 || stopBooking
                      ? null
                      : () {
                          // First check if branch is selected
                          if (_selectedBranch == null) {
                            IToastMsg.showMessage(
                                "Please select a branch first");
                            return;
                          }

                          // Check if doctor is selected for the branch
                          if (_selectedBranchDoctor == null) {
                            IToastMsg.showMessage(
                                "Please wait for doctor to load or try selecting branch again");
                            return;
                          }

                          if (_selectedAppointmentType == "3") {
                            if (selectedFamilyMemberModel != null) {
                              openAppointmentBox();
                            } else {
                              if (familyModelList.isEmpty) {
                                _openBottomSheetAddPatient();
                              } else {
                                _openBottomSheetPatient();
                              }
                            }
                                                      } else {
                              if (_selectedDate == "" || _setTime == "") {
                                _timeSlotsController.getData(
                                    _getCurrentDoctorId(),
                                    DateTimeHelper.getDayName(
                                        _todayDayTime.weekday),
                                    _selectedAppointmentType,_selectedBranch?.id?.toString() ?? "");
                                _bookedTimeSlotsController.getData(
                                    _getCurrentDoctorId(),
                                    DateTimeHelper.getYYYMMDDFormatDate(
                                        _todayDayTime.toString()),_selectedBranch?.id?.toString() ?? "");
                                _openBottomSheet();
                                return;
                            } else if (_selectedDate != "" && _setTime != "") {
                              if (selectedFamilyMemberModel != null) {
                                openAppointmentBox();
                              } else {
                                if (familyModelList.isEmpty) {
                                  _openBottomSheetAddPatient();
                                } else {
                                  _openBottomSheetPatient();
                                }
                              }
                              //Named(RouteHelper.getPatientListPageRoute());
                            }
                          }
                        }),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  _openBottomSheetPatient() {
    return showModalBottomSheet(
      backgroundColor: ColorResources.bgColor,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: const BoxDecoration(
                color: ColorResources.bgColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                ),
              ),
              //  height: 260.0,
              child: Stack(
                children: [
                  Positioned(
                      top: 10,
                      right: 20,
                      left: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            S.of(context).LAddSelectFamilyMember,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.back();
                              _openBottomSheetAddPatient();
                            },
                            child: Card(
                              color: ColorResources.btnColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(S.of(context).LAddNew,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                          )
                        ],
                      )),
                  Positioned(
                      top: 60,
                      left: 5,
                      right: 5,
                      bottom: 0,
                      child: ListView(
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: familyModelList.length,
                              itemBuilder: (context, index) {
                                FamilyMembersModel familyModel =
                                    familyModelList[index];
                                return Card(
                                    color: ColorResources.cardBgColor,
                                    elevation: .1,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: ListTile(
                                      onTap: () {
                                        selectedFamilyMemberModel = familyModel;
                                        this.setState(() {});
                                        Get.back();
                                        if (_selectedAppointmentType == "3") {
                                          if (selectedFamilyMemberModel !=
                                              null) {
                                            openAppointmentBox();
                                          }
                                        } else {
                                          if (_selectedDate == "" ||
                                              _setTime == "") {
                                            _timeSlotsController.getData(
                                                _getCurrentDoctorId(),
                                                DateTimeHelper.getDayName(
                                                    _todayDayTime.weekday),
                                                _selectedAppointmentType,_selectedBranch?.id?.toString() ?? "");
                                            _bookedTimeSlotsController.getData(
                                                _getCurrentDoctorId(),
                                                DateTimeHelper
                                                    .getYYYMMDDFormatDate(
                                                        _todayDayTime
                                                            .toString()),_selectedBranch?.id?.toString() ?? "");
                                            _openBottomSheet();
                                            return;
                                          } else if (_selectedDate != "" &&
                                              _setTime != "") {
                                            if (selectedFamilyMemberModel !=
                                                null) {
                                              openAppointmentBox();
                                            }
                                            //Named(RouteHelper.getPatientListPageRoute());
                                          }
                                        }
                                      },
                                      leading: const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      ),
                                      title: Text(
                                        "${familyModel.fName} ${familyModel.lName}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      subtitle: Text(
                                        "${familyModel.phone}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ));
                              }),
                        ],
                      )),
                ],
              ));
        });
      },
    ).whenComplete(() {});
  }

  _openBottomSheet() {
    return showModalBottomSheet(
      backgroundColor: ColorResources.bgColor,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.9,
              decoration: const BoxDecoration(
                color: ColorResources.bgColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                ),
              ),
              //  height: 260.0,
              child: Stack(
                children: [
                  Positioned(
                      top: 10,
                      right: 20,
                      left: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            S.of(context).LChooseDateAndTime,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              )),
                        ],
                      )),
                  Positioned(
                      top: 60,
                      left: 5,
                      right: 5,
                      bottom: 0,
                      child: ListView(
                        children: [
                          _buildCalendar(setState),
                          const Divider(),
                          Obx(() {
                            // if (!_timeSlotsController.isError.value &&
                            //     !_bookedTimeSlotsController.isError.value) {
                              // if no any error
                              if (_timeSlotsController.isLoading.value ||
                                  _bookedTimeSlotsController.isLoading.value) {
                                return const ILoadingIndicatorWidget();
                              } else if (_timeSlotsController
                                  .dataList.isEmpty) {
                                return Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.red.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.warning_amber_rounded,
                                          color: Colors.red,
                                          size: 24,
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            S.of(context).LSorrynoavailable,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                return _slotsGridView(
                                    setState,
                                    _timeSlotsController.dataList,
                                    _bookedTimeSlotsController.dataList);
                              }
                            // } else {
                            //   return Padding(
                            //     padding: EdgeInsets.all(20.0),
                            //     child: Container(
                            //       padding: EdgeInsets.all(16),
                            //       decoration: BoxDecoration(
                            //         color: Colors.red.withOpacity(0.1),
                            //         borderRadius: BorderRadius.circular(12),
                            //         border: Border.all(
                            //           color: Colors.red.withOpacity(0.3),
                            //           width: 1,
                            //         ),
                            //       ),
                            //       child: Row(
                            //         children: [
                            //           Icon(
                            //             Icons.error_outline,
                            //             color: Colors.red,
                            //             size: 24,
                            //           ),
                            //           SizedBox(width: 12),
                            //           Expanded(
                            //             child: Text(
                            //               S.of(context).LSomethingwentwrong,
                            //               style: TextStyle(
                            //                 fontWeight: FontWeight.w600,
                            //                 fontSize: 16,
                            //                 color: Colors.white,
                            //               ),
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //   );
                            // } //Error svg
                          })
                        ],
                      )),
                ],
              ));
        });
      },
    ).whenComplete(() {});
  }

  Widget _buildCalendar(setState) {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: DatePicker(
        DateTime.now(),
        initialSelectedDate: _parseSelectedDate(_selectedDate),
        selectionColor: ColorResources.primaryColor,
        selectedTextColor: Colors.white,
        dateTextStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        dayTextStyle: TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.w500,
        ),
        monthTextStyle: TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.w500,
        ),
        daysCount: 7,
        onDateChange: (date) {
          _handleDateChange(date, setState);
        },
      ),
    );
  }

  DateTime _parseSelectedDate(String dateString) {
    try {
      return DateFormat('yyyy-MM-dd').parse(dateString);
    } catch (e) {
      debugPrint('${S.of(context).LErrorparsingselecteddate}: $e');
      return DateTime.now();
    }
  }

  void _handleDateChange(DateTime date, StateSetter setState) {
    final formattedDate = DateFormat('yyyy-MM-dd',"en").format(date);

    setState(() {
      _selectedDate = formattedDate;
    });
    _fetchTimeSlots(date);
    _fetchBookedSlots(formattedDate);
  }

  void _fetchTimeSlots(DateTime date) {
    _timeSlotsController.getData(_getCurrentDoctorId(),
        DateTimeHelper.getDayName(date.weekday), _selectedAppointmentType,_selectedBranch?.id?.toString() ?? "");
  }

  void _fetchBookedSlots(String date) {
    _bookedTimeSlotsController.getData(
      _getCurrentDoctorId(),
      date,
        _selectedBranch?.id?.toString() ?? ""
    );
  }

  /// Refresh time slots for current date and selected doctor/branch
  void _refreshTimeSlots() {
    final currentDate = _parseSelectedDate(_selectedDate);
    _fetchTimeSlots(currentDate);
    _fetchBookedSlots(_selectedDate);
  }

  _buildExReCard() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: ColorResources.darkCardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: ColorResources.primaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          ColorResources.primaryColor,
                          ColorResources.secondaryColor,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.work_history,
                      color: Color(0xFF0f0f0f),
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    S.of(context).LExperience,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: ColorResources.secondaryFontColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${_doctorsModel?.exYear ?? "0"} ${S.of(context).LYear}",
                    style: const TextStyle(
                      color: ColorResources.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
       const SizedBox(width: 12),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: ColorResources.darkCardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: ColorResources.primaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          ColorResources.primaryColor,
                          ColorResources.secondaryColor,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.star_rate,
                      color: Color(0xFF0f0f0f),
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    S.of(context).Lreview,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: ColorResources.secondaryFontColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${_doctorsModel?.numberOfReview}",
                    style: const TextStyle(
                      color: ColorResources.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _slotsGridView(setStatem, List<TimeSlotsModel> timeSlots,
      List<BookedTimeSlotsModel> bookedTimeSlots) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: timeSlots.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 2 / 1, crossAxisCount: 3),
      itemBuilder: (BuildContext context, int index) {
        return buildTimeSlots(timeSlots[index].timeStart ?? "--",
            timeSlots[index].timeEnd ?? "--", setState, bookedTimeSlots);
      },
    );
  }

  Widget buildTimeSlots(
      String timeStart, String timeEnd, setState, bookedTimeSlots) {
    return GestureDetector(
      onTap: DateTimeHelper.checkIfTimePassed(timeStart, _selectedDate) ||
              getCheckBookedTimeSlot(timeStart, bookedTimeSlots)
          ? null
          : () {
              _setTime = timeStart;
              _endTime = timeEnd;
              setState(() {});
              this.setState(() {});
              Get.back();
              if (selectedFamilyMemberModel != null) {
                openAppointmentBox();
              } else {
                if (familyModelList.isEmpty) {
                  _openBottomSheetAddPatient();
                } else {
                  _openBottomSheetPatient();
                }
              }
            },
      child: Card(
        color: DateTimeHelper.checkIfTimePassed(timeStart, _selectedDate) ||
                getCheckBookedTimeSlot(timeStart, bookedTimeSlots)
            ? Colors.red
            : _setTime == timeStart
                ? ColorResources.primaryColor
                : Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              "$timeStart - $timeEnd",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isCategoryAvailable(DoctorsModel doctor, AppointmentCategory category) {
    return true;
  }

  void getAndSetData() async {
    setState(() {
      _isLoading = true;
    });

    // Get patient ID first
    await _getPatientId();

    final categoriesRes = await AppointmentService.getAppointmentCategories();
    if (categoriesRes != null &&
        categoriesRes.data != null &&
        categoriesRes.data!.isNotEmpty) {
      _appointmentCategories = categoriesRes.data!;
    }

    // Load branches/departments
    final branchesRes = await DepartmentService.getData();
    if (branchesRes != null && branchesRes.isNotEmpty) {
      _branches = branchesRes;
    }
    _selectedDate =
        DateTimeHelper.getYYYMMDDFormatDate(DateTime.now().toString());
    final resDoctors = await DoctorsService.getDataById(doctId: widget.doctId);
    if (resDoctors != null) {
      _doctorsModel = resDoctors;

      if (_doctorsModel?.clinicAppointment == 1) {
        _selectedAppointmentType = "1";
      } else if (_doctorsModel?.videoAppointment == 1) {
        _selectedAppointmentType = "2";
      } else if (_doctorsModel?.emergencyAppointment == 1) {
        _selectedAppointmentType = "3";
      }

      if (_selectedAppointmentType.isNotEmpty) {
        _selectedCategoryId = int.tryParse(_selectedAppointmentType);
        final selectedCategory = _appointmentCategories.firstWhere(
            (cat) => cat.id == _selectedCategoryId,
            orElse: () => _appointmentCategories.first);
        _selectedCategoryTypes = selectedCategory.types ?? [];
      }
      final familyMemberList = await FamilyMembersService.getData();
      if (familyMemberList != null && familyMemberList.isNotEmpty) {
        familyModelList = familyMemberList;
      }

      clinicVisitFee = _doctorsModel?.opdFee ?? 0;
      clinicVisitServiceCharge = 0;

      videoFee = _doctorsModel?.videoFee ?? 0;
      videoServiceCharge = 0;

      emergencyFee = _doctorsModel?.emgFee ?? 0;
      emergencyServiceCharge = 0;

      final userRes = await UserService.getDataById();
      if (userRes != null) {
        userModel = userRes;
      } //S.of(context).LAppointment
      final resConfiguration =
          await ConfigurationService.getDataById(idName: "stop_booking");
      if (resConfiguration != null) {
        if (resConfiguration.value == "true") {
          stopBooking = true;
        }
      }
      final resConfigurationCE =
          await ConfigurationService.getDataById(idName: "coupon_enable");
      if (resConfigurationCE != null) {
        if (resConfigurationCE.value == "true") {
          couponEnable = true;
        }
      }

      final resConfigurationTax =
          await ConfigurationService.getDataById(idName: "tax");
      if (resConfigurationTax != null) {
        if (resConfigurationTax.value != "" &&
            resConfigurationTax.value != null) {
          tax = double.parse(resConfigurationTax.value ?? "0");
        }
      }
      final activePG = await PaymentGatewayService.getActivePaymentGateway();
      if (activePG != null) {
        activePaymentGatewayName = activePG.title;
        activePaymentGatewaySecret = activePG.secret;
        activePaymentGatewayKey = activePG.key;
      }
      appointmentFee = getFeeFilter(_selectedAppointmentType);
      amtCalculation();
      final resDR =
          await DoctorsService.getDataDoctorsReview(doctId: widget.doctId);
      if (resDR != null) {
        doctorReviewModel = resDR;
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  getFamilyMemberListList() async {
    setState(() {
      _isLoading = true;
    });
    final familyList = await FamilyMembersService.getData();
    if (familyList != null && familyList.isNotEmpty) {
      familyModelList = familyList;
      selectedFamilyMemberModel = familyList[0];

      if (_selectedAppointmentType == "3") {
        if (selectedFamilyMemberModel != null) {
          openAppointmentBox();
        }
      } else {
        if (_selectedDate == "" || _setTime == "") {
          _timeSlotsController.getData(
              _getCurrentDoctorId(),
              DateTimeHelper.getDayName(_todayDayTime.weekday),
              _selectedAppointmentType,_selectedBranch?.id?.toString() ?? "");
          _bookedTimeSlotsController.getData(_getCurrentDoctorId(),
              DateTimeHelper.getYYYMMDDFormatDate(_todayDayTime.toString()),_selectedBranch?.id?.toString() ?? "");
          _openBottomSheet();
          return;
        } else if (_selectedDate != "" && _setTime != "") {
          if (selectedFamilyMemberModel != null) {
            openAppointmentBox();
          }
        }
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  // String getAppTypeName(selectedAppointmentTypeId) {
  //   switch (selectedAppointmentTypeId) {
  //     case "1":
  //       {
  //         return "Examinations";
  //       }
  //     case "2":
  //       {
  //         return "Operations";
  //       }
  //     case "3":
  //       {
  //         return "Detection";
  //       }
  //     case "4":
  //       {
  //         return "Video Call";
  //       }
  //
  //     case "5":
  //       {
  //         return "Emergency";
  //       }
  //
  //     case "6":
  //       {
  //         return "VIP";
  //       }
  //
  //     default:
  //       return "--";
  //   }
  // }

  _buildBranchSelectionCard() {
    return Container(
      decoration: BoxDecoration(
        color: ColorResources.darkCardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorResources.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (_branches.isNotEmpty) {
              _openBottomSheetBranchSelection();
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        ColorResources.primaryColor,
                        ColorResources.secondaryColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: Color(0xFF0f0f0f),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            S.of(context).LBranches,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: ColorResources.primaryColor,
                            ),
                          ),
                          Text(
                            " *",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      if (_selectedBranch != null) ...[
                        const SizedBox(height: 8),
                        Text(LanguageController.to.isArabic.value?_selectedBranch?.titleAr??"":
                          _selectedBranch?.title ?? "",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: ColorResources.secondaryFontColor,
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 4),
                        Text(
                          S.of(context).LTapToSelectBranch,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: ColorResources.secondaryFontColor
                                .withOpacity(0.8),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _selectedBranch != null
                        ? Colors.green.withOpacity(0.1)
                        : ColorResources.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _selectedBranch != null
                          ? Colors.green.withOpacity(0.3)
                          : ColorResources.primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    _selectedBranch != null ? Icons.check : Icons.location_on,
                    size: 16,
                    color: _selectedBranch != null
                        ? Colors.green
                        : ColorResources.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorSelectionCard() {
    if (_selectedBranch == null) {
      return Container(); // Don't show doctor selection until branch is selected
    }

    return Container(
        decoration: BoxDecoration(
          color: ColorResources.darkCardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: ColorResources.primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
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
                child: _selectedBranchDoctor != null && 
                       _selectedBranchDoctor!.profileImage != null && 
                       _selectedBranchDoctor!.profileImage!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ImageBoxFillWidget(
                          imageUrl: "${ApiContents.imageUrl}/${_selectedBranchDoctor!.profileImage}",
                          boxFit: BoxFit.cover,
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        color: ColorResources.primaryColor,
                        size: 20,
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).LDoctor,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ColorResources.primaryColor,
                      ),
                    ),
                    if (_branchDoctorController.isLoading.value) ...[
                      const SizedBox(height: 8),
                      Text(
                        "Loading doctor...",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: ColorResources.secondaryFontColor
                              .withOpacity(0.8),
                        ),
                      ),
                    ] else if (_selectedBranchDoctor != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        "${_selectedBranchDoctor!.name ?? ""}",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: ColorResources.secondaryFontColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _selectedBranchDoctor!.specialization ?? "",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: ColorResources.secondaryFontColor
                              .withOpacity(0.8),
                        ),
                      ),
                    ] else ...[
                      const SizedBox(height: 4),
                      Text(
                        "No doctor available for this branch",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Colors.red.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _selectedBranchDoctor != null
                      ? Colors.green.withOpacity(0.1)
                      : ColorResources.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _selectedBranchDoctor != null
                        ? Colors.green.withOpacity(0.3)
                        : ColorResources.primaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: _branchDoctorController.isLoading.value
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              ColorResources.primaryColor),
                        ),
                      )
                    : Icon(
                        _selectedBranchDoctor != null ? Icons.check : Icons.error_outline,
                        size: 16,
                        color: _selectedBranchDoctor != null
                            ? Colors.green
                            : Colors.red,
                      ),
              ),
            ],
          ),
        ),
      );
  }

  _buildFamilyMemberCard() {
    return Container(
      decoration: BoxDecoration(
        color: ColorResources.darkCardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorResources.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (familyModelList.isEmpty) {
              _openBottomSheetAddPatient();
            } else {
              _openBottomSheetPatient();
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        ColorResources.primaryColor,
                        ColorResources.secondaryColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFF0f0f0f),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).LPatient,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: ColorResources.primaryColor,
                        ),
                      ),
                      if (selectedFamilyMemberModel != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          "${selectedFamilyMemberModel?.fName ?? "--"} ${selectedFamilyMemberModel?.lName ?? "--"}",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: ColorResources.secondaryFontColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          selectedFamilyMemberModel?.phone ?? "--",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: ColorResources.secondaryFontColor
                                .withOpacity(0.8),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: ColorResources.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ColorResources.primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.add,
                    size: 16,
                    color: ColorResources.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _openBottomSheetBranchSelection() {
    return showModalBottomSheet(
      backgroundColor: ColorResources.bgColor,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: const BoxDecoration(
                color: ColorResources.bgColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                      top: 10,
                      right: 20,
                      left: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            S.of(context).LSelectBranch,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.white,
                              )),
                        ],
                      )),
                  Positioned(
                      top: 60,
                      left: 5,
                      right: 5,
                      bottom: 0,
                      child: ListView(
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: _branches.length,
                              itemBuilder: (context, index) {
                                DepartmentModel branch = _branches[index];
                                bool isSelected =
                                    _selectedBranch?.id == branch.id;
                                return Card(
                                    color: isSelected
                                        ? ColorResources.primaryColor
                                            .withOpacity(0.1)
                                        : ColorResources.cardBgColor,
                                    elevation: .1,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      side: BorderSide(
                                        color: isSelected
                                            ? ColorResources.primaryColor
                                                .withOpacity(0.5)
                                            : Colors.transparent,
                                        width: 1,
                                      ),
                                    ),
                                    child: ListTile(
                                      onTap: () {
                                        _selectedBranch = branch;
                                        _selectedBranchDoctor = null; // Clear selected doctor
                                        this.setState(() {});
                                        Get.back();
                                        // Fetch doctors for this branch
                                        _fetchDoctorsForBranch(branch.id.toString());
                                        // Clear selected time and date to force refresh
                                        _setTime = "";
                                        _selectedDate = DateTimeHelper.getYYYMMDDFormatDate(DateTime.now().toString());
                                      },
                                      leading: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: isSelected
                                                ? [
                                                    ColorResources.primaryColor,
                                                    ColorResources
                                                        .secondaryColor,
                                                  ]
                                                : [
                                                    ColorResources.primaryColor
                                                        .withOpacity(0.3),
                                                    ColorResources
                                                        .secondaryColor
                                                        .withOpacity(0.3),
                                                  ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.location_on,
                                          color: isSelected
                                              ? const Color(0xFF0f0f0f)
                                              : Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                      title: Text(
                                        LanguageController.to.isArabic.value?
                                        branch.titleAr ?? "--": branch.title ?? "--",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: isSelected
                                              ? ColorResources.primaryColor
                                              : Colors.white,
                                        ),
                                      ),
                                      // subtitle: branch.description != null
                                      //     ? Text(
                                      //         branch.description!,
                                      //         style: const TextStyle(
                                      //           fontWeight: FontWeight.w400,
                                      //           fontSize: 14,
                                      //           color: Colors.white70,
                                      //         ),
                                      //       )
                                      //     : null,
                                      trailing: isSelected
                                          ? Container(
                                              width: 24,
                                              height: 24,
                                              decoration: BoxDecoration(
                                                color:
                                                    ColorResources.primaryColor,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.check,
                                                color: Color(0xFF0f0f0f),
                                                size: 16,
                                              ),
                                            )
                                          : null,
                                    ));
                              }),
                        ],
                      )),
                ],
              ));
        });
      },
    ).whenComplete(() {});
  }

  _openBottomSheetAddPatient() {
    return showModalBottomSheet(
      backgroundColor: ColorResources.bgColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          topLeft: Radius.circular(20.0),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      S.of(context).LRegisterNewMember,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                          keyboardType: TextInputType.name,
                          validator: (item) {
                            return item!.length > 3
                                ? null
                                : S.of(context).LEnterfirstname;
                          },
                          controller: _fNameController,
                          decoration: ThemeHelper()
                              .textInputDecoration(S.of(context).LFirstName)),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        validator: (item) {
                          return item!.length > 3
                              ? null
                              : S.of(context).LEnterlastname;
                        },
                        controller: _lNameController,
                        decoration: ThemeHelper()
                            .textInputDecoration(S.of(context).LLastName),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          keyboardType: Platform.isIOS
                              ? const TextInputType.numberWithOptions(
                                  decimal: true, signed: true)
                              : TextInputType.number,
                          validator: (item) {
                            return item!.length > 5
                                ? null
                                : S.of(context).LEntervalidnumber;
                          },
                          controller: _mobileController,
                          decoration: InputDecoration(
                            prefixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(width: 9),
                                GestureDetector(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      phoneCode,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                  ),
                                  onTap: () {
                                    showCountryPicker(
                                      context: context,
                                      showPhoneCode: true,
                                      // optional. Shows phone code before the country name.
                                      onSelect: (Country country) {
                                        phoneCode = "+${country.phoneCode}";
                                        setState(() {});
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                            hintText: "Ex 1234567890",
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding:
                                const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    const BorderSide(color: Colors.grey)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade400)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 2.0)),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 2.0)),
                          )),
                    ),
                    const SizedBox(height: 20),
                    SmallButtonsWidget(
                        title: S.of(context).LSave,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Get.back();
                            handleAddFamilyMemberData();
                            //  handleAddData();
                          }
                        }),
                  ],
                ),
              ),
            ),
          );
        });
      },
    ).whenComplete(() {});
  }

  void handleAddFamilyMemberData() async {
    setState(() {
      _isLoading = true;
    });

    final res = await FamilyMembersService.addUser(
        fName: _fNameController.text,
        lName: _lNameController.text,
        isdCode: phoneCode,
        phone: _mobileController.text,
        dob: "",
        gender: "");
    if (res != null) {
      IToastMsg.showMessage("success");
      clearInitData();

      getFamilyMemberListList();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  double getFeeFilter(String gridData) {
    final selectedCategory = _appointmentCategories.firstWhere(
      (cat) => cat.id.toString() == gridData,
      orElse: () => AppointmentCategory(),
    );
    return selectedCategory.fee ?? 0.0;
  }

  String? getServiceChargeFilter(gridData) {
    switch (gridData) {
      case "1":
        return clinicVisitServiceCharge?.toString() ?? "--";
      case "2":
        return videoServiceCharge?.toString() ?? "--";
      case "3":
        return emergencyServiceCharge?.toString() ?? "--";
      default:
        return null;
    }
  }

  openAppointmentBox() {
    return showModalBottomSheet(
      backgroundColor: ColorResources.bgColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          topLeft: Radius.circular(20.0),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      Image.asset(
                        ImageConstants.appointmentImage,
                        height: 100,
                        width: 150,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        S.of(context).LOnlyonestepawayPayandbookyourappointment,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const Divider(),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            S.of(context).LDoctor,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                              "${_doctorsModel?.fName ?? "--"} ${_doctorsModel?.lName ?? "--"}",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ))
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            S.of(context).LPatient,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                              "${selectedFamilyMemberModel?.fName ?? "--"} ${selectedFamilyMemberModel?.lName ?? "--"}",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ))
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            S.of(context).LAppointment,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                              LanguageController.to.isArabic.value
                                  ? _selectedAppointmentCategory?.labelAr ?? ""
                                  : _selectedAppointmentCategory?.label ?? "",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ))
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            S.of(context).LDateTime,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                          _selectedAppointmentType == "3"
                              ? Text(
                                  DateTimeHelper.getDataFormat(
                                      DateTimeHelper.getTodayDateInString()),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ))
                              : Text(
                                  "${DateTimeHelper.getDataFormat(_selectedDate)} - ${DateTimeHelper.convertTo12HourFormat(_setTime)}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ))
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            S.of(context).LBranches,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                          Text(_selectedBranch?.title ?? "--",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ))
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            S.of(context).LAppointment,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                              LanguageController.to.isArabic.value
                                  ? _selectedAppointmentCategory?.labelAr ?? ""
                                  : _selectedAppointmentCategory?.label ?? "",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ))
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            S.of(context).LAppointmentFee,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                          Text("$appointmentFee ${AppConstants.appCurrency}",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ))
                        ],
                      ),
                      couponValue == null
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${S.of(context).LCoupon} ($couponValue%) ${S.of(context).LOFF}",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text(S.of(context).LoffPrice,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ))
                                ],
                              ),
                            ),
                      tax == 0
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Tax ($tax%)",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text("+$unitTaxAmount",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ))
                                ],
                              ),
                            ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            S.of(context).LTotalAmount,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(totalAmount.toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: ColorResources.primaryColor,
                              ))
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // Coupon Section
                      if (couponEnable) ...[
                        Container(
                          decoration: BoxDecoration(
                            color: ColorResources.darkCardColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: ColorResources.primaryColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).LCoupon,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: ColorResources.primaryColor,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                                      child: TextFormField(
                                        controller: _couponNameController,
                                        style: const TextStyle(color: Colors.white),
                                        decoration: ThemeHelper().textInputDecoration("Enter Coupon Code"),
                                        onChanged: (value) {
                                          // Clear previous coupon when user types
                                          if (couponValue != null && value != _couponNameController.text) {
                                            clearCoupon();
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: SmallButtonsWidget(
                                      title: couponValue == null ? S.of(context).LApply : S.of(context).LRemove,
                                      width: MediaQuery.of(context).size.width/3.5,
                                      onPressed: couponValue == null
                                          ? () => _validateCoupon(setState)
                                          : () => _removeCoupon(setState),
                                    ),
                                  ),
                                ],
                              ),
                              if (couponValue != null) ...[
                                const SizedBox(height: 5),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.green.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.check_circle, color: Colors.green, size: 16),
                                      const SizedBox(width: 8),
                                      Text(
                                        "Coupon applied! $couponValue% discount",
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                      
                      Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor: Colors.white70,
                        ),
                        child: RadioListTile(
                          value: 0,
                          groupValue: payNow,
                          activeColor: ColorResources.primaryColor,
                          onChanged: (value) {
                            clearCoupon();
                            setState(() {
                              payNow = 0;
                            });
                          },
                          title: Text(
                            S.of(context).LPayAtclinic,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 40.0),
                        child: SmallButtonsWidget(
                            title: "${S.of(context).LBookAppointment}",
                            onPressed: () {
                              Get.back();
                              final checkTime = DateTimeHelper.checkIfTimePassed(
                                  _endTime, _selectedDate);
                              if (checkTime) {
                                IToastMsg.showMessage(S
                                    .of(context)
                                    .LThetimehaspassedpleasechoosethedifferenttime);
                                _openBottomSheet();
                                return;
                              }
                              handleAddAppointment(_selectedAppointmentCategory??_appointmentCategories.first);
                              // if (payNow == 1) {
                              //   if (activePaymentGatewayName == "Razorpay") {
                              //     createOrder(appointmentCategory);
                              //   } else if (activePaymentGatewayName == "Stripe") {
                              //     _nameController.text =
                              //         "${selectedFamilyMemberModel?.fName ?? " "} ${selectedFamilyMemberModel?.lName ?? ""}";
                              //     showStripeDetailsBottomSheet();
                              //   } else {
                              //     IToastMsg.showMessage(
                              //         "No active payment gateway");
                              //   }
                              // } else {
                              //   handleAddAppointment(appointmentCategory);
                              // }
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    ).whenComplete(() {});
  }

  successPayment() {
    IToastMsg.showMessage("success");
    setState(() {
      _isLoading = false;
    });
    Get.offNamedUntil(
        RouteHelper.getMyBookingPageRoute(), ModalRoute.withName('/HomePage'));
  }

  void createOrder(AppointmentCategory appointmentCategory) async {
    setState(() {
      _isLoading = true;
    });
    final res = await RazorPayService.createOrderAppointment(
        familyMemberId: selectedFamilyMemberModel?.id.toString() ?? "",
        status: "Confirmed",
        date: _selectedAppointmentType == "3"
            ? DateTimeHelper.getTodayDateInString()
            : _selectedDate,
        timeSlots: _selectedAppointmentType == "3"
            ? DateTimeHelper.getTodayTimeInString()
            : _setTime,
        doctId: _getCurrentDoctorId(),
        deptId: _selectedBranch?.id?.toString() ?? "",
        type: _selectedAppointmentType,//getAppTypeName(_selectedAppointmentType),
        paymentStatus: payNow == 1 || payNow == 2 ? "Paid" : "Unpaid",
        fee: appointmentFee.toString(),
        serviceCharge: getServiceChargeFilter(_selectedAppointmentType) ?? "0",
        totalAmount: totalAmount.toString(),
        invoiceDescription: LanguageController.to.isArabic.value?appointmentCategory.labelAr??"":appointmentCategory.label??"",//getAppTypeName(_selectedAppointmentType),
        paymentMethod: "Online",
        isWalletTxn: payNow == 2 ? "1" : "0",
        couponId: couponId == null ? "" : couponId.toString(),
        couponOffAmount: offPrice.toString(),
        couponTitle: _couponNameController.text,
        couponValue: couponValue == null ? "" : couponValue.toString(),
        tax: tax.toString(),
        unitTaxAmount: unitTaxAmount.toString(),
        unitTotalAmount: unitTotalAmount.toString(),
        key: activePaymentGatewayKey ?? "",
        secret: activePaymentGatewaySecret ?? "");
    if (res != null) {
      if (kDebugMode) {
        print("Order Id ${res['id']}");
      }
      final orderId = res['id'];
      if (orderId != null || orderId != "") {
        final String countryCodeWithNumber =
            "${userModel?.isdcode ?? ""}${userModel?.phone ?? ""}";
        Get.to(() => RazorPayPaymentPage(
              name:
                  "${userModel?.fName ?? "User"} ${userModel?.lName ?? "User"}",
              description: "Appointment Translation",
              email: userModel?.email ?? "",
              phone: countryCodeWithNumber,
              amount: totalAmount.toString(),
              onSuccess: successPayment,
              rzKey: activePaymentGatewayKey,
              rzOrderId: orderId,
            ));
      } else {
        IToastMsg.showMessage(S.of(context).LSomethingwentwrong);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  void handleAddAppointment(AppointmentCategory appointmentCategory) async {
    setState(() {
      _isLoading = true;
    });

    if (_selectedCategoryTypes.isNotEmpty && _selectedSubTypeId == null) {
      IToastMsg.showMessage("Please select a sub-type");
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final res = await AppointmentService.addAppointment(
      familyMemberId: selectedFamilyMemberModel?.id.toString() ?? "",
     // patientId: _patientId ?? "",
      status: "Confirmed",
      date: _selectedAppointmentType == "3"
          ? DateTimeHelper.getTodayDateInString()
          : _selectedDate,
      timeSlots: _selectedAppointmentType == "3"
          ? DateTimeHelper.getTodayTimeInString()
          : _setTime,
      doctId: _getCurrentDoctorId(),
      deptId: _selectedBranch?.id?.toString() ?? "",
      type: _selectedAppointmentType,
      meetingId: "",
      meetingLink: "",
      paymentStatus: payNow == 1 || payNow == 2 ? "Paid" : "Unpaid",
      fee: appointmentFee.toString(),
      serviceCharge: getServiceChargeFilter(_selectedAppointmentType) ?? "0",
      totalAmount: totalAmount.toString(),
      invoiceDescription: LanguageController.to.isArabic.value
          ? appointmentCategory.labelAr ?? ""
          : appointmentCategory.label ?? "",
      paymentMethod: "Online",
      paymentTransactionId: payNow == 1
          ? "hywv387492"
          : payNow == 2
              ? "Wallet"
              : "",
      isWalletTxn: payNow == 2 ? "1" : "0",
      couponId: couponId == null ? "" : couponId.toString(),
      couponOffAmount: offPrice.toString(),
      couponTitle: _couponNameController.text,
      couponValue: couponValue == null ? "" : couponValue.toString(),
      tax: tax.toString(),
      unitTaxAmount: unitTaxAmount.toString(),
      unitTotalAmount: unitTotalAmount.toString(),
      appointmentCategoryTypeId: _selectedCategoryId.toString(),
      appointmentSubTypeId: _selectedAppointmentId?.toString()??"0",
    );
    if (res != null) {
      setState(() {
        _isLoading = false;
      });
      
      // Extract appointment ID from response
      final appointmentId = res['id']?.toString() ?? '';
      
      if (appointmentId.isNotEmpty) {
        // Navigate to success page with appointment ID
        Get.offNamedUntil(
          RouteHelper.getAppointmentSuccessPageRoute(appointmentId: appointmentId),
          ModalRoute.withName('/HomePage'),
        );
      } else {
        IToastMsg.showMessage("Appointment booked successfully");
        Get.offNamedUntil(
          RouteHelper.getHomePageRoute(), 
          ModalRoute.withName('/HomePage'),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool getCheckBookedTimeSlot(
      String timeStart, List<BookedTimeSlotsModel> bookedTimeSlots) {
    bool retuenValue = false;
    for (var element in bookedTimeSlots) {
      if (element.timeSlots == timeStart) {
        retuenValue = true;
        break;
      }
    }
    return retuenValue;
  }

  void clearInitData() {
    _fNameController.clear();
    _lNameController.clear();
    _mobileController.clear();
  }

  void clearCoupon() {
    couponValue = null;
    couponId = null;
    _couponNameController.clear();
    amtCalculation();
    setState(() {});
  }

  /// Validate coupon code
  Future<void> _validateCoupon(StateSetter setModalState) async {
    if (_couponNameController.text.trim().isEmpty) {
      IToastMsg.showMessage("Please enter a coupon code");
      return;
    }

    try {
      final res = await CouponService.getValidateData(
          title: _couponNameController.text.toUpperCase());
      
      if (res != null && res['status'] == true) {
        IToastMsg.showMessage(res['msg'] ?? "Coupon applied successfully");
        final value = res['data']['value'];
        final couponIdGet = res['data']['id'];
        couponValue = value != null ? double.parse(value.toString()) : null;
        couponId = couponIdGet != null ? int.parse(couponIdGet.toString()) : null;
        amtCalculation();
        
        // Update both modal state and main state
        setModalState(() {});
        setState(() {});
      } else {
        IToastMsg.showMessage(res?['msg'] ?? "Invalid coupon code");
        _clearCouponInModal(setModalState);
      }
    } catch (e) {
      IToastMsg.showMessage("Error validating coupon. Please try again.");
      _clearCouponInModal(setModalState);
    }
  }

  /// Remove coupon
  void _removeCoupon(StateSetter setModalState) {
    couponValue = null;
    couponId = null;
    _couponNameController.clear();
    amtCalculation();
    
    // Update both modal state and main state
    setModalState(() {});
    setState(() {});
  }

  /// Clear coupon in modal (helper method)
  void _clearCouponInModal(StateSetter setModalState) {
    couponValue = null;
    couponId = null;
    amtCalculation();
    
    // Update both modal state and main state
    setModalState(() {});
    setState(() {});
  }

  /// Fetch doctors for the selected branch
  void _fetchDoctorsForBranch(String departmentId) async {
    setState(() {}); // Update UI to show loading state
    
    await _branchDoctorController.getDoctorsByDepartmentId(departmentId);
    
    // Auto-select the first (and only) doctor if available
    if (_branchDoctorController.hasDoctors) {
      _selectedBranchDoctor = _branchDoctorController.dataList.first;
      
      // Fetch time slots for the new doctor/branch combination
      _refreshTimeSlots();
    }
    
    setState(() {}); // Update UI with the new doctor
  }

  /// Get current doctor ID being used for booking
  String _getCurrentDoctorId() {
    return _selectedBranchDoctor?.userId?.toString() ?? widget.doctId ?? "";
  }

  /// Get patient ID from PatientsService
  Future<void> _getPatientId() async {
    try {
      final patients = await PatientsService.getDataByUID();
      if (patients != null && patients.isNotEmpty) {
        _patientId = patients.first.id?.toString() ?? "";
      } else {
        _patientId = "";
      }
    } catch (e) {
      _patientId = "";
      if (kDebugMode) {
        print("Error getting patient ID: $e");
      }
    }
  }

  // Widget _buildCouponCode(StateSetter setState) {
  //   return Row(
  //     children: [
  //       Flexible(
  //         flex: 4,
  //         child: Container(
  //           decoration: ThemeHelper().inputBoxDecorationShaddow(),
  //           child: TextFormField(
  //             controller: _couponNameController,
  //             decoration: ThemeHelper().textInputDecoration("Coupon Code"),
  //           ),
  //         ),
  //       ),
  //       Flexible(
  //         flex: 2,
  //         child: Padding(
  //           padding: const EdgeInsets.only(left: 8.0),
  //           child: SmallButtonsWidget(
  //             title: couponValue == null ? "Apply" : "Remove",
  //             onPressed: couponValue == null
  //                 ? () => handelCheckCoupon()
  //                 : () => clearCoupon(),
  //           ),
  //         ),
  //       )
  //     ],
  //   );
  // }

  void handelCheckCoupon(AppointmentCategory appointmentCategory) async {
    setState(() {
      _isLoading = true;
    });

    final res = await CouponService.getValidateData(
        title: _couponNameController.text.toUpperCase());
    if (res != null && res['status'] == true) {
      IToastMsg.showMessage(res['msg']);
      final value = res['data']['value'];
      final couponIdGet = res['data']['id'];
      couponValue = value != null ? double.parse(value.toString()) : null;
      couponId = couponIdGet != null ? int.parse(couponIdGet.toString()) : null;
      amtCalculation();
    } else {
      IToastMsg.showMessage(res['msg']);
      clearCoupon();
    }
    setState(() {
      _isLoading = false;
    });
    openAppointmentBox();
  }

  amtCalculation() {
    unitTotalAmount = appointmentFee;
    if (appointmentFee == 0) {
      return;
    }
    if (couponValue != null) {
      offPrice = (appointmentFee * couponValue!) / 100;
    } else {
      offPrice = 0;
    }
    // totalAmount=appointmentFee-offPrice;
    if (tax != 0) {
      unitTaxAmount = (appointmentFee * tax) / 100;
      unitTotalAmount = appointmentFee + unitTaxAmount;
    }
    totalAmount = appointmentFee + unitTaxAmount - offPrice;
    setState(() {});
  }

  void showStripeDetailsBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Form(
                key: _formKey2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      S.of(context).LPleasefillthedetails,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        validator: (item) {
                          return item!.length > 3
                              ? null
                              : S.of(context).Entername;
                        },
                        controller: _nameController,
                        decoration: ThemeHelper()
                            .textInputDecoration(S.of(context).LName),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        validator: (item) {
                          return item!.length > 5
                              ? null
                              : S.of(context).LEnteraddress;
                        },
                        controller: _addressController,
                        decoration: ThemeHelper()
                            .textInputDecoration(S.of(context).LAddress),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        validator: (item) {
                          return item!.length > 3
                              ? null
                              : S.of(context).LEntercity;
                        },
                        controller: _cityController,
                        decoration: ThemeHelper()
                            .textInputDecoration(S.of(context).LCity),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        validator: (item) {
                          return item!.length > 3
                              ? null
                              : S.of(context).LEnterState;
                        },
                        controller: _stateController,
                        decoration: ThemeHelper()
                            .textInputDecoration(S.of(context).LState),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        validator: (item) {
                          return item!.length > 3
                              ? null
                              : S.of(context).LEnterCountry;
                        },
                        controller: _countryController,
                        decoration: ThemeHelper()
                            .textInputDecoration(S.of(context).LCountry),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // SmallButtonsWidget(
                    //   title: S.of(context).LProceedtopay,
                    //   onPressed: () {
                    //     if (_formKey2.currentState!.validate()) {
                    //       Navigator.pop(context);
                    //       //createOrderStripe();
                    //     }
                    //   },
                    // )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // void createOrderStripe() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //
  //   final res = await StripeService.createOrderAppointment(
  //     secret: activePaymentGatewaySecret ?? "",
  //     name: _nameController.text,
  //     address: _addressController.text,
  //     city: _cityController.text,
  //     country: _countryController.text,
  //     state: _stateController.text,
  //     familyMemberId: selectedFamilyMemberModel?.id.toString() ?? "",
  //     status: "Confirmed",
  //     date: _selectedAppointmentType == "3"
  //         ? DateTimeHelper.getTodayDateInString()
  //         : _selectedDate,
  //     timeSlots: _selectedAppointmentType == "3"
  //         ? DateTimeHelper.getTodayTimeInString()
  //         : _setTime,
  //     doctId: widget.doctId ?? "",
  //     deptId: _selectedBranch?.id?.toString() ?? "",
  //     type: getAppTypeName(_selectedAppointmentType),
  //     paymentStatus: payNow == 1 || payNow == 2 ? "Paid" : "Unpaid",
  //     fee: appointmentFee.toString(),
  //     serviceCharge: getServiceChargeFilter(_selectedAppointmentType) ?? "0",
  //     totalAmount: totalAmount.toString(),
  //     invoiceDescription: getAppTypeName(_selectedAppointmentType),
  //     paymentMethod: "Online",
  //     isWalletTxn: payNow == 2 ? "1" : "0",
  //     couponId: couponId == null ? "" : couponId.toString(),
  //     couponOffAmount: offPrice.toString(),
  //     couponTitle: _couponNameController.text,
  //     couponValue: couponValue == null ? "" : couponValue.toString(),
  //     tax: tax.toString(),
  //     unitTaxAmount: unitTaxAmount.toString(),
  //     unitTotalAmount: unitTotalAmount.toString(),
  //     key: activePaymentGatewayKey ?? "",
  //   );
  //   if (res != null) {
  //     if (kDebugMode) {
  //       print("Order Id ${res['id']}");
  //     }
  //     final orderId = res['id'];
  //     // if (orderId != null || orderId != "") {
  //     //   Get.to(() => StripePaymentPage(
  //     //         onSuccess: successPayment,
  //     //         stripeKey: activePaymentGatewayKey,
  //     //         orderId: orderId,
  //     //         name: _nameController.text,
  //     //         address: _addressController.text,
  //     //         city: _cityController.text,
  //     //         country: _countryController.text,
  //     //         state: _stateController.text,
  //     //         customerId: res['customer_id'],
  //     //         clientSecret: res['client_secret'],
  //     //       ));
  //     // } else {
  //     //   IToastMsg.showMessage("Something went wrong");
  //     // }
  //   }
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }

  _buildSocialMediaSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _doctorsModel?.youtubeLink == null || _doctorsModel?.youtubeLink == ""
              ? Container()
              : GestureDetector(
                  onTap: () {
                    final url = _doctorsModel?.youtubeLink ?? "";
                    launchUrl(Uri.parse(url),
                        mode: LaunchMode.externalApplication);
                  },
                  child: Image.asset(
                    ImageConstants.youtubeImageBox,
                    width: 30,
                    height: 30,
                  ),
                ),
          _doctorsModel?.fbLink == null || _doctorsModel?.fbLink == ""
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      final url = _doctorsModel?.fbLink ?? "";
                      launchUrl(Uri.parse(url),
                          mode: LaunchMode.externalApplication);
                    },
                    child: Image.asset(
                      ImageConstants.facebookImageBox,
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
          _doctorsModel?.instaLink == null || _doctorsModel?.instaLink == ""
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      final url = _doctorsModel?.instaLink ?? "";
                      launchUrl(Uri.parse(url),
                          mode: LaunchMode.externalApplication);
                    },
                    child: Image.asset(
                      ImageConstants.instagramImageBox,
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
          _doctorsModel?.twitterLink == null || _doctorsModel?.twitterLink == ""
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      final url = _doctorsModel?.twitterLink ?? "";
                      launchUrl(Uri.parse(url),
                          mode: LaunchMode.externalApplication);
                    },
                    child: Image.asset(
                      ImageConstants.twitterImageBox,
                      width: 30,
                      height: 30,
                    ),
                  ),
                )
        ],
      ),
    );
  }

  _buildRatingReviewBox() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 150, // Set a maximum height to maintain balance
        ),
        child: PageView.builder(
          scrollDirection: Axis.horizontal,
          controller: PageController(viewportFraction: 0.9),
          // Controls card width
          itemCount: doctorReviewModel.length,
          // controller: PageController(viewportFraction: 0.9), // Controls card width
          itemBuilder: (context, index) {
            DoctorsReviewModel doctorsReviewModel = doctorReviewModel[index];
            return SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: Card(
                color: ColorResources.cardBgColor,
                elevation: .1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  isThreeLine: true,
                  leading: const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.person,
                      size: 30,
                    ),
                  ),
                  title: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "${doctorsReviewModel.fName} ${doctorsReviewModel.lName}",
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      StarRating(
                        mainAxisAlignment: MainAxisAlignment.start,
                        length: 5,
                        color: doctorsReviewModel.points == 0
                            ? Colors.grey
                            : Colors.amber,
                        rating: double.parse(
                            (doctorsReviewModel.points ?? 0).toString()),
                        between: 5,
                        starSize: 15,
                        onRaitingTap: (rating) {},
                      ),
                    ],
                  ),
                  subtitle: Text(
                    doctorsReviewModel.description ?? "--",
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
