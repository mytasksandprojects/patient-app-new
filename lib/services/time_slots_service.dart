import '../helpers/get_req_helper.dart';
import '../model/time_slots_model.dart';
import '../utilities/api_content.dart';

class TimeSlotsService{
//get_doctor_time_slots/${doctorId}/department/${DoctorDetails?.department}/${dayName}
  static const  getUrl=   ApiContents.getTimeSlotsUrl;
  static const  getVideoUrl=   ApiContents.getVideoTimeSlotsUrl;

  static List<TimeSlotsModel> dataFromJson (jsonDecodedData){

    return List<TimeSlotsModel>.from(jsonDecodedData.map((item)=>TimeSlotsModel.fromJson(item)));
  }

  static Future <List<TimeSlotsModel>?> getData({String? doctId,String? deptId,String? day,String? slotType})async {
    // fetch data
    //slotType=="1"?getUrl:slotType=="2"?getVideoUrl:getUrl
    final url = "$getUrl/$doctId/department/$deptId/$day";
    print('🌐 TimeSlotsService calling URL: $url');
    print('   - slotType: $slotType');
    print('   - Using ${slotType=="1"?"clinic URL":slotType=="2"?"video URL":"default URL"}');
    
    final res=await GetService.getReq(url);
    ///get_doctor_time_slots/{doctor_id}/department/{department_id}/{day}
    
    print('📡 TimeSlotsService response: ${res != null ? "Data received" : "NULL response"}');
    if (res != null) {
      print('   - Response data: $res');
    }
    
    if(res==null) {
      return null; //check if any null value
    } else {
      List<TimeSlotsModel> dataModelList = dataFromJson(res); // convert all list to model
      return dataModelList;  // return converted data list model
    }
  }


}