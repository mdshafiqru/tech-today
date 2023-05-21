import 'dart:convert';

import 'package:blog/app/constants/app_string.dart';
import 'package:blog/app/constants/helper_function.dart';
import 'package:blog/app/models/response_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/auth/user.dart';
import '../../service/auth_service.dart';
import '../../service/profile_service.dart';
import 'post_controller.dart';

class ProfileController extends GetxController {
  final _storage = GetStorage();
  final _profileService = ProfileService();
  final _authService = AuthService();
  final _imagePicker = ImagePicker();

  var gettingUser = false.obs;
  var showPasswordCard = false.obs;
  var changingPassword = false.obs;
  var updatingProfile = false.obs;
  var updatingProfilePhoto = false.obs;

  var profilePhotoPath = "".obs;
  var avatar = "".obs;

  String currentPass = "";
  String newPass = "";

  String name = "";
  String phone = "";
  String shortBio = "";

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
        avatar.value = userResponse.avatar ?? "";

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

  updateProfile() async {
    if (!updatingProfile.value) {
      updatingProfile.value = true;

      var body = jsonEncode({
        "name": name,
        "phone": phone,
        "shortBio": shortBio,
      });

      final response = await _profileService.updateProfile(body: body);

      if (response.error == null) {
        final status = response.data != null ? response.data as ResponseStatus : ResponseStatus();

        bool success = status.success ?? false;

        if (success) {
          getUser();

          showCustomDialog(title: "Success", message: status.message ?? "");
          updatingProfile.value = false;
        } else {
          showError(error: status.message ?? "");
          updatingProfile.value = false;
        }
      } else if (response.error == UN_AUTHENTICATED) {
        logout();
        updatingProfile.value = false;
      } else {
        showError(error: response.error ?? "");
        updatingProfile.value = false;
      }
    }
  }

  selectProfilePhoto({required ImageSource source}) async {
    var pickedFile = await _imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      profilePhotoPath.value = pickedFile.path;

      if (pickedFile.path.isNotEmpty) {
        updateProfilePhoto(pickedFile.path);
      } else {
        Get.snackbar(
          "Failed",
          "Image Uplaod Failed",
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      Get.snackbar(
        "Not selected",
        "No image selected.",
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  updateProfilePhoto(String imagePath) async {
    if (!updatingProfilePhoto.value) {
      updatingProfilePhoto.value = true;

      final response = await _profileService.updateProfilePhoto(imagePath);

      if (response.error == null) {
        final status = response.data != null ? response.data as ResponseStatus : ResponseStatus();

        bool success = status.success ?? false;

        if (success) {
          String avatarImage = status.data != null ? status.data as String : "";

          avatar.value = avatarImage;

          updatingProfilePhoto.value = false;

          Get.find<PostController>().getData();

          showCustomDialog(message: status.message ?? "", title: "Success");
        } else {
          showError(error: status.message ?? "");
          updatingProfilePhoto.value = false;
        }

        //
      } else if (response.error == UN_AUTHENTICATED) {
        logout();
        updatingProfilePhoto.value = false;
      } else {
        showError(error: response.error ?? "");
        updatingProfilePhoto.value = false;
      }
    }
  }

  @override
  void onInit() {
    getUser();
    super.onInit();
  }
}
