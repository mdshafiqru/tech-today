// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../constants/colors.dart';
import '../../../controllers/auth/forget_pass_controller.dart';

class NewPasswordView extends StatefulWidget {
  const NewPasswordView({super.key});

  @override
  State<NewPasswordView> createState() => _NewPasswordViewState();
}

class _NewPasswordViewState extends State<NewPasswordView> {
  final _passwordController = TextEditingController();

  final _passwordKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
          child: Form(
            key: _passwordKey,
            child: ListView(
              children: [
                SizedBox(height: 50.w),
                _logo(),
                SizedBox(height: 15.w),
                _title(),
                SizedBox(height: 25.w),
                _passwordField(),
                SizedBox(height: 15.w),
                _submitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _passwordField() {
    return Obx(() {
      final controller = Get.find<ForgetPassController>();
      return TextFormField(
        obscureText: controller.hidePassword.value,
        style: TextStyle(fontSize: 14.sp),
        decoration: InputDecoration(
          labelText: "Password",
          labelStyle: TextStyle(color: kBaseColor),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kBaseColor, width: 2),
          ),
          border: OutlineInputBorder(borderSide: BorderSide(color: kBaseColor)),
          contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 13.w),
          prefixIcon: Icon(Icons.lock, color: kBaseColor),
          suffixIcon: IconButton(
            onPressed: () {
              controller.hidePassword.value = !controller.hidePassword.value;
            },
            icon: controller.hidePassword.value ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
          ),
        ),
        controller: _passwordController,
        onChanged: (value) {
          Get.find<ForgetPassController>().newPass = value;
        },
        validator: MultiValidator([
          RequiredValidator(errorText: "Password is required"),
          MinLengthValidator(6, errorText: "Password must be at least 6 character long."),
        ]),
      );
    });
  }

  Widget _submitButton() {
    final controller = Get.find<ForgetPassController>();
    return MaterialButton(
      height: 40.w,
      color: kBaseColor,
      onPressed: () {
        if (_passwordKey.currentState!.validate()) {
          controller.handleSubmit();
        }
      },
      child: Obx(() {
        return controller.checkingSubmit.value
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
                "Submit",
                style: TextStyle(fontSize: 15.sp, color: whiteColor),
              );
      }),
    );
  }

  Widget _title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "New Password",
          style: TextStyle(fontSize: 22.sp),
        ),
      ],
    );
  }

  Widget _logo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/images/logo.png", width: 80.w),
      ],
    );
  }
}
