import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userapp/model/patient_file_model.dart';
import 'package:userapp/utilities/sharedpreference_constants.dart';

import '../helpers/get_req_helper.dart';
import '../widget/toast_message.dart';
import '../utilities/api_content.dart';

class PatientFilesService{

  static const  getUrl=   ApiContents.getPatientFileQrl;
  static const  getPatientFileByIdrl=   ApiContents.getPatientFileByIdrl;
  static const  getPatientFileByPatientIUrl=   ApiContents.getPatientFileByPatientIUrl;
  static const  addPatientFileUrl=   ApiContents.addPatientFileUrl;


  static List<PatientFileModel> dataFromJson (jsonDecodedData){

    return List<PatientFileModel>.from(jsonDecodedData.map((item)=>PatientFileModel.fromJson(item)));
  }

  static Future <List<PatientFileModel>?> getData(String searchQ)async {
    SharedPreferences preferences=await SharedPreferences.getInstance();
    final uid=preferences.getString(SharedPreferencesConstants.uid);

    // fetch data
    final res=await GetService.getReq("$getUrl?user_id=$uid&search_query=$searchQ");

    if(res==null) {
      return null; //check if any null value
    } else {
      List<PatientFileModel> dataModelList = dataFromJson(res); // convert all list to model
      return dataModelList;  // return converted data list model
    }
  }
  static Future <PatientFileModel?> getDataById({required String? id})async {
    final res=await GetService.getReq("$getPatientFileByIdrl/${id??""}");
    if(res==null) {
      return null;
    } else {
      PatientFileModel dataModel = PatientFileModel.fromJson(res);
      return dataModel;
    }
  }
  static Future <List<PatientFileModel>?> getDataByPatientId(String id)async {

    // fetch data
    final res = await GetService.getReq("$getPatientFileByPatientIUrl/$id");

    if (res == null) {
      return null; //check if any null value
    } else {
      List<PatientFileModel> dataModelList = dataFromJson(
          res); // convert all list to model
      return dataModelList; // return converted data list model
    }
  }

  /// Upload a patient file
  static Future<Map<String, dynamic>?> uploadPatientFile({
    required String fileName,
    required File file,
    required String patientId,
  }) async {
    try {
      if (kDebugMode) {
        print("======Upload File URL==========");
        print(addPatientFileUrl);
        print("======File Path==========");
        print(file.path);
        print("======File Name==========");
        print(fileName);
        print("======Patient ID==========");
        print(patientId);
      }

      SharedPreferences preferences = await SharedPreferences.getInstance();
      final token = preferences.getString(SharedPreferencesConstants.token) ?? "";
      final userId = preferences.getString(SharedPreferencesConstants.uid) ?? "";

      if (kDebugMode) {
        print("======Token==========");
        print("Token: ${token.isNotEmpty ? 'Present (${token.length} chars)' : 'MISSING'}");
        print("User ID: $userId");
      }

      var dio = Dio();
      dio.options.headers["authorization"] = "Bearer $token";
      dio.options.headers["Accept"] = "application/json";
      // Don't set Content-Type for multipart - Dio will set it automatically with boundary
      dio.options.validateStatus = (status) {
        return status! < 500;
      };

      // Create form data
      FormData formData = FormData.fromMap({
        'file_name': fileName,
        'patient_id': patientId,
        'user_id': userId,
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });

      if (kDebugMode) {
        print("======Form Data==========");
        print("file_name: $fileName");
        print("patient_id: $patientId");
        print("user_id: $userId");
        print("file: ${file.path}");
      }

      final response = await dio.post(addPatientFileUrl, data: formData);

      if (kDebugMode) {
        print("==========Upload Response==========");
        print("Status Code: ${response.statusCode}");
        print("Response Headers: ${response.headers}");
        print("Response Type: ${response.data.runtimeType}");
        
        // Check if response is HTML (indicating an error page)
        if (response.data is String && response.data.toString().contains('<!DOCTYPE html>')) {
          print("ERROR: Received HTML response instead of JSON");
          print("This usually indicates authentication failure or wrong endpoint");
        } else {
          print("Response Data: ${response.data}");
        }
      }

      if (response.statusCode == 200) {
        // Check if response is HTML (error page)
        if (response.data is String && response.data.toString().contains('<!DOCTYPE html>')) {
          IToastMsg.showMessage("Authentication failed. Please log in again.");
          return null;
        }
        
        try {
          final responseData = response.data;
          if (responseData is Map<String, dynamic> && responseData['response'] == 200) {
            IToastMsg.showMessage("File uploaded successfully");
            return responseData;
          } else if (responseData is Map<String, dynamic>) {
            IToastMsg.showMessage(responseData['message'] ?? "Upload failed");
            return null;
          } else {
            IToastMsg.showMessage("Invalid response format");
            return null;
          }
        } catch (e) {
          if (kDebugMode) {
            print("Error parsing response: $e");
          }
          IToastMsg.showMessage("Invalid response from server");
          return null;
        }
      } else if (response.statusCode == 401) {
        IToastMsg.showMessage("Session expired. Please log in again.");
        return null;
      } else {
        IToastMsg.showMessage("Upload failed. Server returned ${response.statusCode}");
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Upload error: $e");
      }
      IToastMsg.showMessage("Upload failed: ${e.toString()}");
      return null;
    }
  }

}