import 'package:get/get.dart';
import '../model/time_slots_model.dart';
import '../services/time_slots_service.dart';

class TimeSlotsController extends GetxController {
  var isLoading = false.obs; // Loading for data fetching
  var dataList = <TimeSlotsModel>[].obs; // list of all fetched data

  var isError = false.obs;


  void getData(String doctId,String day,String slotType,String departmentId) async {
    print('⏰ TimeSlotsController.getData called with:');
    print('  - doctId: $doctId');
    print('  - day: $day');
    print('  - slotType: $slotType');
    print('  - departmentId: $departmentId');
    
    isLoading(true);
    try {
      final getDataList = await TimeSlotsService.getData(doctId: doctId,day: day,slotType: slotType,deptId: departmentId);

      if (getDataList !=null) {
        print('✅ TimeSlotsController: Received ${getDataList.length} time slots');
        for (var slot in getDataList) {
          print('   - Time slot: ${slot.timeStart} - ${slot.timeEnd}');
        }
        isError(false);
        dataList.value = getDataList;
      } else {
        print('❌ TimeSlotsController: No data received (null response)');
        isError(true);
      }
    } catch (e) {
      print('❌ TimeSlotsController: Error occurred: $e');
      isError(true);
    } finally {
      isLoading(false);
    }
  }

}
