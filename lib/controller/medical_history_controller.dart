import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userapp/model/medical_history_model.dart';
import 'package:userapp/services/medical_history_service.dart';
import 'package:userapp/utilities/sharedpreference_constants.dart';

class MedicalHistoryController extends GetxController {
  static MedicalHistoryController get to => Get.find();
  
  var isLoading = false.obs;
  var medicalHistoryData = Rxn<MedicalHistoryData>();
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with current user's patient ID
    fetchMedicalHistory();
  }

  Future<void> fetchMedicalHistory({int? patientId}) async {
    try {

      isLoading.value = true;
      errorMessage.value = '';
      
      // Get current user ID from SharedPreferences
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final loggedIn = preferences.getBool(SharedPreferencesConstants.login) ?? false;
      final userId = preferences.getString(SharedPreferencesConstants.uid);
      
      if (!loggedIn || userId == null || userId.isEmpty) {
        errorMessage.value = 'User not logged in';
        return;
      }
      
      // Use provided patientId or current user's ID
      int pid = patientId ?? int.tryParse(userId) ?? 1;
      
      MedicalHistoryResponse? response = await MedicalHistoryService.getMedicalHistory(pid);
      
      if (response != null && response.status == 'success') {
        medicalHistoryData.value = response.data;
      } else {
        errorMessage.value = response?.message ?? 'Failed to fetch medical history';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void refreshMedicalHistory() {
    fetchMedicalHistory();
  }
}
