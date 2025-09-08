import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../model/branch_doctor_model.dart';
import '../utilities/api_content.dart';
import '../utilities/sharedpreference_constants.dart';

class BranchDoctorService {
  static const getDoctorByDepartmentIdUrl = ApiContents.getDoctorByDepartmentIdUrl;

  /// Fetch doctors by department/branch ID
  static Future<BranchDoctorResponse?> getDoctorsByDepartmentId({
    required String departmentId,
  }) async {
    try {
      final url = Uri.parse('$getDoctorByDepartmentIdUrl/$departmentId');
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
        return BranchDoctorResponse.fromJson(jsonData);
      } else {
        debugPrint('Error fetching doctors by department ID: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Exception while fetching doctors by department ID: $e');
      return null;
    }
  }

  /// Get list of BranchDoctorModel from JSON data
  static List<BranchDoctorModel> dataFromJson(jsonDecodedData) {
    return List<BranchDoctorModel>.from(
        jsonDecodedData.map((item) => BranchDoctorModel.fromJson(item)));
  }

  /// Alternative method using existing helper pattern
  static Future<List<BranchDoctorModel>?> getDoctorsByDepartmentIdList({
    required String departmentId,
  }) async {
    try {
      final response = await getDoctorsByDepartmentId(departmentId: departmentId);
      
      if (response?.data != null && response!.data!.isNotEmpty) {
        return response.data!;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error in getDoctorsByDepartmentIdList: $e');
      return null;
    }
  }
}
