import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userapp/model/appointment_categories.dart';
import '../helpers/get_req_helper.dart';
import '../helpers/post_req_helper.dart';
import '../model/appointment_model.dart';
import '../utilities/api_content.dart';
import '../utilities/sharedpreference_constants.dart';
import 'package:http/http.dart' as http;


class AppointmentService{

   static const  getAppByUIDUrl=   ApiContents.getAppByUIDUrl;
   static const  getAppByIDUrl=   ApiContents.getAppByIDUrl;
  static const  addAppUrl=   ApiContents.addAppUrl;
  static const  addAppointmentWebUrl=   ApiContents.addAppointmentUrl;

  static List<AppointmentModel> dataFromJson (jsonDecodedData){
    return List<AppointmentModel>.from(jsonDecodedData.map((item)=>AppointmentModel.fromJson(item)));
  }
  static Future addAppointment(
      {
       // required String patientId,
        required String status,
        required String date,
        required String timeSlots,
        required String doctId,
        required String deptId,
        required String type,
        required String meetingId,
        required String meetingLink,
        required String paymentStatus,
        required String fee,
        required String serviceCharge,
        required String totalAmount,
        required String invoiceDescription,
        required String paymentMethod,
        required String paymentTransactionId,
        required String isWalletTxn,
        required String familyMemberId,
        required String couponId,
        required String couponValue,
        required String couponTitle,
        required String couponOffAmount,
        required String tax,
        required String unitTaxAmount,
        required String unitTotalAmount,
        required String appointmentCategoryTypeId, required String appointmentSubTypeId,
        
}
      )async{
    SharedPreferences preferences=await  SharedPreferences.getInstance();
    final uid= preferences.getString(SharedPreferencesConstants.uid)??"-1";
    Map body={
       "family_member_id":familyMemberId,
      //'patient_id': patientId,
      'status': status,
      'date': date,
      'time_slots': timeSlots,
      'doct_id': doctId,
      'dept_id': deptId,
      'type': type,
      'meeting_id': meetingId,
      'meeting_link': meetingLink,
      'payment_status': paymentStatus,
      'fee': fee,
      'service_charge': serviceCharge,
      'total_amount': totalAmount,
      'invoice_description': invoiceDescription,
      'payment_method': paymentMethod,
      'user_id': uid,
      'payment_transaction_id': paymentTransactionId,
      "is_wallet_txn":isWalletTxn,
      "coupon_id":couponId,
      "coupon_title":couponTitle,
      "coupon_value":couponValue,
      "coupon_off_amount":couponOffAmount,
      "unit_tax_amount":unitTaxAmount,
      "tax":tax,
      "unit_total_amount":unitTotalAmount,
      "appointment_category_type_id": appointmentCategoryTypeId,
      "appointment_sub_type_id": appointmentSubTypeId,
      "source":Platform.isAndroid?"Android App":Platform.isIOS?"Ios App":""
    };
    final res=await PostService.postReq(addAppUrl, body);
    return res;
  }

  /// New simplified appointment creation method for web endpoint
  static Future addAppointmentWeb({
    required String familyMemberId,
    required String status,
    required String date,
    required String timeSlots,
    required String doctId,
    required String deptId,
    required String appointmentCategoryTypeId,
    required String paymentStatus,
    required String paymentMethod,
    required String totalAmount,
    required String fee,
    String? notes,
  }) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final uid = preferences.getString(SharedPreferencesConstants.uid) ?? "-1";
    
    Map body = {
      "family_member_id": familyMemberId,
      "status": status,
      "date": date,
      "time_slots": timeSlots,
      "doct_id": doctId,
      "dept_id": deptId,
      "appointment_category_type_id": appointmentCategoryTypeId,
      "payment_status": paymentStatus,
      "payment_method": paymentMethod,
      "total_amount": totalAmount,
      "notes": notes ?? "",
      "user_id": uid,
      "fee":fee,
      "source": Platform.isAndroid ? "Android App" : Platform.isIOS ? "iOS App" : ""
    };
    
    final res = await PostService.postReq(addAppointmentWebUrl, body);
    return res;
  }

  static Future <List<AppointmentModel>?> getData()async {
    SharedPreferences preferences=await  SharedPreferences.getInstance();
    final uid= preferences.getString(SharedPreferencesConstants.uid)??"-1";
    final res=await GetService.getReq("$getAppByUIDUrl/$uid");
    if(res==null) {
      return null;
    } else {
      List<AppointmentModel> dataModelList = dataFromJson(res);
      return dataModelList;
    }
  }
   static Future <AppointmentModel?> getDataById({required String? appId})async {
     final res=await GetService.getReq("$getAppByIDUrl/${appId??""}");
     if(res==null) {
       return null;
     } else {
       AppointmentModel dataModel = AppointmentModel.fromJson(res);
       return dataModel;
     }
   }
static Future<AppointmentCategoryResponse?> getAppointmentCategories() async {
  try {
    final url = Uri.parse(ApiContents.getAppointmentCategoriesUrl);
    debugPrint('Sending request to: $url');

    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.getString(SharedPreferencesConstants.token);

    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return AppointmentCategoryResponse.fromJson(jsonData);
    } else {
      debugPrint('Error: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    debugPrint('Exception: $e');
    return null;
  }
}
}










