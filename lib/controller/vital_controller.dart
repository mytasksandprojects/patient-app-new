import 'package:get/get.dart';
import '../services/vitals_service.dart';

class VitalController extends GetxController{
  var isLoading=false.obs; //Loading for data fetching
  var dataList= [].obs; //Object of blog post model
  var isError=false.obs;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  void getData(String familyMemberId,String type,String startDate,String endDate)async{
    isLoading(true);
    try{
      final getDataList=await VitalsService.getData(familyMemberId,type,startDate,endDate); //Get all blog post list details from the blog post service page
      if (getDataList!=null) {
        isError(false);
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


}
