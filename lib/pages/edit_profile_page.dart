import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userapp/generated/l10n.dart';
import '../controller/notification_dot_controller.dart';
import '../controller/user_controller.dart';
import '../helpers/route_helper.dart';
import '../model/user_model.dart';
import 'package:get/get.dart';
import '../utilities/api_content.dart';
import '../helpers/date_time_helper.dart';
import '../helpers/theme_helper.dart';
import '../services/user_service.dart';
import '../utilities/colors_constant.dart';
import '../widget/button_widget.dart';
import '../widget/image_box_widget.dart';
import '../widget/loading_Indicator_widget.dart';
import '../widget/text_filed.dart';
import 'package:intl/intl.dart';
import '../widget/toast_message.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  UserController userController = Get.find(tag: "user");
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  String? selectedDate = "";
  String? selectedGender;
  UserModel? userModel;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    getAndSetData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorResources.bgColor,
        appBar: AppBar(
          leading: Transform.scale(
            scale: .8,
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ColorResources.darkCardColor.withOpacity(0.9),
                border: Border.all(
                  color: ColorResources.primaryColor.withOpacity(0.3),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 20.0,
                    color: ColorResources.primaryColor,
                  ),
                  onPressed: () => Get.back()),
            ),
          ),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(
            S.of(context).LProfile,
            style: const TextStyle(
                color: ColorResources.primaryColor, 
                fontSize: 18, 
                fontWeight: FontWeight.w600),
          ),
          actions: [
            Transform.scale(
              scale: .8,
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ColorResources.redColor.withOpacity(0.2),
                  border: Border.all(
                    color: ColorResources.redColor.withOpacity(0.5),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: IconButton(
                    onPressed: () {
                      _openDialogBox();
                    },
                    icon: const Icon(
                      Icons.delete,
                      size: 20,
                      color: ColorResources.redColor,
                    )),
              ),
            )
          ],
        ),
        body: _isLoading ? const ILoadingIndicatorWidget() : _buildBody());
  }

  _buildBody() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ColorResources.gradientStart,
            ColorResources.gradientEnd,
          ],
        ),
      ),
      child: ListView(
        children: [
          const SizedBox(height: 20),
          _buildProfileCard(),
          const SizedBox(height: 20),
                 _buildFormCard(),
         const SizedBox(height: 20),
         _buildUpdateButton(),
         ],
       ),
     );
  }

  Widget _buildProfileCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
                width: 80,
                height: 80,
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
                child: userModel?.imageUrl == null || userModel?.imageUrl == ""
                    ? Center(
                        child: Text(
                          userModel?.fName?.substring(0, 2).toString() ?? "أح",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0f0f0f),
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(17),
                        child: ImageBoxFillWidget(
                          imageUrl: "${ApiContents.imageUrl}/${userModel?.imageUrl ?? ""}",
                          boxFit: BoxFit.cover,
                        ),
                      ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${userModel?.fName ?? ""} ${userModel?.lName ?? ""}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: ColorResources.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      userModel?.phone ?? "--",
                      style: const TextStyle(
                        fontSize: 14,
                        color: ColorResources.secondaryFontColor,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "${S.of(context).LMembersince} ${DateTimeHelper.getDataFormat(userModel?.createdAt)}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: ColorResources.secondaryFontColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // const SizedBox(height: 20),
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          //   decoration: BoxDecoration(
          //     color: ColorResources.primaryColor.withOpacity(0.1),
          //     borderRadius: BorderRadius.circular(15),
          //     border: Border.all(
          //       color: ColorResources.primaryColor.withOpacity(0.3),
          //       width: 1,
          //     ),
          //   ),
          //   child: Text(
          //     S.of(context).LEditProfile,
          //     style: const TextStyle(
          //       fontWeight: FontWeight.w600,
          //       color: ColorResources.primaryColor,
          //       fontSize: 16,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorResources.darkCardColor.withOpacity(0.9),
        border: Border.all(
          color: ColorResources.primaryColor.withOpacity(0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          ITextFields.labelText(labelText: S.of(context).LName),
          Container(
            decoration: ThemeHelper().inputBoxDecorationShaddow(),
            child: TextFormField(

              keyboardType: TextInputType.text,
              validator: (item) {
                return item!.length > 3
                    ? null
                    : S.of(context).LLengthValidation;
              },
              controller: _fNameController,
              style: TextStyle(color: Colors.white),
              decoration: ThemeHelper()
                  .textInputDecoration(S.of(context).LFirstName),
            ),
          ),
          const SizedBox(height: 10),
          const SizedBox(height: 10),
          ITextFields.labelText(labelText: S.of(context).LLastName),
          Container(
            decoration: ThemeHelper().inputBoxDecorationShaddow(),
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              keyboardType: TextInputType.text,
              validator: (item) {
                return item!.length > 3
                    ? null
                    : S.of(context).LLengthValidation;
              },
              controller: _lNameController,
              decoration: ThemeHelper()
                  .textInputDecoration(S.of(context).LLastName),
            ),
          ),
          const SizedBox(height: 10),
          ITextFields.labelText(labelText: S.of(context).LEmail),
          Container(
            decoration: ThemeHelper().inputBoxDecorationShaddow(),
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              keyboardType: TextInputType.emailAddress,
              validator: (val) {
                if ((val!.isNotEmpty) &&
                    !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                        .hasMatch(val)) {
                  return "Enter a valid email address";
                }
                return null;
              },
              controller: _emailController,
              decoration:
                  ThemeHelper().textInputDecoration(S.of(context).LEmail),
            ),
          ),
          const SizedBox(height: 10),
          ITextFields.labelText(labelText: S.of(context).LDOB),
          const SizedBox(height: 10),
          Container(
            decoration: ThemeHelper().inputBoxDecorationShaddow(),
            child: TextFormField(
                readOnly: true,
                onTap: () {
                  _selectDate(context);
                },
                validator: null,
                controller: _dobController,
                decoration: InputDecoration(
                  hintText: S.of(context).LDOB,
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.grey.shade400)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          const BorderSide(color: Colors.red, width: 2.0)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          const BorderSide(color: Colors.red, width: 2.0)),
                )),
          ),
          const SizedBox(height: 10),
          ITextFields.labelText(labelText: S.of(context).LGender),
          const SizedBox(height: 10),
          InputDecorator(
            decoration: ThemeHelper()
                .textInputDecoration(S.of(context).LSelectGender),
            child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
              value: selectedGender,
                  style: TextStyle(color: Colors.green),
              hint: Text(S.of(context).LSelectGender,style: TextStyle(color: Colors.green),),
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
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SmallButtonsWidget(
        title: S.of(context).LUpdate,
        onPressed: () {
          handleUpdateProfile();
        },
      ),
    );
  }

  _openDialogBox() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text(
            S.of(context).LDeleteProfile,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(S.of(context).LDeleteProfileConfirmation,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12)),
              const SizedBox(height: 10),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    left:
                        BorderSide(width: 5.0, color: ColorResources.redColor),
                  ),
                ),
                child: ListTile(
                  isThreeLine: true,
                  leading: Icon(
                    Icons.warning,
                    color: ColorResources.redColor,
                  ),
                  title: Text(S.of(context).LWarning,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  subtitle: Text(S.of(context).LDeleteProfileWarning,
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 12)),
                ),
              )
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorResources.greyBtnColor,
                ),
                child: Text(S.of(context).LCancel,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 12)),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorResources.redColor,
                ),
                child: Text(
                  S.of(context).LDeleteProfile,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 12),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _handleDelete();
                }),
            // usually buttons at the bottom of the dialog
          ],
        );
      },
    );
  }

  void getAndSetData() async {
    setState(() {
      _isLoading = true;
    });
    final res = await UserService.getDataById();
    if (res != null) {
      userModel = res;
      _emailController.text = userModel?.email ?? "";
      _phoneNumberController.text = userModel?.phone ?? "";
      _fNameController.text = userModel?.fName ?? "";
      _lNameController.text = userModel?.lName ?? "";
      if (userModel!.gender != null && userModel!.gender != "") {
        selectedGender = userModel!.gender.toString();
      }
      if (userModel!.dob != null && userModel!.dob != "") {
        _dobController.text = DateTimeHelper.getDataFormat(userModel!.dob!);
        selectedDate = userModel!.dob;
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  void handleUpdateProfile() async {
    setState(() {
      _isLoading = true;
    });
    final res = await UserService.updateProfile(
        lName: _lNameController.text,
        fName: _fNameController.text,
        dob: selectedDate ?? "",
        email: _emailController.text,
        gender: selectedGender ?? "");
    if (res != null) {
      IToastMsg.showMessage(S.of(context).LSuccess);
      getAndSetData();
      userController.getData();
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _handleDelete() async {
    setState(() {
      _isLoading = true;
    });
    final res = await UserService.softDelete();
    if (res != null) {
      IToastMsg.showMessage(S.of(context).LSuccessDeleted);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      IToastMsg.showMessage(S.of(context).LLogout);
      final NotificationDotController notificationDotController =
          Get.find(tag: "notification_dot");
      final UserController userController0 = Get.find(tag: S.of(context).LUser);
      userController0.getData();
      notificationDotController.setDotStatus(false);
      Get.offAllNamed(RouteHelper.getHomePageRoute());
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = DateFormat('yyyy-MM-dd').format(picked);
        _dobController.text = DateTimeHelper.getDataFormat(selectedDate);
      });
    }
  }
}
