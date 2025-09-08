import 'dart:async';
import 'dart:io';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:userapp/generated/l10n.dart';
import '../../controller/user_controller.dart';
import '../../services/user_service.dart';
import '../../controller/timer_controller.dart';
import '../../helpers/theme_helper.dart';
import '../../services/login_screen_service.dart';
import '../../services/user_subscription.dart';
import '../../utilities/api_content.dart';
import '../../utilities/app_constans.dart';
import '../../utilities/colors_constant.dart';
import '../../utilities/image_constants.dart';
import '../../utilities/sharedpreference_constants.dart';
import '../../widget/button_widget.dart';
import '../../widget/input_label_widget.dart';
import '../../widget/loading_Indicator_widget.dart';
import '../../widget/toast_message.dart';

class LoginPage extends StatefulWidget {
  final Function? onSuccessLogin;

  const LoginPage({super.key, required this.onSuccessLogin});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final List _images=[];
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  bool obscureText=true;
  String phoneCode="+";
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  Timer? _timer;
  int _start = 60;
  bool otpSendFailed=false;
  String _verificationId = "";
  String phoneNumberWithCode="";
  bool _codeSent=false;

  final TimerController _timerController=TimerController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    phoneCode=AppConstants.defaultCountyCode;
    getAndSetData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:   _buildSlidingBody()
    );
  }
  _buildSlidingBody(){
    return  Stack(
      children: [
        _images.isEmpty?Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: ColorResources.bgColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(ImageConstants.logoImage,
                  height: 200,
                  width: 200,
                ),
                const SizedBox(height: 20),
                const Text(
                    '${AppConstants.appName} ',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 25
                    )),
              ],
            ),
          ),

        ) :  CarouselSlider.builder(
          itemCount:_images.length,
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height,
            viewportFraction: 1,
            autoPlay: _images.length==1?false:true,
            enlargeCenterPage: false,
            onPageChanged: _callbackFunction,
          ),
          itemBuilder: (ctx, index, realIdx) {
            return
              CachedNetworkImage(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.fill,
                imageUrl: _images[index],
                placeholder: (context, url) => const Center(child: Icon(Icons.image)),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              );
          },
        ),
        Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child:
            SizedBox(
              height: 50,
              child:_isLoading?const ILoadingIndicatorWidget(): SmallButtonsWidget(
                  title:S.of(context).LLoginSignup,
                  onPressed: () {
                    if(_codeSent){ _openBottomSheetForOTP();}
                    else {_openBottomSheetLogin();}
                  }),
            ))
      ],
    );
  }
  _callbackFunction(int index, CarouselPageChangedReason reason) {
    // setState(() {
    //   _currentIndex = index;
    // });
  }



  void getAndSetData() async {
    setState(() {
      _isLoading = true;
    });
    final resImage=await LoginScreenService.getData();
    if(resImage!=null){
      for(int i=0;i<resImage.length;i++){
        _images.add("${ApiContents.imageUrl}/${resImage[i].image??""}");
      }
    }
    setState(() {
      _isLoading=false;
    });
  }
  _openBottomSheetLogin(){
    return
      showModalBottomSheet(
        backgroundColor:  ColorResources.bgColor,
        isScrollControlled: true,
        isDismissible: true,
        enableDrag: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            topLeft: Radius.circular(20.0),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, setModalState) {
                return GestureDetector(
                  onTap: () {
                    // Dismiss keyboard when tapping outside
                    FocusScope.of(context).unfocus();
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      left: 10,
                      right: 10,
                      top: 10,
                    ),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildLogo(),
                                  const SizedBox(height: 20),
                                  Text(
                                    '${AppConstants.appName} ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    S.of(context).LEnterConditionalstologin,
                                    style: const TextStyle(
                                      color: ColorResources.secondaryFontColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            InputLabel.buildLabelBox(S.of(context).LEnterPhoneNumber),
                            const SizedBox(height: 10),
                            Container(
                              decoration: ThemeHelper().inputBoxDecorationShaddow(),
                              child: TextFormField(
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                ],
                                keyboardType: Platform.isIOS
                                    ? const TextInputType.numberWithOptions(decimal: true, signed: true)
                                    : TextInputType.number,
                                textInputAction: TextInputAction.done,
                                validator: (item) {
                                  return item!.length > 5 ? null : S.of(context).LEntervalidnumber;
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
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          showCountryPicker(
                                            context: context,
                                            showPhoneCode: true,
                                            onSelect: (Country country) {
                                              phoneCode = "+${country.phoneCode}";
                                              setModalState(() {});
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  hintText: S.of(context).ex_mobile,
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(color: Colors.grey),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(color: Colors.grey.shade400),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(color: Colors.red, width: 2.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(color: Colors.red, width: 2.0),
                                  ),
                                ),
                                onFieldSubmitted: (value) {
                                  // Submit form when done is pressed
                                  if (_formKey.currentState!.validate()) {
                                    Navigator.pop(context);
                                    phoneNumberWithCode = "$phoneCode${_mobileController.text}";
                                    _verifyPhone(phoneNumberWithCode);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            SmallButtonsWidget(
                              title: S.of(context).LSubmit,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.pop(context);
                                  phoneNumberWithCode = "$phoneCode${_mobileController.text}";
                                  _verifyPhone(phoneNumberWithCode);
                                }
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        },
      ).whenComplete(() {

      });
  }
  _openBottomSheetForOTP(){
    return
      showModalBottomSheet(
        backgroundColor:  ColorResources.bgColor,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            topLeft: Radius.circular(20.0),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, setModalState) {
                return GestureDetector(
                  onTap: () {
                    // Dismiss keyboard when tapping outside
                    FocusScope.of(context).unfocus();
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                      left: 10,
                      right: 10,
                      top: 10,
                    ),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 10),
                                  Text(
                                    '${S.maybeOf(context)?.LOTPsentto} $phoneNumberWithCode',
                                    style: const TextStyle(
                                      color: ColorResources.secondaryFontColor,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: InputLabel.buildLabelBox(S.of(context).LEnterOTP),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              decoration: ThemeHelper().inputBoxDecorationShaddow(),
                              child: TextFormField(
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                ],
                                keyboardType: Platform.isIOS
                                    ? const TextInputType.numberWithOptions(decimal: true, signed: true)
                                    : TextInputType.number,
                                textInputAction: TextInputAction.done,
                                validator: (item) {
                                  return item!.length > 5 ? null : S.of(context).LEntervalidOtp;
                                },
                                controller: _otpController,
                                decoration: InputDecoration(
                                  hintText: S.of(context).LOTP,
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(color: Colors.grey),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(color: Colors.grey.shade400),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(color: Colors.red, width: 2.0),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(color: Colors.red, width: 2.0),
                                  ),
                                ),
                                onFieldSubmitted: (value) {
                                  // Submit form when done is pressed
                                  if (_formKey.currentState!.validate()) {
                                    Navigator.pop(context);
                                    _handleAuth();
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _handeCancelBtn();
                                  },
                                  child: Text(
                                    S.of(context).LCancel,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Obx(() {
                                  return TextButton(
                                    onPressed: _timerController.timeSecond.value != 0
                                        ? null
                                        : () {
                                            Navigator.pop(context);
                                            _handelResendBtn();
                                          },
                                    child: Text(
                                      "${S.of(context).LResend} ${_timerController.timeSecond}(s)",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                            const SizedBox(height: 20),
                            SmallButtonsWidget(
                              title: S.of(context).LSubmit,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.pop(context);
                                  _handleAuth();
                                }
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        },
      ).whenComplete(() {

      });
  }
  _openBottomSheetForRegisterUser(){
    return
      showModalBottomSheet(
        backgroundColor:  ColorResources.bgColor,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            topLeft: Radius.circular(20.0),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              // Dismiss keyboard when tapping outside
              FocusScope.of(context).unfocus();
            },
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 10,
                right: 10,
                top: 10,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            Text(
                              '${S.of(context).LRegister} $phoneNumberWithCode',
                              style: const TextStyle(
                                color: ColorResources.secondaryFontColor,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        child: TextFormField(
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: (item) {
                            return item!.length > 3 ? null : S.of(context).LEnterfirstname;
                          },
                          controller: _fNameController,
                          decoration: ThemeHelper().textInputDecoration(S.of(context).LFirstName),
                          onFieldSubmitted: (value) {
                            // Move focus to last name field
                            FocusScope.of(context).nextFocus();
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        child: TextFormField(
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.done,
                          validator: (item) {
                            return item!.length > 3 ? null : S.of(context).LEnterLastname;
                          },
                          controller: _lastNameController,
                          decoration: ThemeHelper().textInputDecoration(S.of(context).LLastName),
                          onFieldSubmitted: (value) {
                            // Submit form when done is pressed
                            if (_formKey.currentState!.validate()) {
                              Navigator.pop(context);
                              _handleRegister();
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      SmallButtonsWidget(
                        title: S.of(context).LSubmit,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pop(context);
                            _handleRegister();
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ).whenComplete(() {

      });
  }
  _buildLogo() {
    return SizedBox(
      height: 130,
      child: Image.asset(ImageConstants.logoImage),
    );
  }
  Future<void> _verifyPhone(phoneNo) async {

    setState(() {
      _isLoading = true;
    });
    verified(AuthCredential authResult) async {
      //AuthService()
      bool verified = await signIn(authResult).catchError((onError) {
        return false;
      });
      if (verified) {
        _timer!.cancel();
        setState(() {
          _start = 60;
          _timerController.setValue(60);
          _codeSent = false;
          _isLoading = false;
        });
        IToastMsg.showMessage(S.of(context).LVerified);
        //  Signed In
        _handeCancelBtn();
        _handleLogin();
      }
    }

    verificationFailed(FirebaseAuthException authException) {

      IToastMsg.showMessage(S.of(context).LSomethingwentwrong);
      setState(() {
        _isLoading = false;
        otpSendFailed=true;
      });
    }

    smsSent(String? verId, [int? forceResend]) {
      _verificationId = verId!;
      setState(() {
        _codeSent = true;
        _isLoading = false;
      });
      _otpController.clear();
      _fNameController.clear();
      _lastNameController.clear();
      _openBottomSheetForOTP();
      startTimer();
    }

    autoTimeout(String verId) {
      _verificationId = verId;
    }

    await FirebaseAuth.instance
        .verifyPhoneNumber(
        phoneNumber: phoneNo, //country code with phone number
        timeout: const Duration(seconds: 60),
        verificationCompleted: verified,
        verificationFailed: verificationFailed, //error handling function
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout)
        .catchError((e) {

    });
  }
  Future<bool> signIn(AuthCredential authCreds) async {
    bool isVerified = false;
    await FirebaseAuth.instance.signInWithCredential(authCreds).then((auth) {
      //Successfully otp verified
      isVerified = true;
    }).catchError((e) {
      isVerified = false;
    });
    return isVerified;
  }

  void startTimer() {
    const oneSec =  Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
            _timerController.setValue(_start);
          });
        }
      },
    );
  }
  _handelResendBtn(){
    if(_timer!=null){  _timer!.cancel();}
    _verifyPhone(phoneNumberWithCode);
    _timerController.setValue(60);
    _start=60;
    _codeSent=false;
  }
  _handeCancelBtn(){
    if(_timer!=null){  _timer!.cancel();}
    _timerController.setValue(60);
    _start=60;
    _codeSent=false;
  }
  _handleAuth() async {
    setState(() {
      _isLoading=true;
    });
    bool verified = await signInWithOTP(_otpController.text, _verificationId)
        .catchError((onError) {
      return false;
    });
    if (verified) {
      IToastMsg.showMessage(S.of(context).LVerified);
      //  Signed In
      _handeCancelBtn();
      _handleLogin();
      // Get.to(()=>LoginPage(onSuccessLogin:widget.onSuccessLogin));
    } else {
      IToastMsg.showMessage(S.of(context).LPleaseenteravalidotp);
      setState(() {
        _isLoading=false;
      });
      _openBottomSheetForOTP();
    }

  }
  Future<bool> signInWithOTP(smsCode, verId) async {
    AuthCredential authCreds =
    PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    bool verified = await signIn(authCreds).catchError((e) {
      return false;
    });
    return verified;
  }

  void _handleRegister() async{
    setState(() {
      _isLoading=true;
    });
    final res=await UserService.addUser(fName: _fNameController.text,
        lName: _lastNameController.text,
        isdCode: phoneCode,
        phone: _mobileController.text);
    if(res!=null){
      IToastMsg.showMessage(S.of(context).LSuccessfullyRegistered);
      _handleLogin();
    }else{
      setState(() {
        _isLoading=false;
      });
      _openBottomSheetForRegisterUser();
    }

  }

  void _handleLogin() async{
    setState(() {
      _isLoading=true;
    });
    final res=await UserService.loginUser(phone: _mobileController.text);
    if(res!=null){
      //    'message' => "Not Exists",
      if(res['message']=="Not Exists"){
        setState(() {
          _isLoading=false;
        });
        _openBottomSheetForRegisterUser();
      }
      else if(res['message']=="Successfully"){
        IToastMsg.showMessage("Logged in");
        _handleSuccessLogin(res);
      }
    }else{
      IToastMsg.showMessage(S.of(context).LSomethingwentwrong);
      setState(() {
        _isLoading=false;
      });
    }

  }
  _handleSuccessLogin(var res) async {
    setState(() {
      _isLoading=true;
    });
    final userData=res;
    SharedPreferences preferences=await SharedPreferences.getInstance();
    await  preferences.setString(SharedPreferencesConstants.token,userData['token']);
    await  preferences.setString(SharedPreferencesConstants.uid,userData['data']['id'].toString());
    await  preferences.setString(SharedPreferencesConstants.name,"${userData['data']['f_name']} ${userData['data']['l_name']}");
    await  preferences.setString(SharedPreferencesConstants.phone,userData['data']['phone']);
    await  preferences.setBool(SharedPreferencesConstants.login,true);
    UserController userController=Get.find(tag: "user");
    userController.getData();
    UserService.updateFCM();
    UserSubscribe.toTopi(topicName: "PATIENT_APP");
    Get.back();
    if( widget.onSuccessLogin!=null){
      widget.onSuccessLogin!();
    }
    setState(() {
      _isLoading=false;
    });
    // Get.to(()=>LoginPage(onSuccessLogin:widget.onSuccessLogin));
  }

}
