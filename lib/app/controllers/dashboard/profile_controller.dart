import 'dart:convert';

import 'package:blog/app/constants/app_string.dart';
import 'package:blog/app/constants/helper_function.dart';
import 'package:blog/app/models/response_status.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/auth/user.dart';
import '../../service/auth_service.dart';
import '../../service/profile_service.dart';

class ProfileController extends GetxController {
  final _storage = GetStorage();
  final _profileService = ProfileService();
  final _authService = AuthService();

  var gettingUser = false.obs;
  var showPasswordCard = false.obs;
  var changingPassword = false.obs;

  String currentPass = "";
  String newPass = "";

  var user = User().obs;

  getUser() async {
    if (!gettingUser.value) {
      gettingUser.value = true;

      final response = await _profileService.getUser();

      if (response.error == null) {
        User userResponse = response.data != null ? response.data as User : User();

        await _storage.write(USER_NAME, userResponse.name);
        await _storage.write(USER_ID, userResponse.id);
        await _storage.write(USER_EMAIL, userResponse.email);
        await _storage.write(USER_AVATAR, userResponse.avatar);

        user.value = userResponse;

        gettingUser.value = false;
      } else if (response.error == UN_AUTHENTICATED) {
        logout();
        gettingUser.value = false;
      } else {
        gettingUser.value = false;
      }
    }
  }

  Future<bool> updatePassword() async {
    bool changed = false;
    if (!changingPassword.value) {
      changingPassword.value = true;

      var body = jsonEncode({
        "currentPass": currentPass,
        "newPass": newPass,
      });

      final response = await _authService.updatePassword(body: body);

      if (response.error == null) {
        final status = response.data != null ? response.data as ResponseStatus : ResponseStatus();

        bool success = status.success ?? false;

        if (success) {
          changed = true;
          currentPass = "";
          newPass = "";
          showCustomDialog(title: "Success", message: status.message ?? "");
          changingPassword.value = false;
        } else {
          showError(error: status.message ?? "");
          changingPassword.value = false;
        }
      } else if (response.error == UN_AUTHENTICATED) {
        logout();
        changingPassword.value = false;
      } else {
        showError(error: response.error ?? "");
        changingPassword.value = false;
      }
    }
    return changed;
  }

  @override
  void onInit() {
    getUser();
    super.onInit();
  }
}
