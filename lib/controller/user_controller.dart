import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';
import '../services/user_service.dart';
import '../utilities/sharedpreference_constants.dart';

class UserController extends GetxController{
  var isLoading=false.obs; //Loading for data fetching
  var usersData= UserModel().obs; //Object of blog post model
  var isError=false.obs;

  void getData()async{
  isLoading(true);
  try{
    // Check if user is logged in first
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final loggedIn = preferences.getBool(SharedPreferencesConstants.login) ?? false;
    final userId = preferences.getString(SharedPreferencesConstants.uid);
    
    if (!loggedIn || userId == null || userId.isEmpty) {
      // User is not logged in, clear data
      clearUserData();
      return;
    }
    
    final getDataList=await UserService.getDataById(); //Get all blog post list details from the blog post service page
    if (getDataList!=null) {
      isError(false);
      usersData.value=getDataList;
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

  // Method to clear user data on logout
  void clearUserData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
   await preferences.clear();

    isLoading(false);
    usersData.value = UserModel(); // Reset to empty user model
    isError(false);
  }
}
