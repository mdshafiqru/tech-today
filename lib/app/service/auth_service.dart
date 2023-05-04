// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_string.dart';
import '../constants/app_string.dart';
import '../constants/helper_function.dart';
import '../models/api_response.dart';
import '../models/auth/user.dart';
import '../models/response_status.dart';

class AuthService {
  Future<ApiResponse> signIn({required String body}) async {
    var url = Uri.parse(loginApi);

    ApiResponse apiResponse = ApiResponse();

    var headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    try {
      final response = await http.post(url, body: body, headers: headers);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);

        apiResponse.data = User.fromJson(json);
        //
      } else {
        var json = jsonDecode(response.body);

        apiResponse.error = handleError(response.statusCode, json);
      }
    } catch (e) {
      apiResponse.error = SERVER_ERROR;
    }

    return apiResponse;
  }

  Future<ApiResponse> signUp({required String body}) async {
    var url = Uri.parse(registerApi);

    ApiResponse apiResponse = ApiResponse();

    var headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    try {
      final response = await http.post(url, body: body, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var json = jsonDecode(response.body);
        apiResponse.data = User.fromJson(json);
        //
      } else {
        var json = jsonDecode(response.body);
        apiResponse.error = handleError(response.statusCode, json);
      }
    } catch (e) {
      apiResponse.error = SERVER_ERROR;
    }

    return apiResponse;
  }

  Future<ApiResponse> checkResetPass({required String body}) async {
    var url = Uri.parse(checkResetPassApi);

    ApiResponse apiResponse = ApiResponse();

    var headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    try {
      final response = await http.post(url, body: body, headers: headers);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        apiResponse.data = ResponseStatus.fromJson(json);
        //
      } else {
        var json = jsonDecode(response.body);
        apiResponse.error = handleError(response.statusCode, json);
      }
    } catch (e) {
      apiResponse.error = SERVER_ERROR;
    }

    return apiResponse;
  }

  Future<ApiResponse> resetPassword({required String body}) async {
    var url = Uri.parse(resetPassApi);

    ApiResponse apiResponse = ApiResponse();

    var headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };

    try {
      final response = await http.put(url, body: body, headers: headers);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        apiResponse.data = ResponseStatus.fromJson(json);
        //
      } else {
        var json = jsonDecode(response.body);
        apiResponse.error = handleError(response.statusCode, json);
      }
    } catch (e) {
      apiResponse.error = SERVER_ERROR;
    }

    return apiResponse;
  }
}
