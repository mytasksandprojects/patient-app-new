import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:userapp/model/medical_history_model.dart';
import 'package:userapp/utilities/api_content.dart';

class MedicalHistoryService {
  static Future<MedicalHistoryResponse?> getMedicalHistory(int patientId) async {
    try {
      String url = "${ApiContents.baseApiUrl}/patient/$patientId/history";
      
      var dio = Dio();
      final response = await dio.get(url);
      
      if (kDebugMode) {
        print("==================Medical History URL==============");
        print(url);
        print("==================Medical History Response==============");
        print(response.data);
      }
      
      if (response.statusCode == 200) {
        final jsonData = response.data;
        
        // Check if the response has the expected structure
        if (jsonData != null && jsonData['status'] == 'success') {
          return MedicalHistoryResponse.fromJson(jsonData);
        } else {
          if (kDebugMode) {
            print("Invalid response structure: $jsonData");
          }
          return null;
        }
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching medical history: $e");
      }
      return null;
    }
  }
}
