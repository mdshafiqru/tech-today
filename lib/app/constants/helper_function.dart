// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../views/auth/signin/signin_view.dart';
import 'app_string.dart';
import 'colors.dart';

final _storage = GetStorage();
final _secureStorage = FlutterSecureStorage();

Future<String> getToken() async {
  String token = await _secureStorage.read(key: AUTH_TOKEN) ?? "";

  return token;
}

void showError({required String error, String? title}) {
  Get.defaultDialog(
    title: title ?? "Opps!",
    content: Column(
      // mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          error,
          style: TextStyle(fontSize: 13.sp),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 5.w),
        MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.r),
          ),
          color: kBaseColor,
          onPressed: () => Get.back(),
          child: Text(
            "Ok",
            style: TextStyle(fontSize: 14.sp, color: whiteColor),
          ),
        ),
      ],
    ),
  );
}

void logout() {
  _storage.remove(IS_LOGGED_IN);
  _storage.remove(USER_NAME);
  _storage.remove(USER_EMAIL);
  _storage.remove(USER_AVATAR);
  _secureStorage.delete(key: AUTH_TOKEN);

  Get.offAll(() => SigninView());
}

handleError(int statusCode, json) {
  switch (statusCode) {
    case 400:
      return json['message'] ?? "Something went wrong";

    case 401:
      return UN_AUTHENTICATED;

    case 422:
      final errors = json['errors'];
      return errors[errors.keys.elementAt(0)][0];

    case 403:
      return json['message'];

    case 500:
      return SERVER_ERROR;

    default:
      return SOMETHING_WENT_WRONG;
  }
}

getCustomDate(String date) {
  if (date.isEmpty) {
    return "";
  }
  DateTime time = DateTime.parse(date);
  int month = time.month;
  int day = time.day;
  int year = time.year;
  String newDay = day < 10 ? '0$day' : '$day';
  String newMonth = month < 10 ? '0$month' : '$month';

  String newDate = '$newDay-$newMonth-$year';

  return newDate;
}
