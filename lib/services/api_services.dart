
import 'package:cleanconnectortab/constants/const_api.dart';
import 'package:dio/dio.dart';

class ApiServices {
  static Future<Map<String, dynamic>> getLoggedUserDetails(
      String userId, String token) async {
    print("Getting userdata....");

    final response = await Dio().get(
        "${BASE_API2}user/getCleanerUsersById/$userId",
        options: Options(headers: {"Authorization": "Bearer $token"}));
    var data = response.data['result'];
    print("DATA: $data");
    if (response.statusCode == 200) {
      final List<dynamic> usersData = response.data['result'];
      print("List: $usersData");
      int index =
          usersData.indexWhere((element) => element['user_id'] == userId);
      String fname = usersData[index]['f_name'];
      String lname = usersData[index]['l_name'];
      String siteId = usersData[index]['site_id'] ?? "";
      print("Site id ###############" + usersData[index]['site_id'] ?? " ");

      final Map<String, String> userDetails = {
        'fname': fname,
        'lname': lname,
        'siteId': siteId
      };

      
      print(userDetails.toString());
      return userDetails;
    } else {
      throw Exception('Failed to load user data');
    }
  }
}
