import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/api_string.dart';
import '../constants/app_string.dart';
import '../constants/helper_function.dart';
import '../models/api_response.dart';
import '../models/auth/user.dart';

class ProfileService {
  Future<ApiResponse> getUser() async {
    ApiResponse apiResponse = ApiResponse();

    try {
      var url = Uri.parse(userApi);

      String token = await getToken();

      var headers = {"Accept": "application/json", 'Authorization': 'Bearer $token'};

      final response = await http.get(url, headers: headers);

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        apiResponse.data = User.fromJson(json);
        //
      } else {
        apiResponse.error = handleError(response.statusCode, json);
      }

      //
    } catch (e) {
      apiResponse.error = SOMETHING_WENT_WRONG;
    }

    return apiResponse;
  }
}
