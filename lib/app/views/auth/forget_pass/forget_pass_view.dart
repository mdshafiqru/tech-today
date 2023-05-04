// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:blog/app/controllers/auth/forget_pass_controller.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../constants/colors.dart';
import '../../../constants/helper_function.dart';
import '../../../models/response_status.dart';
import '../../../service/auth_service.dart';
import '../../dashboard/dashboard/dashboard_view.dart';
import '../otp/forget_otp/foget_otp_view.dart';
import '../signin/signin_view.dart';

class ForgetPassView extends StatefulWidget {
  const ForgetPassView({super.key});

  @override
  State<ForgetPassView> createState() => _ForgetPassViewState();
}

class _ForgetPassViewState extends State<ForgetPassView> {
  final _emailController = TextEditingController();

  final _forgetKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
          child: Form(
            key: _forgetKey,
            child: ListView(
              children: [
                SizedBox(height: 50.w),
                _logo(),
                SizedBox(height: 15.w),
                _title(),
                SizedBox(height: 25.w),
                _forgetText(),
                SizedBox(height: 25.w),
                _emailField(),
                SizedBox(height: 15.w),
                _getOtpButton(),
                SizedBox(height: 15.w),
                _backToSignIn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _backToSignIn() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => SigninView());
          },
          child: Text(
            "Back to Sign In",
            style: TextStyle(fontSize: 13.sp),
          ),
        ),
      ],
    );
  }

  Widget _getOtpButton() {
    final controller = Get.find<ForgetPassController>();
    return MaterialButton(
      height: 40.w,
      color: kBaseColor,
      onPressed: () {
        if (_forgetKey.currentState!.validate()) {
          controller.sendOtp();
        }
      },
      child: Obx(() {
        return controller.sendingOtp.value
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
                "Get OTP",
                style: TextStyle(fontSize: 15.sp, color: whiteColor),
              );
      }),
    );
  }

  Widget _emailField() {
    return TextFormField(
      style: TextStyle(fontSize: 14.sp),
      decoration: InputDecoration(
        labelText: "Email",
        labelStyle: TextStyle(color: kBaseColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kBaseColor, width: 2),
        ),
        border: OutlineInputBorder(borderSide: BorderSide(color: kBaseColor)),
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 13.w),
        prefixIcon: Icon(Icons.email, color: kBaseColor),
      ),
      controller: _emailController,
      onChanged: (value) {
        Get.find<ForgetPassController>().email = value;
      },
      validator: MultiValidator([
        RequiredValidator(errorText: "Email is required"),
        EmailValidator(errorText: "Enter a valid email"),
      ]),
    );
  }

  Widget _title() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Forget Password?",
          style: TextStyle(fontSize: 22.sp),
        ),
      ],
    );
  }

  Widget _forgetText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            "Forgot your password? Don't worry, just enter your email, we will send a 6 digit OTP code. ",
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
