// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../constants/colors.dart';
import '../../../controllers/dashboard/profile_controller.dart';
import '../../../models/auth/user.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key, required this.user});

  final User user;

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _shortBioController = TextEditingController();

  final _editProfileKey = GlobalKey<FormState>();

  User user = User();

  setValue() {
    user = widget.user;
    final controller = Get.find<ProfileController>();
    _nameController.text = user.name ?? "";
    _phoneController.text = user.phone ?? "";
    _shortBioController.text = user.shortBio ?? "";

    //
    controller.name = user.name ?? "";
    controller.phone = user.phone ?? "";
    controller.shortBio = user.shortBio ?? "";
  }

  @override
  void initState() {
    setValue();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _shortBioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
          child: Form(
            key: _editProfileKey,
            child: ListView(
              children: [
                SizedBox(height: 20.w),
                _nameField(),
                SizedBox(height: 15.w),
                _phoneField(),
                SizedBox(height: 15.w),
                _shortBio(),
                SizedBox(height: 15.w),
                _updateButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _updateButton() {
    return MaterialButton(
      minWidth: double.infinity,
      color: kBaseColor,
      onPressed: () async {
        if (_editProfileKey.currentState!.validate()) {
          _editProfileKey.currentState!.save();
          Get.find<ProfileController>().updateProfile();
        }
      },
      child: Obx(() {
        final controller = Get.find<ProfileController>();
        return controller.updatingProfile.value
            ? SizedBox(
                height: 30.w,
                width: 30.w,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballSpinFadeLoader,
                  colors: const [Color(0xFFffffff)],
                  strokeWidth: 5.w,
                ),
              )
            : Text(
                "Update",
                style: TextStyle(fontSize: 14.sp, color: whiteColor),
              );
      }),
    );
  }

  Widget _nameField() {
    return TextFormField(
      style: TextStyle(fontSize: 14.sp),
      decoration: InputDecoration(
        labelText: "Full Name",
        labelStyle: TextStyle(color: kBaseColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kBaseColor, width: 2),
        ),
        border: OutlineInputBorder(borderSide: BorderSide(color: kBaseColor)),
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 13.w),
        prefixIcon: Icon(Icons.person, color: kBaseColor),
      ),
      controller: _nameController,
      onSaved: (value) {
        Get.find<ProfileController>().name = value ?? "";
      },
      validator: MultiValidator([
        RequiredValidator(errorText: "Full name is required"),
        MinLengthValidator(3, errorText: "Minimum 3 character required"),
      ]),
    );
  }

  Widget _phoneField() {
    return TextFormField(
      style: TextStyle(fontSize: 14.sp),
      decoration: InputDecoration(
        labelText: "Phone",
        labelStyle: TextStyle(color: kBaseColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kBaseColor, width: 2),
        ),
        border: OutlineInputBorder(borderSide: BorderSide(color: kBaseColor)),
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 13.w),
        prefixIcon: Icon(Icons.person, color: kBaseColor),
      ),
      controller: _phoneController,
      onSaved: (value) {
        Get.find<ProfileController>().phone = value ?? "";
      },
      validator: MultiValidator([
        RequiredValidator(errorText: "Phon is required"),
        MinLengthValidator(3, errorText: "Minimum 3 character required"),
      ]),
    );
  }

  Widget _shortBio() {
    return TextFormField(
      style: TextStyle(fontSize: 14.sp),
      decoration: InputDecoration(
        labelText: "Short Bio",
        labelStyle: TextStyle(color: kBaseColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kBaseColor, width: 2),
        ),
        border: OutlineInputBorder(borderSide: BorderSide(color: kBaseColor)),
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 13.w),
        prefixIcon: Icon(Icons.person, color: kBaseColor),
      ),
      controller: _shortBioController,
      onSaved: (value) {
        Get.find<ProfileController>().shortBio = value ?? "";
      },
      validator: MultiValidator([
        RequiredValidator(errorText: "Short Bio is required"),
        MinLengthValidator(3, errorText: "Minimum 3 character required"),
      ]),
    );
  }
}
