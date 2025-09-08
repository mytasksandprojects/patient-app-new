import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:userapp/app_localizations_ext.dart';
import 'package:userapp/generated/l10n.dart';
import '../controller/vital_controller.dart';
import '../helpers/date_time_helper.dart';
import '../model/chart_data_model.dart';
import '../model/family_members_model.dart';
import '../model/vital_model.dart';
import '../services/family_members_service.dart';
import '../services/vitals_service.dart';
import '../utilities/app_constans.dart';
import '../widget/app_bar_widget.dart';
import '../widget/bottom_button.dart';
import '../widget/input_label_widget.dart';
import '../widget/loading_Indicator_widget.dart';
import '../helpers/theme_helper.dart';
import '../helpers/vital_helper.dart';
import '../utilities/colors_constant.dart';
import '../widget/button_widget.dart';
import '../widget/error_widget.dart';
import '../widget/line_chart.dart';
import '../widget/no_data_widgets.dart';
import '../widget/toast_message.dart';

class VitalsDetailsPage extends StatefulWidget {
  final String? vitalName;

  const VitalsDetailsPage({super.key, this.vitalName});

  @override
  State<VitalsDetailsPage> createState() => _VitalsDetailsPageState();
}

class _VitalsDetailsPageState extends State<VitalsDetailsPage> {
  DateRangePickerSelectionChangedArgs? argsDate;
  bool _isLoading = false;
  List<FamilyMembersModel> familyMembers = [];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _bpSystolicController = TextEditingController();
  final TextEditingController _bpDiastolicController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _spo2Controller = TextEditingController();
  final TextEditingController _tempController = TextEditingController();
  final TextEditingController _sugarRandomController = TextEditingController();
  final TextEditingController _sugarFastingController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  ScrollController scrollController = ScrollController();
  FamilyMembersModel? selectedFamilyMemberModel;
  int? selectedFamilyMemberId;
  VitalController vitalController = Get.put(VitalController());
  String? selectedVital;
  final _listVitals = VitalHelper.listVitals;
  List<ChartData> chartData = [];
  String selectedDate = "";
  String selectedTime = "";
  String startDate = "";
  String endDate = "";
  String phoneCode = "+";

  @override
  void initState() {
    phoneCode = AppConstants.defaultCountyCode;
    selectedVital = widget.vitalName;
    selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    TimeOfDay timeOfDay = TimeOfDay.now();
    int hour = timeOfDay.hour;
    int minute = timeOfDay.minute;
    selectedTime = "$hour:$minute";
    _timeController.text = DateFormat('hh:mm a').format(DateTime.now());
    _dateController.text = DateTimeHelper.getDataFormat(selectedDate);
    getAndSetData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.bgColor,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [
              ColorResources.primaryColor,
              ColorResources.secondaryColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: ColorResources.primaryColor.withOpacity(0.4),
              spreadRadius: 0,
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.add, color: Color(0xFF0f0f0f), size: 24),
          onPressed: () {
            if (selectedFamilyMemberModel == null) {
              _openBottomSheetAddPatient();
              return;
            }
            clearVitalsInput();
            switch (selectedVital) {
              case "blood_pressure":
                _openBottomSheetAddBP(null);
                break;
              case "blood_sugar":
                _openBottomSheetSugar(null);
                break;
              case "weight":
                _openBottomSheetWeight(null);
                break;
              case "temperature":
                _openBottomSheetTemp(null);
                break;
              case "spo2":
                _openBottomSheetSpo2(null);
                break;
            }
          },
        ),
      ),
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
            "${S.of(context)!.vitals(selectedVital!).replaceAll("_", " ")} ${getParameter(selectedVital!)}",
            style: const TextStyle(
              color: ColorResources.primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: _isLoading
          ? const ILoadingIndicatorWidget()
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                selectedFamilyMemberModel == null
                    ? Container()
                    : Container(
                        margin: const EdgeInsets.only(bottom: 16.0),
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
                              _openBottomSheetFamilyMember();
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
                                    child: Text(
                                      "${S.of(context).name} - ${selectedFamilyMemberModel?.fName ?? ""} ${selectedFamilyMemberModel?.lName ?? ""}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: ColorResources.primaryColor,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: ColorResources.primaryColor
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.arrow_drop_down,
                                      color: ColorResources.primaryColor,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                Container(
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
                            gradient: const LinearGradient(
                              colors: [
                                ColorResources.primaryColor,
                                ColorResources.secondaryColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.calendar_month,
                            color: Color(0xFF0f0f0f),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: startDate != "" && endDate != ""
                              ? Text(
                                  "${DateTimeHelper.getDataFormat(startDate)} - ${DateTimeHelper.getDataFormat(endDate)}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: ColorResources.primaryColor,
                                  ),
                                )
                              : Text(
                                  "${S.of(context).date} $startDate $endDate",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: ColorResources.primaryColor,
                                  ),
                                ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: ColorResources.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _openSelectSheet();
                            },
                            child: const Icon(
                              Icons.date_range,
                              color: ColorResources.primaryColor,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              argsDate = null;
                              startDate = "";
                              endDate = "";
                              vitalController.getData(
                                  selectedFamilyMemberModel?.id.toString() ??
                                      "",
                                  selectedVital ?? "",
                                  "",
                                  "");
                              setState(() {});
                            },
                            child: Icon(
                              Icons.clear,
                              color: Colors.red[400],
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
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
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: '${S.of(context).select_vital}*',
                        labelStyle:
                            TextStyle(color: ColorResources.secondaryFontColor),
                        prefixIcon: const Icon(Icons.medical_services_outlined,
                            color: ColorResources.primaryColor),
                        filled: true,
                        fillColor: ColorResources.bgColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color:
                                  ColorResources.primaryColor.withOpacity(0.3)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color:
                                  ColorResources.primaryColor.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: ColorResources.primaryColor, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          padding: EdgeInsets.zero,
                          value: selectedVital,
                          dropdownColor: ColorResources.darkCardColor,
                          style: const TextStyle(
                              color: ColorResources.primaryColor),
                          hint: Text(
                            S.of(context).select_vital,
                            style: TextStyle(
                              fontSize: 14,
                              color: ColorResources.secondaryFontColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          items: _listVitals.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(S.of(context).vitals(value).replaceAll("_", " ")),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedVital = newValue;
                            });
                            vitalController.getData(
                                selectedFamilyMemberModel?.id.toString() ?? "",
                                selectedVital ?? "",
                                startDate,
                                endDate);
                          },
                          isExpanded: true,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Obx(() {
                //   return vitalController.dataList.isNotEmpty
                //       ? selectedVital == "blood_pressure"
                //           ? Column(
                //               children: [
                //                 Text(
                //                   "${S.of(context).vitals('bp_systolic')}",
                //                   style: const TextStyle(
                //                       fontSize: 15,
                //                       color: Colors.white,
                //                       fontWeight: FontWeight.w500),
                //                 ),
                //                 getDataChart(vitalController.dataList, false),
                //                 const Divider(),
                //                 Text(
                //                   "${S.of(context).vitals('bp_diastolic')}",
                //                   style: const TextStyle(
                //                       fontSize: 15,
                //                       color: Colors.white,
                //
                //                       fontWeight: FontWeight.w500),
                //                 ),
                //                 getDataChart(vitalController.dataList, true),
                //               ],
                //             )
                //           : selectedVital == "sugar"
                //               ? Column(
                //                   children: [
                //                     Text(
                //                       S.of(context).vitals('random'),
                //                       style: const TextStyle(
                //                           fontSize: 15,
                //                           fontWeight: FontWeight.w500),
                //                     ),
                //                     getDataChart(
                //                         vitalController.dataList, false),
                //                     const Divider(),
                //                     Text(
                //                       S.of(context).vitals('fasting'),
                //                       style: const TextStyle(
                //                           fontSize: 15,
                //                           fontWeight: FontWeight.w500),
                //                     ),
                //                     getDataChart(
                //                         vitalController.dataList, true),
                //                   ],
                //                 )
                //               : getDataChart(vitalController.dataList, false)
                //       : Container();
                // }),
                _buildBody(),
              ],
            ),
    );
  }

/////////////////////////////////////////////////////////////////nor
  Widget _buildBody() {
    return Obx(() {
      if (!vitalController.isError.value) {
        if (vitalController.isLoading.value) {
          return const IVerticalListLongLoadingWidget();
        } else if (vitalController.dataList.isEmpty) {
          return const NoDataWidget();
        } else {
          return _buildList(vitalController.dataList);
        }
      } else {
        return const IErrorWidget();
      }
    });
  }

  Widget _buildList(dataList) {
    return ListView.builder(
      controller: scrollController,
      itemCount: dataList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        VitalModel vitalModel = dataList[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        _getVitalIcon(selectedVital ?? ""),
                        color: const Color(0xFF0f0f0f),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitle(selectedVital ?? "", vitalModel),
                          const SizedBox(height: 8),
                          Text(
                            "${DateTimeHelper.getDataFormat(vitalModel.date)} ${DateTimeHelper.convertTo12HourFormat(vitalModel.time ?? "")}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: ColorResources.secondaryFontColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: ColorResources.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            onPressed: () {
                              clearVitalsInput();
                              switch (selectedVital) {
                                case "blood_pressure":
                                  _openBottomSheetAddBP(vitalModel);
                                  break;
                                case "blood_sugar":
                                  _openBottomSheetSugar(vitalModel);
                                  break;
                                case "weight":
                                  _openBottomSheetWeight(vitalModel);
                                  break;
                                case "temperature":
                                  _openBottomSheetTemp(vitalModel);
                                  break;
                                case "spo2":
                                  _openBottomSheetSpo2(vitalModel);
                                  break;
                              }
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: ColorResources.primaryColor,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            onPressed: () {
                              _openDialogBox(vitalModel);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red[400],
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getVitalIcon(String vital) {
    switch (vital) {
      case "blood_pressure":
        return Icons.favorite;
      case "blood_sugar":
        return Icons.bloodtype;
      case "weight":
        return Icons.monitor_weight;
      case "temperature":
        return Icons.thermostat;
      case "spo2":
        return Icons.air;
      default:
        return Icons.medical_services;
    }
  }

  ////////////

  _openBottomSheetFamilyMember() {
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
                            S.of(context).add_select_family_member,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600,color: Colors.white),
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
                                child: Text(S.of(context).add_new,
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
                              itemCount: familyMembers.length,
                              itemBuilder: (context, index) {
                                FamilyMembersModel familyModel =
                                    familyMembers[index];
                                return Card(
                                    color: ColorResources.cardBgColor,
                                    elevation: .1,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: ListTile(
                                      onTap: () {
                                        selectedFamilyMemberModel = familyModel;
                                        vitalController.getData(
                                            selectedFamilyMemberModel?.id
                                                    .toString() ??
                                                "",
                                            selectedVital ?? "",
                                            startDate,
                                            endDate);

                                        this.setState(() {});
                                        Get.back();
                                      },
                                      trailing: familyModel.id ==
                                              selectedFamilyMemberModel?.id
                                          ? const Icon(
                                              Icons.circle,
                                              color: Colors.green,
                                              size: 10,
                                            )
                                          : null,
                                      leading: const Icon(Icons.person,color: Colors.white,),
                                      title: Text(
                                        "${familyModel.fName} ${familyModel.lName}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        "${familyModel.phone}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13,color:Colors.white),
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

  void getAndSetData() async {
    setState(() {
      _isLoading = true;
    });
    final res = await FamilyMembersService.getData();
    if (res != null) {
      familyMembers = res;
      if (familyMembers.isNotEmpty) {
        selectedFamilyMemberModel = res[0];
        vitalController.getData(selectedFamilyMemberModel?.id.toString() ?? "",
            selectedVital ?? "", startDate, endDate);
      }
    }
    setState(() {
      _isLoading = false;
    });
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
                      S.of(context).register_new_family_member,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        validator: (item) {
                          return item!.length > 3
                              ? null
                              : S.of(context).enter_first_name;
                        },
                        controller: _fNameController,
                        decoration: ThemeHelper()
                            .textInputDecoration(S.of(context).first_name),
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
                              : S.of(context).enter_last_name;
                        },
                        controller: _lNameController,
                        decoration: ThemeHelper()
                            .textInputDecoration(S.of(context).last_name),
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
                                : S.of(context).enter_valid_number;
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
                            hintText: S.of(context).ex_mobile,
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
      selectedFamilyMemberId = res['id'];
      IToastMsg.showMessage(S.of(context).success);
      clearInitData();
      getFamilyMemberListList();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void handleAddVital() async {
    setState(() {
      _isLoading = true;
    });

    final res = await VitalsService.addData(
        diastolic: _bpDiastolicController.text,
        familyMemberId: selectedFamilyMemberModel?.id.toString(),
        systolic: _bpSystolicController.text,
        type: selectedVital,
        temperature: _tempController.text,
        spo2: _spo2Controller.text,
        sugarFasting: _sugarFastingController.text,
        sugarRandom: _sugarRandomController.text,
        weight: _weightController.text,
        date: selectedDate,
        time: selectedTime);
    if (res != null) {
      IToastMsg.showMessage(S.of(context).success);
      clearVitalsInput();
      vitalController.getData(selectedFamilyMemberModel?.id.toString() ?? "",
          selectedVital ?? "", startDate, endDate);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void handleUpdateVital(id) async {
    setState(() {
      _isLoading = true;
    });

    final res = await VitalsService.updateData(
        id: id,
        diastolic: _bpDiastolicController.text,
        familyMemberId: selectedFamilyMemberModel?.id.toString(),
        systolic: _bpSystolicController.text,
        type: selectedVital,
        temperature: _tempController.text,
        spo2: _spo2Controller.text,
        sugarFasting: _sugarFastingController.text,
        sugarRandom: _sugarRandomController.text,
        weight: _weightController.text,
        date: selectedDate,
        time: selectedTime);
    if (res != null) {
      IToastMsg.showMessage(S.of(context).success);
      clearVitalsInput();
      vitalController.getData(selectedFamilyMemberModel?.id.toString() ?? "",
          selectedVital ?? "", startDate, endDate);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void handleDeleteVital(String id) async {
    setState(() {
      _isLoading = true;
    });

    final res = await VitalsService.deleteData(id: id);
    if (res != null) {
      IToastMsg.showMessage(S.of(context).success);
      clearVitalsInput();
      vitalController.getData(selectedFamilyMemberModel?.id.toString() ?? "",
          selectedVital ?? "", startDate, endDate);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void clearInitData() {
    _fNameController.clear();
    _lNameController.clear();
    _mobileController.clear();
    selectedFamilyMemberModel = null;
  }

  clearVitalsInput() {
    _bpSystolicController.clear();
    _bpDiastolicController.clear();
    _weightController.clear();
    _spo2Controller.clear();
    _tempController.clear();
    _sugarRandomController.clear();
    _sugarFastingController.clear();
  }

  getFamilyMemberListList() async {
    setState(() {
      _isLoading = true;
    });
    final familyList = await FamilyMembersService.getData();
    if (familyList != null && familyList.isNotEmpty) {
      familyMembers = familyList;
      if (selectedFamilyMemberId != null) {
        for (var e in familyMembers) {
          if (e.id == selectedFamilyMemberId) {
            selectedFamilyMemberModel = e;
            vitalController.getData(
                selectedFamilyMemberModel?.id.toString() ?? "",
                selectedVital ?? "",
                startDate,
                endDate);
            break;
          }
        }
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildTitle(String vitalName, var vitalModel) {
    switch (vitalName) {
      case "blood_pressure":
        return _buildTitleBP(vitalModel);
      case "blood_sugar":
        return _buildTitleSugar(vitalModel);
      case "weight":
        return _buildTitleWeight(vitalModel);
      case "temperature":
        return _buildTitleTemp(vitalModel);
      case "spo2":
        return _buildTitleSpo2(vitalModel);
      default:
        return Container();
    }
  }

  Widget _buildTitleBP(VitalModel vitalModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${S.of(context).vitals('bp_systolic')} - ${vitalModel.bpSystolic.toString()} ${S.of(context).units_mmHg}",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: ColorResources.primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "${S.of(context).vitals('bp_diastolic')} - ${vitalModel.bpDiastolic.toString()} ${S.of(context).units_mmHg}",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: ColorResources.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTitleSugar(VitalModel vitalModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        vitalModel.sugarRandom == null
            ? Container()
            : Text(
                "${S.of(context).vitals('random')} - ${vitalModel.sugarRandom.toString()} ${S.of(context).units_Mgdl}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ColorResources.primaryColor,
                ),
              ),
        vitalModel.sugarRandom != null && vitalModel.sugarFasting != null
            ? const SizedBox(height: 4)
            : Container(),
        vitalModel.sugarFasting == null
            ? Container()
            : Text(
                "${S.of(context).vitals('fasting')} - ${vitalModel.sugarFasting.toString()} ${S.of(context).units_Mgdl}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ColorResources.primaryColor,
                ),
              ),
      ],
    );
  }

  Widget _buildTitleWeight(VitalModel vitalModel) {
    return Text(
      "${S.of(context).vitals('weight')} - ${vitalModel.weight.toString()} ${S.of(context).units_KG}",
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: ColorResources.primaryColor,
      ),
    );
  }

  Widget _buildTitleTemp(VitalModel vitalModel) {
    return Text(
      "${S.of(context).vitals('temp')} - ${vitalModel.temperature.toString()} ${S.of(context).units_F}",
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: ColorResources.primaryColor,
      ),
    );
  }

  Widget _buildTitleSpo2(VitalModel vitalModel) {
    return Text(
      "${S.of(context).vitals('spo2')} - ${vitalModel.spo2.toString()} ${S.of(context).units_percent}",
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: ColorResources.primaryColor,
      ),
    );
  }

  _openBottomSheetAddBP(VitalModel? vitalModel) {
    selectedDate =
        vitalModel?.date ?? DateFormat('yyyy-MM-dd').format(DateTime.now());
    TimeOfDay timeOfDay = TimeOfDay.now(); // Initialize with current time
    int hour = timeOfDay.hour; // Get the hour
    int minute = timeOfDay.minute;
    selectedTime = vitalModel?.time ?? ("$hour:$minute");
    _timeController.text = DateFormat('hh:mm a').format(DateTime.now());
    _dateController.text = DateTimeHelper.getDataFormat(selectedDate);
    _bpSystolicController.text = vitalModel?.bpSystolic.toString() ?? "";
    _bpDiastolicController.text = vitalModel?.bpDiastolic.toString() ?? "";
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      S.of(context).add_blood_pressure,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: InputLabel.buildLabelBox(S.of(context).date),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                        readOnly: true,
                        style: TextStyle(color: Colors.white),
                        onTap: () {
                          _selectDate(context);
                        },
                        validator: null,
                        controller: _dateController,
                        decoration: ThemeHelper()
                            .textInputDecoration(S.of(context).date),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: InputLabel.buildLabelBox(S.of(context).time),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                        readOnly: true,
                        style: TextStyle(color: Colors.white),
                        onTap: () {
                          _selectTime(context);
                        },
                        validator: null,
                        controller: _timeController,
                        decoration: ThemeHelper()
                            .textInputDecoration(S.of(context).time),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: InputLabel.buildLabelBox(
                          "${S.of(context).systolic} (${S.of(context).units_mmHg})"),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}$')),
                        ],
                        keyboardType: Platform.isIOS
                            ? const TextInputType.numberWithOptions(
                                decimal: true, signed: true)
                            : TextInputType.number,
                        validator: (item) {
                          return item!.isNotEmpty
                              ? null
                              : S.of(context).enter_value;
                        },
                        controller: _bpSystolicController,
                        decoration: ThemeHelper().textInputDecoration('120'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: InputLabel.buildLabelBox(
                          "${S.of(context).diastolic} (${S.of(context).units_mmHg})"),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        style: TextStyle(color: Colors.white),
                        validator: (item) {
                          return item!.isNotEmpty
                              ? null
                              : S.of(context).enter_value;
                        },
                        controller: _bpDiastolicController,
                        decoration: ThemeHelper().textInputDecoration('80'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SmallButtonsWidget(
                        title: S.of(context).LSave,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Get.back();
                            if (vitalModel == null) {
                              handleAddVital();
                            } else {
                              handleUpdateVital(vitalModel.id.toString());
                            }
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

  _openBottomSheetWeight(VitalModel? vitalModel) {
    selectedDate =
        vitalModel?.date ?? DateFormat('yyyy-MM-dd').format(DateTime.now());
    TimeOfDay timeOfDay = TimeOfDay.now(); // Initialize with current time
    int hour = timeOfDay.hour; // Get the hour
    int minute = timeOfDay.minute;
    selectedTime = vitalModel?.time ?? ("$hour:$minute");
    _timeController.text = DateFormat('hh:mm a').format(DateTime.now());
    _dateController.text = DateTimeHelper.getDataFormat(selectedDate);
    _weightController.text = vitalModel?.weight.toString() ?? "0";
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      S.of(context).add_weight,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: InputLabel.buildLabelBox(S.of(context).date),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                        readOnly: true,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        onTap: () {
                          _selectDate(context);
                        },
                        validator: null,
                        controller: _dateController,
                        decoration: ThemeHelper()
                            .textInputDecoration(S.of(context).date),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: InputLabel.buildLabelBox(S.of(context).time),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                        readOnly: true,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        onTap: () {
                          _selectTime(context);
                        },
                        validator: null,
                        controller: _timeController,
                        decoration: ThemeHelper()
                            .textInputDecoration(S.of(context).time),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: InputLabel.buildLabelBox(
                          "${S.of(context).weight} (${S.of(context).units_KG})"),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}$')),
                        ],
                        keyboardType: Platform.isIOS
                            ? const TextInputType.numberWithOptions(
                                decimal: true, signed: true)
                            : TextInputType.number,
                        validator: (item) {
                          return item!.isNotEmpty
                              ? null
                              : S.of(context).enter_value;
                        },
                        controller: _weightController,
                        decoration: ThemeHelper().textInputDecoration('60'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SmallButtonsWidget(
                        title: S.of(context).LSave,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Get.back();
                            if (vitalModel == null) {
                              handleAddVital();
                            } else {
                              handleUpdateVital(vitalModel.id.toString());
                            }
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

  _openBottomSheetTemp(VitalModel? vitalModel) {
    selectedDate =
        vitalModel?.date ?? DateFormat('yyyy-MM-dd').format(DateTime.now());
    TimeOfDay timeOfDay = TimeOfDay.now(); // Initialize with current time
    int hour = timeOfDay.hour; // Get the hour
    int minute = timeOfDay.minute;
    selectedTime = vitalModel?.time ?? ("$hour:$minute");
    _timeController.text = DateFormat('hh:mm a').format(DateTime.now());
    _dateController.text = DateTimeHelper.getDataFormat(selectedDate);
    _tempController.text = vitalModel?.temperature.toString() ?? "0";
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      S.of(context).add_temperature,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: InputLabel.buildLabelBox(S.of(context).date),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                        readOnly: true,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        onTap: () {
                          _selectDate(context);
                        },
                        validator: null,
                        controller: _dateController,
                        decoration: ThemeHelper()
                            .textInputDecoration(S.of(context).date),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: InputLabel.buildLabelBox(S.of(context).time),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                        readOnly: true,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        onTap: () {
                          _selectTime(context);
                        },
                        validator: null,
                        controller: _timeController,
                        decoration: ThemeHelper()
                            .textInputDecoration(S.of(context).time),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: InputLabel.buildLabelBox(
                          "${S.of(context).temperature} (${S.of(context).units_F})"),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}$')),
                        ],
                        keyboardType: Platform.isIOS
                            ? const TextInputType.numberWithOptions(
                                decimal: true, signed: true)
                            : TextInputType.number,
                        validator: (item) {
                          return item!.isNotEmpty
                              ? null
                              : S.of(context).enter_value;
                        },
                        controller: _tempController,
                        decoration: ThemeHelper().textInputDecoration('97'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SmallButtonsWidget(
                        title: S.of(context).LSave,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Get.back();
                            if (vitalModel == null) {
                              handleAddVital();
                            } else {
                              handleUpdateVital(vitalModel.id.toString());
                            }
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

  _openBottomSheetSpo2(VitalModel? vitalModel) {
    selectedDate =
        vitalModel?.date ?? DateFormat('yyyy-MM-dd').format(DateTime.now());
    TimeOfDay timeOfDay = TimeOfDay.now(); // Initialize with current time
    int hour = timeOfDay.hour; // Get the hour
    int minute = timeOfDay.minute;
    selectedTime = vitalModel?.time ?? ("$hour:$minute");
    _timeController.text = DateFormat('hh:mm a').format(DateTime.now());
    _dateController.text = DateTimeHelper.getDataFormat(selectedDate);
    _spo2Controller.text = vitalModel?.spo2.toString() ?? "0";
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      S.of(context).add_spo2,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: InputLabel.buildLabelBox(S.of(context).date),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                        readOnly: true,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        onTap: () {
                          _selectDate(context);
                        },
                        validator: null,
                        controller: _dateController,
                        decoration: ThemeHelper()
                            .textInputDecoration(S.of(context).date),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: InputLabel.buildLabelBox(S.of(context).time),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                        readOnly: true,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        onTap: () {
                          _selectTime(context);
                        },
                        validator: null,
                        controller: _timeController,
                        decoration: ThemeHelper()
                            .textInputDecoration(S.of(context).time),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: InputLabel.buildLabelBox(
                          "${S.of(context).spo2} (${S.of(context).units_percent})"),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}$')),
                        ],
                        keyboardType: Platform.isIOS
                            ? const TextInputType.numberWithOptions(
                                decimal: true, signed: true)
                            : TextInputType.number,
                        validator: (item) {
                          return item!.isNotEmpty
                              ? null
                              : S.of(context).enter_value;
                        },
                        controller: _spo2Controller,
                        decoration: ThemeHelper().textInputDecoration('98'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SmallButtonsWidget(
                        title: S.of(context).LSave,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Get.back();
                            if (vitalModel == null) {
                              handleAddVital();
                            } else {
                              handleUpdateVital(vitalModel.id.toString());
                            }
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

  _openBottomSheetSugar(VitalModel? vitalModel) {
    selectedDate =
        vitalModel?.date ?? DateFormat('yyyy-MM-dd').format(DateTime.now());
    TimeOfDay timeOfDay = TimeOfDay.now(); // Initialize with current time
    int hour = timeOfDay.hour; // Get the hour
    int minute = timeOfDay.minute;
    selectedTime = vitalModel?.time ?? ("$hour:$minute");
    _timeController.text = DateFormat('hh:mm a').format(DateTime.now());
    _dateController.text = DateTimeHelper.getDataFormat(selectedDate);
    _sugarRandomController.text = vitalModel?.sugarRandom.toString() ?? "0";
    _sugarFastingController.text = vitalModel?.sugarFasting.toString() ?? "0";
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      S.of(context).add_sugar,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: InputLabel.buildLabelBox(S.of(context).date),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                        readOnly: true,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        onTap: () {
                          _selectDate(context);
                        },
                        validator: null,
                        controller: _dateController,
                        decoration: ThemeHelper()
                            .textInputDecoration(S.of(context).date),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: InputLabel.buildLabelBox(S.of(context).time),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                        readOnly: true,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        onTap: () {
                          _selectTime(context);
                        },
                        validator: null,
                        controller: _timeController,
                        decoration: ThemeHelper()
                            .textInputDecoration(S.of(context).time),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: InputLabel.buildLabelBox(
                          "${S.of(context).sugar_random} (${S.of(context).units_Mgdl})"),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}$')),
                        ],
                        keyboardType: Platform.isIOS
                            ? const TextInputType.numberWithOptions(
                                decimal: true, signed: true)
                            : TextInputType.number,
                        validator: (item) {
                          return null;
                        },
                        controller: _sugarRandomController,
                        decoration: ThemeHelper().textInputDecoration('120'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: InputLabel.buildLabelBox(
                          "${S.of(context).sugar_fasting} (${S.of(context).units_Mgdl})"),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}$')),
                        ],
                        keyboardType: Platform.isIOS
                            ? const TextInputType.numberWithOptions(
                                decimal: true, signed: true)
                            : TextInputType.number,
                        validator: (item) {
                          return null;
                        },
                        controller: _sugarFastingController,
                        decoration: ThemeHelper().textInputDecoration('90'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SmallButtonsWidget(
                        title: S.of(context).LSave,
                        onPressed: () {
                          if (_sugarFastingController.text.isEmpty &&
                              _sugarRandomController.text.isEmpty) {
                            IToastMsg.showMessage(
                                S.of(context).please_fill_at_least_one_field);
                          } else {
                            Get.back();
                            if (vitalModel == null) {
                              handleAddVital();
                            } else {
                              handleUpdateVital(vitalModel.id.toString());
                            }
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

  getDataChart(List dataList, bool value2) {
    List<ChartData> dataListReturn = [];

    if (selectedVital == "Weight") {
      for (int i = dataList.length; i > 0; i--) {
        VitalModel vitalModel = dataList[i - 1];
        dataListReturn.add(
          ChartData(
              DateTime.parse(vitalModel.date ?? ""), vitalModel.weight ?? 0),
        );
      }
    }
    if (selectedVital == "Temperature") {
      for (int i = dataList.length; i > 0; i--) {
        VitalModel vitalModel = dataList[i - 1];
        dataListReturn.add(
          ChartData(DateTime.parse(vitalModel.date ?? ""),
              vitalModel.temperature ?? 0),
        );
      }
    }
    if (selectedVital == "SpO2") {
      for (int i = dataList.length; i > 0; i--) {
        VitalModel vitalModel = dataList[i - 1];
        dataListReturn.add(
          ChartData(
              DateTime.parse(vitalModel.date ?? ""), vitalModel.spo2 ?? 0),
        );
      }
    }
    if (selectedVital == "Blood Pressure") {
      if (value2) {
        for (int i = dataList.length; i > 0; i--) {
          VitalModel vitalModel = dataList[i - 1];
          dataListReturn.add(
            ChartData(DateTime.parse(vitalModel.date ?? ""),
                vitalModel.bpDiastolic ?? 0),
          );
        }
      } else {
        for (int i = dataList.length; i > 0; i--) {
          VitalModel vitalModel = dataList[i - 1];
          dataListReturn.add(
            ChartData(DateTime.parse(vitalModel.date ?? ""),
                vitalModel.bpSystolic ?? 0),
          );
        }
      }
    }
    if (selectedVital == "blood_sugar") {
      if (value2) {
        for (int i = dataList.length; i > 0; i--) {
          VitalModel vitalModel = dataList[i - 1];
          dataListReturn.add(
            ChartData(DateTime.parse(vitalModel.date ?? ""),
                vitalModel.sugarFasting ?? 0),
          );
        }
      } else {
        for (int i = dataList.length; i > 0; i--) {
          VitalModel vitalModel = dataList[i - 1];
          dataListReturn.add(
            ChartData(DateTime.parse(vitalModel.date ?? ""),
                vitalModel.sugarRandom ?? 0),
          );
        }
      }
    }
    return dataListReturn.isNotEmpty
        ? LineChartWidget(chartData: dataListReturn)
        : Container();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = DateFormat('yyyy-MM-dd').format(picked);
        _dateController.text = DateTimeHelper.getDataFormat(selectedDate);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        int hour = picked.hour; // Get the hour
        int minute = picked.minute;
        selectedTime = "$hour:$minute";
        final now = DateTime.now();
        DateTime pickedDateTime =
            DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
        _timeController.text = DateFormat('hh:mm a').format(pickedDateTime);
      });
    }
  }

  String getParameter(String? selectedVital) {
    switch (selectedVital) {
      case "blood_pressure":
        return S.of(context).units_mmHg;
      case "blood_sugar":
        return S.of(context).units_Mgdl;
      case "weight":
        return S.of(context).units_KG;
      case "temperature":
        return S.of(context).units_F;
      case "spo2":
        return S.of(context).units_percent;
      default:
        return "";
    }
  }

  _openDialogBox(vitalModel) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            S.of(context).delete,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(S.of(context).delete_confirmation,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12)),
              const SizedBox(height: 10),
              _buildTitle(selectedVital ?? "", vitalModel),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorResources.btnColorGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10), // Change this value to adjust the border radius
                  ),
                ),
                child: Text(S.of(context).no,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 12)),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorResources.btnColorRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10), // Change this value to adjust the border radius
                  ),
                ),
                child: Text(
                  S.of(context).yes,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 12),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  handleDeleteVital(vitalModel.id.toString());
                }),
            // usually buttons at the bottom of the dialog
          ],
        );
      },
    );
  }

  _openSelectSheet() {
    argsDate = null;
    return showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
              color: Colors.white,
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
                          S.of(context).select_date,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: const Icon(Icons.close)),
                      ],
                    )),
                Positioned(
                    top: 60,
                    left: 5,
                    right: 5,
                    bottom: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SfDateRangePicker(
                          maxDate: DateTime.now(),
                          minDate: DateTime(2020),
                          enablePastDates: true,
                          onSelectionChanged: _onSelectionChanged,
                          selectionMode: DateRangePickerSelectionMode.range,
                          showNavigationArrow: true,
                          initialSelectedRange: PickerDateRange(
                              DateTime.now().subtract(const Duration(days: 3)),
                              DateTime.now()),
                        ),
                        const SizedBox(height: 50),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SmallButtonsWidget(
                              title: S.of(context).submit,
                              onPressed: () {
                                if (argsDate == null) {
                                  IToastMsg.showMessage(
                                      S.of(context).select_date);
                                } else if (argsDate != null) {
                                  if (argsDate!.value.startDate != null) {
                                    startDate = DateFormat('yyyy-MM-dd')
                                        .format(argsDate!.value.startDate);
                                  }
                                  if (argsDate!.value.endDate != null) {
                                    endDate = DateFormat('yyyy-MM-dd')
                                        .format(argsDate!.value.endDate);
                                  }
                                  Get.back();
                                  vitalController.getData(
                                      selectedFamilyMemberModel?.id
                                              .toString() ??
                                          "",
                                      selectedVital ?? "",
                                      startDate,
                                      endDate);
                                  // handleAddData(startDate,endDate);
                                }
                                setState(() {});
                              }),
                        )
                      ],
                    )),
              ],
            ));
      },
    ).whenComplete(() {});
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    argsDate = args;

    setState(() {});
  }
}
