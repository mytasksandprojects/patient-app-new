import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';
import '../utilities/api_content.dart';
import '../utilities/sharedpreference_constants.dart';
import '../helpers/get_req_helper.dart';
import '../helpers/post_req_helper.dart';

class UserService{

  static const  getUl=   ApiContents.getUserUrl;
  static const  addUserUrl=   ApiContents.addUserUrl;
  static const  loginPhoneUrl=   ApiContents.loginPhoneUrl;
  static const  updateUserUrl=   ApiContents.updateUserUrl;
  static const  useSoftDeleteUrl=   ApiContents.useSoftDeleteUrl;
  static const  loginOutUrl=   ApiContents.loginOutUrl;


  static UserModel dataFromJsonById(data) {
    return UserModel.fromJson(data);
  }

  static Future <UserModel?> getDataById()async {

    SharedPreferences preferences = await SharedPreferences.getInstance();
    final uid=  preferences.getString(SharedPreferencesConstants.uid)??"";
    final res=await GetService.getReq("$getUl/$uid");
    if(res==null) {
      return null;
    } else {
      UserModel dataModel = dataFromJsonById(res);
      return dataModel;
    }
  }
  static Future addUser({
    required String fName,
    required String lName,
    required String isdCode,
    required String phone,

  })async{
    Map body={
      "f_name":fName,
      "l_name":lName,
      "isd_code":isdCode,
      "phone":phone,
    };
    final res=await PostService.postReq(addUserUrl, body);
    return res;
  }

  static Future loginUser({
    required String phone,

  })async{
    Map body={
      "phone":phone,
    };
    final res=await PostService.postReq(loginPhoneUrl, body);
    return res;
  }
  static Future logOutUser()async{
    Map body={
    };
    final res=await PostService.postReq(loginOutUrl, body);
    return res;
  }


  static Future updateProfile({
    required String fName,
    required String lName,
    required String gender,
    required String dob,
    required String email,
  })async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    final uid=preferences.getString(SharedPreferencesConstants.uid)??"";
    Map body={
      "id":uid,
      "f_name":fName,
      "l_name":lName,
      "gender":gender,
      "dob":dob,
      "email":email
    };
    final res=await PostService.postReq(updateUserUrl, body);
    return res;
  }
  static Future softDelete()async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    final uid=preferences.getString(SharedPreferencesConstants.uid)??"";
    Map body={
      "user_id":uid
    };
    final res=await PostService.postReq(useSoftDeleteUrl, body);
    return res;
  }

  static Future updateFCM()async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    final uid=preferences.getString(SharedPreferencesConstants.uid)??"";
    String fcm="";
    try{
      final  fcmRes=await FirebaseMessaging.instance.getToken();
      fcm=fcmRes??"";
      if (kDebugMode) {
        print("Fcm Token $fcm");
      }
    }catch(e){
      if (kDebugMode) {
        print(e);
      }
    }
    Map body={
      "id":uid,
      "fcm":fcm,

    };
    final res=await PostService.postReq(updateUserUrl, body);
    return res;
  }
  static Future updateNotificationLastSeen()async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    final uid=preferences.getString(SharedPreferencesConstants.uid)??"";

    Map body={
      "id":uid,
      "notification_seen_at":"update"
    };
    final res=await PostService.postReq(updateUserUrl, body);
    return res;
  }

}