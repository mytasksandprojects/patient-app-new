import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:userapp/generated/l10n.dart';
import '../controller/family_members_controller.dart';
import '../helpers/date_time_helper.dart';
import '../model/family_members_model.dart';
import '../services/family_members_service.dart';
import '../utilities/app_constans.dart';
import '../widget/app_bar_widget.dart';
import 'package:get/get.dart';
import '../helpers/theme_helper.dart';
import '../utilities/colors_constant.dart';
import '../widget/button_widget.dart';
import '../widget/loading_Indicator_widget.dart';
import 'package:country_picker/country_picker.dart';
import 'package:intl/intl.dart';
import '../widget/toast_message.dart';

class FamilyMemberListPage extends StatefulWidget {
  const FamilyMemberListPage({super.key});

  @override
  State<FamilyMemberListPage> createState() => _FamilyMemberListPageState();
}

class _FamilyMemberListPageState extends State<FamilyMemberListPage> {
  final FamilyMembersController _familyMembersController=FamilyMembersController();
  final TextEditingController _mobileController=TextEditingController();
  final TextEditingController _fNameController=TextEditingController();
  final TextEditingController _lNameController=TextEditingController();
  final TextEditingController _dobController=TextEditingController();
  bool _isLoading=false;
  String? selectedDate="";
  String? selectedFamilyMemberId="";
  String? selectedGender;
  final _formKey = GlobalKey<FormState>();
  String phoneCode="+";

  @override
  void initState() {
    phoneCode=AppConstants.defaultCountyCode;
    _familyMembersController.getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
        onPressed: () {
          clearData();
          _openBottomSheetAddFamilyMember(true);
        },
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add,
                color: Color(0xFF0f0f0f),
                size: 20,
              ),
            ],
          ),
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
            S.of(context).LFamilyMember,
            style: const TextStyle(
              color: ColorResources.primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: _isLoading ? const ILoadingIndicatorWidget() : _buildBody(),
    );
  }

  _buildBody() {
    return Obx(() {
      if (!_familyMembersController.isError.value && !_familyMembersController.isError.value) {
        if (_familyMembersController.isLoading.value || _familyMembersController.isLoading.value) {
            return const ILoadingIndicatorWidget();
          } else if (_familyMembersController.dataList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: ColorResources.darkCardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: ColorResources.primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.family_restroom,
                    size: 50,
                    color: ColorResources.primaryColor,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  S.of(context).LNoFamilyMembers,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: ColorResources.primaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "أضف أفراد العائلة للبدء",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: ColorResources.secondaryFontColor,
                  ),
                ),
              ],
            ),
          );
        } else {
          return _buildMembersList(_familyMembersController.dataList);
        }
      } else {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.red.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 40,
                  color: Colors.red[300],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                S.of(context).LSomethingwentwrong,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red[300],
                    fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
            );
          }
    });
  }

  _buildMembersList(List dataList) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          FamilyMembersModel familyMembersModel = dataList[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: ColorResources.darkCardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: ColorResources.primaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  _fNameController.text = familyMembersModel.fName ?? "";
                  _lNameController.text = familyMembersModel.lName ?? "";
                  _mobileController.text = familyMembersModel.phone ?? "";
                  if (familyMembersModel.dob != null && familyMembersModel.dob != "") {
                    _dobController.text = DateTimeHelper.getDataFormat(familyMembersModel.dob);
                    selectedDate = familyMembersModel.dob;
                }
                  if (familyMembersModel.isdCode != null && familyMembersModel.isdCode != "") {
                    phoneCode = familyMembersModel.isdCode!;
                }
                  if (familyMembersModel.gender != null && familyMembersModel.gender != "") {
                    selectedGender = familyMembersModel.gender.toString();
                }
                  selectedFamilyMemberId = familyMembersModel.id?.toString() ?? "";
                _openBottomSheetAddFamilyMember(false);
              },
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Header Row
                      Row(
                        children: [
                          // Profile Avatar
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  ColorResources.primaryColor,
                                  ColorResources.secondaryColor,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: ColorResources.primaryColor,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                _getInitials("${familyMembersModel.fName ?? ""} ${familyMembersModel.lName ?? ""}"),
                                style: const TextStyle(
                                  color: Color(0xFF0f0f0f),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Name and Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${familyMembersModel.fName ?? ""} ${familyMembersModel.lName ?? ""}",
                            style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: ColorResources.primaryColor,
                          ),
                                ),
                                  Text(
                                    (familyMembersModel.phone??""),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: ColorResources.secondaryFontColor,
                                    ),
                                  ),
                                // if (familyMembersModel.dob != null && familyMembersModel.dob != "")
                                //   Text(
                                //     "${_calculateAge(familyMembersModel.dob)} سنة",
                                //     style: TextStyle(
                                //       fontWeight: FontWeight.w400,
                                //       fontSize: 12,
                                //       color: ColorResources.secondaryFontColor,
                                //     ),
                                //   ),
                              ],
                            ),
                          ),
                          // Delete Button
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.red.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.delete_outline,
                                color: Colors.red[400],
                                size: 20,
                              ),
                              onPressed: () {
                                _openDialogBox(familyMembersModel);
                              },
                            ),
                          ),
                        ],
                      ),
                     // const SizedBox(height: 20),
                      // Statistics Row
                      // Container(
                      //   padding: const EdgeInsets.all(16),
                      //   decoration: BoxDecoration(
                      //     gradient: LinearGradient(
                      //       begin: Alignment.topLeft,
                      //       end: Alignment.bottomRight,
                      //       colors: [
                      //         ColorResources.primaryColor.withOpacity(0.05),
                      //         ColorResources.bgColor.withOpacity(0.9),
                      //       ],
                      //     ),
                      //     borderRadius: BorderRadius.circular(12),
                      //     border: Border.all(
                      //       color: ColorResources.primaryColor.withOpacity(0.2),
                      //       width: 1,
                      //     ),
                      //   ),
                      //   child: Row(
                      //     children: [
                      //       Expanded(
                      //         child: _buildStatCard(
                      //           title: "المواعيد",
                      //           value: "3",
                      //           subtitle: "1 يونيو",
                      //           icon: Icons.calendar_today,
                      //           color: ColorResources.primaryColor,
                      //         ),
                      //       ),
                      //       const SizedBox(width: 12),
                      //       Expanded(
                      //         child: _buildStatCard(
                      //           title: "الإشعارات",
                      //           value: "2",
                      //           subtitle: "",
                      //           icon: Icons.notifications_outlined,
                      //           color: Colors.blue,
                      //         ),
                      //       ),
                      //       const SizedBox(width: 12),
                      //       Expanded(
                      //         child: _buildStatCard(
                      //           title: "التطعيمات",
                      //           value: "0",
                      //           subtitle: "",
                      //           icon: Icons.medical_services_outlined,
                      //           color: Colors.green,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  String _getInitials(String name) {
    List<String> names = name.trim().split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (names.length == 1 && names[0].isNotEmpty) {
      return names[0][0].toUpperCase();
    }
    return 'ع';
  }

  String _getGenderInArabic(String? gender) {
    switch (gender?.toLowerCase()) {
      case 'male':
        return 'الذكور الانساني';
      case 'female':
        return 'الأنثى';
      default:
        return 'أخرى';
    }
  }

  int _calculateAge(String? dobString) {
    if (dobString == null || dobString.isEmpty) return 0;
    try {
      DateTime dob = DateTime.parse(dobString);
      DateTime now = DateTime.now();
      int age = now.year - dob.year;
      if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return 0;
    }
  }

  _openBottomSheetAddFamilyMember(bool isForAdding) {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, setState) {
            return Container(
              decoration: BoxDecoration(
                color: ColorResources.darkCardColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(24.0),
                  topLeft: Radius.circular(24.0),
                ),
                border: Border.all(
                  color: ColorResources.primaryColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                  child: Padding(
                  padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: ColorResources.primaryColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                          const SizedBox(height: 20),
                        Row(
                          children: [
                          Container(
                              padding: const EdgeInsets.all(12),
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
                                isForAdding ? Icons.person_add : Icons.edit,
                                color: const Color(0xFF0f0f0f),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                "${isForAdding ? S.of(context).add : S.of(context).update} ${S.of(context).new_family_member}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: ColorResources.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildThemedTextField(
                          controller: _fNameController,
                          label: S.of(context).LFirstName,
                          icon: Icons.person_outline,
                          validator: (item) {
                            return item!.length > 3 ? null : S.of(context).enter_first_name;
                              },
                        ),
                        const SizedBox(height: 16),
                        _buildThemedTextField(
                          controller: _lNameController,
                          label: S.of(context).LLastName,
                          icon: Icons.person_outline,
                          validator: (item) {
                            return item!.length > 3 ? null : S.of(context).LEnterLastname;
                          },
                          ),
                        const SizedBox(height: 16),
                        _buildThemedPhoneField(setState),
                        const SizedBox(height: 16),
                        _buildThemedDateField(),
                        const SizedBox(height: 16),
                        _buildThemedGenderDropdown(setState),
                        const SizedBox(height: 32),
                        Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                ColorResources.primaryColor,
                                ColorResources.secondaryColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: ColorResources.primaryColor.withOpacity(0.3),
                                spreadRadius: 0,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                Get.back();
                                if (isForAdding) {
                                  handleAddUserDataData();
                                } else if (!isForAdding) {
                                  handleUpdateUserDataData();
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              S.of(context).LSave,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0f0f0f),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            );
                              },
        );
      },
    );
  }

  Widget _buildThemedTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.text,
      inputFormatters: inputFormatters,
      validator: validator,
      style: const TextStyle(color: ColorResources.primaryColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: ColorResources.secondaryFontColor),
        prefixIcon: Icon(icon, color: ColorResources.primaryColor),
        filled: true,
        fillColor: ColorResources.bgColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ColorResources.primaryColor.withOpacity(0.3)),
                          ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ColorResources.primaryColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ColorResources.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildThemedPhoneField(StateSetter setState) {
    return TextFormField(
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                ],
      keyboardType: Platform.isIOS
          ? const TextInputType.numberWithOptions(decimal: true, signed: true)
                                    : TextInputType.number,
                                validator: (item) {
                                  return item!.length > 5 ? null : S.of(context).LEntervalidnumber;
                                },
                                controller: _mobileController,
      style: const TextStyle(color: ColorResources.primaryColor),
                                decoration: InputDecoration(
        labelText: S.of(context).ex_mobile,
        labelStyle: TextStyle(color: ColorResources.secondaryFontColor),
                                  prefixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
            const SizedBox(width: 16),
            GestureDetector(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      ColorResources.primaryColor,
                      ColorResources.secondaryColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  phoneCode,
                                          style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0f0f0f),
                  ),
                ),
                                      ),
              onTap: () {
                                          showCountryPicker(
                                            context: context,
                  showPhoneCode: true,
                                            onSelect: (Country country) {
                    phoneCode = "+${country.phoneCode}";
                    setState(() {});
                                            },
                                          );
                                        },
                                      ),
            const SizedBox(width: 12),
                                    ],
                                  ),
                                  filled: true,
        fillColor: ColorResources.bgColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ColorResources.primaryColor.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ColorResources.primaryColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ColorResources.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
                          ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildThemedDateField() {
    return TextFormField(
                          readOnly: true,
      onTap: () {
                              _selectDate(context);
                            },
                            controller: _dobController,
      style: const TextStyle(color: ColorResources.primaryColor),
      decoration: InputDecoration(
        labelText: S.of(context).LDOB,
        labelStyle: TextStyle(color: ColorResources.secondaryFontColor),
        prefixIcon: const Icon(Icons.calendar_today_outlined, color: ColorResources.primaryColor),
        filled: true,
        fillColor: ColorResources.bgColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ColorResources.primaryColor.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ColorResources.primaryColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ColorResources.primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildThemedGenderDropdown(StateSetter setState) {
    return InputDecorator(
                            decoration: InputDecoration(
        labelText: S.of(context).LSelectGender,
        labelStyle: TextStyle(color: ColorResources.secondaryFontColor),
        prefixIcon: const Icon(Icons.people_outline, color: ColorResources.primaryColor),
                              filled: true,
        fillColor: ColorResources.bgColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ColorResources.primaryColor.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: ColorResources.primaryColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ColorResources.primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                padding: EdgeInsets.zero,
                                value: selectedGender,
          dropdownColor: ColorResources.darkCardColor,
          style: const TextStyle(color: ColorResources.primaryColor),
          hint: Text(
            S.of(context).LSelectGender,
                                style: TextStyle(
                                  fontSize: 14,
              color: ColorResources.secondaryFontColor,
              fontWeight: FontWeight.w400,
            ),
          ),
                               items: [
                    DropdownMenuItem(
                      value: "Male",
                      child: Text(S.of(context).LMale),
                    ),
                    DropdownMenuItem(
                      value: "Female",
                      child: Text(S.of(context).LFemale),
                    ),
                    DropdownMenuItem(
                      value: "Other",
                      child: Text(S.of(context).LOther),
                    ),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGender = newValue;
                    });
                  },
                    ),
                  ),
                );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColorResources.primaryColor,
              onPrimary: Color(0xFF0f0f0f),
              onSurface: ColorResources.primaryColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: ColorResources.primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedDate = DateFormat('yyyy-MM-dd').format(picked);
        _dobController.text = DateTimeHelper.getDataFormat(selectedDate);
      });
    }
  }

  void handleUpdateUserDataData() async {
    setState(() {
      _isLoading = true;
    });

    final res = await FamilyMembersService.updateUser(
      id: selectedFamilyMemberId,
      dob: selectedDate ?? "",
      gender: selectedGender ?? "",
        fName: _fNameController.text,
        lName: _lNameController.text,
        isdCode: phoneCode,
      phone: _mobileController.text,
    );
    if (res != null) {
      IToastMsg.showMessage(S.of(context).LSuccess);
      _familyMembersController.getData();
      clearData();
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void handleAddUserDataData() async {
    setState(() {
      _isLoading = true;
    });

    final res = await FamilyMembersService.addUser(
      dob: selectedDate ?? "",
      gender: selectedGender ?? "",
        fName: _fNameController.text,
        lName: _lNameController.text,
        isdCode: phoneCode,
      phone: _mobileController.text,
    );
    if (res != null) {
      IToastMsg.showMessage(S.of(context).LSuccess);
      _familyMembersController.getData();
      clearData();
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void handleDeleteDataData(String id) async {
    setState(() {
      _isLoading = true;
    });

    final res = await FamilyMembersService.deleteData(id: id);
    if (res != null) {
      IToastMsg.showMessage(S.of(context).LSuccess);
      _familyMembersController.getData();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _openDialogBox(FamilyMembersModel familyMembersModel) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ColorResources.darkCardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: Colors.red.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: Colors.red[400],
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                S.of(context).LDelete,
            textAlign: TextAlign.center,
                style: const TextStyle(
                  color: ColorResources.primaryColor,
                fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${S.of(context).LAreyousure} ${familyMembersModel.fName ?? ""} ${familyMembersModel.lName} ${S.of(context).Lfromfamilymembers}",
                  textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorResources.secondaryFontColor,
                      fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: ColorResources.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ColorResources.primaryColor.withOpacity(0.3),
                        width: 1,
                      ),
                ),
                    child: TextButton(
                      child: const Text(
                        "إلغاء",
                    style: TextStyle(
                          color: ColorResources.primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                onPressed: () {
                  Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.red, Colors.red[700]!],
                      ),
                      borderRadius: BorderRadius.circular(12),
                ),
                    child: TextButton(
                      child: const Text(
                        "حذف",
                  style: TextStyle(
                      color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                onPressed: () {
                  Navigator.of(context).pop();
                  handleDeleteDataData(familyMembersModel.id.toString());
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void clearData() {
    _fNameController.clear();
    _lNameController.clear();
    _dobController.clear();
    _mobileController.clear();
    selectedGender = null;
    selectedDate = "";
    selectedFamilyMemberId = "";
  }
}
