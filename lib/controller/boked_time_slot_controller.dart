import 'package:get/get.dart';
import '../model/booked_time_slot_mdel.dart';
import '../services/booked_time_slot_service.dart';

class BookedTimeSlotsController extends GetxController {
  var isLoading = false.obs; // Loading for data fetching
  var dataList = <BookedTimeSlotsModel>[].obs; // list of all fetched data
  var isError = false.obs;

  void getData(String doctId,String date,String departmentId) async {
    print('📚 BookedTimeSlotsController.getData called with:');
    print('  - doctId: $doctId');
    print('  - date: $date');
    print('  - departmentId: $departmentId');
    
    isLoading(true);
    try {
      final getDataList = await BookedTimeSlotsService.getData(doctId: doctId,date: date,depId: departmentId);

      if (getDataList !=null) {
        print('✅ BookedTimeSlotsController: Received ${getDataList.length} booked slots');
        for (var slot in getDataList) {
          print('   - Booked slot: ${slot.timeSlots} on ${slot.date}');
        }
        isError(false);
        dataList.value = getDataList;
      } else {
        print('❌ BookedTimeSlotsController: No data received (null response)');
        isError(true);
      }
    } catch (e) {
      print('❌ BookedTimeSlotsController: Error occurred: $e');
      isError(true);
    } finally {
      isLoading(false);
    }
  }

}
