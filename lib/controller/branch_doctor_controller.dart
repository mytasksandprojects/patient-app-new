import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../model/branch_doctor_model.dart';
import '../services/branch_doctor_service.dart';

class BranchDoctorController extends GetxController {
  var isLoading = false.obs;
  var isError = false.obs;
  var errorMessage = ''.obs;
  var dataList = <BranchDoctorModel>[].obs;
  var selectedDoctor = Rx<BranchDoctorModel?>(null);

  /// Fetch doctors by department/branch ID
  Future<void> getDoctorsByDepartmentId(String departmentId) async {
    try {
      isLoading.value = true;
      isError.value = false;
      errorMessage.value = '';

      final response = await BranchDoctorService.getDoctorsByDepartmentId(
        departmentId: departmentId,
      );

      if (response != null && response.data != null) {
        dataList.value = response.data!;
        // Clear selected doctor when fetching new list
        selectedDoctor.value = null;
        
        debugPrint('Successfully loaded ${dataList.length} doctors for department $departmentId');
      } else {
        dataList.clear();
        isError.value = true;
        errorMessage.value = 'No doctors found for this branch';
        debugPrint('No doctors found for department $departmentId');
      }
    } catch (e) {
      isError.value = true;
      errorMessage.value = 'Failed to load doctors: ${e.toString()}';
      dataList.clear();
      debugPrint('Error fetching doctors by department ID: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Set selected doctor
  void setSelectedDoctor(BranchDoctorModel? doctor) {
    selectedDoctor.value = doctor;
    debugPrint('Selected doctor: ${doctor?.name} (ID: ${doctor?.userId})');
  }

  /// Clear all data
  void clearData() {
    dataList.clear();
    selectedDoctor.value = null;
    isError.value = false;
    errorMessage.value = '';
    isLoading.value = false;
  }

  /// Get doctor by user ID
  BranchDoctorModel? getDoctorById(int userId) {
    try {
      return dataList.firstWhere((doctor) => doctor.userId == userId);
    } catch (e) {
      return null;
    }
  }

  /// Check if department has doctors
  bool get hasDoctors => dataList.isNotEmpty;

  /// Get doctors count
  int get doctorsCount => dataList.length;

  @override
  void onClose() {
    clearData();
    super.onClose();
  }
}
