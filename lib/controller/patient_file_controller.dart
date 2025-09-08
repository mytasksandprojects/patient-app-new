import 'dart:io';
import 'package:get/get.dart';
import 'package:userapp/services/patient_files_service.dart';

class PatientFileController extends GetxController{
  var isLoading=false.obs; //Loading for data fetching
  var dataList= [].obs; //Object of blog post model
  var isError=false.obs;
  
  // Upload-related observables
  var isUploading=false.obs; //Loading for file upload
  var uploadProgress=0.0.obs; //Upload progress (0.0 to 1.0)

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  Future<void> getData(String searchQ)async{
    isLoading(true);
    try{
      final getDataList=await PatientFilesService.getData(searchQ); //Get all blog post list details from the blog post service page
      if (getDataList!=null) {
        isLoading(false);
        dataList.value=getDataList;
      } else {
        isError(true);
      } // If its error
    }
    catch(e){
      isError(true);  // If its error
    }
    finally{
      isLoading(false); // Run try block with error ot without error
    }

  }

  /// Upload a patient file
  Future<bool> uploadFile({
    required String fileName,
    required File file,
    required String patientId,
  }) async {
    try {
      isUploading(true);
      uploadProgress(0.0);
      
      final result = await PatientFilesService.uploadPatientFile(
        fileName: fileName,
        file: file,
        patientId: patientId,
      );
      
      if (result != null) {
        uploadProgress(1.0);
        // Refresh the file list after successful upload
        await getData("");
        return true;
      } else {
        return false;
      }
    } catch (e) {
      isError(true);
      return false;
    } finally {
      isUploading(false);
      uploadProgress(0.0);
    }
  }

}
