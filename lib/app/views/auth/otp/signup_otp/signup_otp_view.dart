// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../../constants/colors.dart';
import '../../../../controllers/auth/signup_controller.dart';

class SignupOtpView extends StatefulWidget {
  const SignupOtpView({super.key});

  @override
  State<SignupOtpView> createState() => _SignupOtpViewState();
}

class _SignupOtpViewState extends State<SignupOtpView> {
  final _otpController = TextEditingController();

  final _otpKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
          child: Form(
            key: _otpKey,
            child: ListView(
              children: [
                SizedBox(height: 50.w),
                _logo(),
                SizedBox(height: 15.w),
                _title(),
                SizedBox(height: 25.w),
                _otpText(),
                SizedBox(height: 25.w),
                _otpField(),
                SizedBox(height: 15.w),
                _verifyButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _verifyButton() {
    final controller = Get.find<SignupController>();

    return MaterialButton(
      height: 40.w,
      color: kBaseColor,
      onPressed: () {
        if (_otpKey.currentState!.validate()) {
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
                "Verify",
                style: TextStyle(fontSize: 15.sp, color: whiteColor),
              );
      }),
    );
  }

  Widget _otpField() {
    return TextFormField(
      style: TextStyle(fontSize: 14.sp),
      decoration: InputDecoration(
        labelText: "OTP",
        labelStyle: TextStyle(color: kBaseColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kBaseColor, width: 2),
        ),
        border: OutlineInputBorder(borderSide: BorderSide(color: kBaseColor)),
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 13.w),
      ),
      controller: _otpController,
      validator: RequiredValidator(errorText: "OTP is required"),
    );
  }

  Widget _title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Verify OTP",
          style: TextStyle(fontSize: 22.sp),
        ),
      ],
    );
  }

  Widget _otpText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            "Enter the 6 digit OTP code sent to your email. ",
            style: TextStyle(fontSize: 13.sp),
            textAlign: TextAlign.center,
          ),
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
