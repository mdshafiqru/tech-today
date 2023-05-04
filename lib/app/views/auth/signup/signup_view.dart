// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../controllers/auth/signup_controller.dart';
import '../forget_pass/forget_pass_view.dart';
import '../otp/signup_otp/signup_otp_view.dart';
import '../signin/signin_view.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _signupKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
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
            key: _signupKey,
            child: ListView(
              children: [
                SizedBox(height: 50.w),
                _logo(),
                SizedBox(height: 15.w),
                _title(),
                SizedBox(height: 25.w),
                _nameField(),
                SizedBox(height: 15.w),
                _emailField(),
                SizedBox(height: 15.w),
                _passwordField(),
                SizedBox(height: 15.w),
                _nextButton(),
                SizedBox(height: 15.w),
                _signinForgetRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _signinForgetRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        GestureDetector(
          onTap: () {
            Get.to(() => ForgetPassView());
          },
          child: Text(
            "Forget Password?",
            style: TextStyle(fontSize: 13.sp),
          ),
        ),
      ],
    );
  }

  Widget _nextButton() {
    final controller = Get.find<SignupController>();
    return MaterialButton(
      height: 40.w,
      color: kBaseColor,
      onPressed: () {
        if (_signupKey.currentState!.validate()) {
          controller.handleSendOtp();
        }
      },
      child: Obx(() {
        return controller.checkingSendOtp.value
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
                "Next",
                style: TextStyle(fontSize: 15.sp, color: whiteColor),
              );
      }),
    );
  }

  Widget _passwordField() {
    return Obx(() {
      final controller = Get.find<SignupController>();
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
          Get.find<SignupController>().password = value;
        },
        validator: MultiValidator([
          RequiredValidator(errorText: "Password is required"),
          MinLengthValidator(6, errorText: "Password must be at least 6 character long."),
        ]),
      );
    });
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
      onChanged: (value) {
        Get.find<SignupController>().name = value;
      },
      validator: MultiValidator([
        RequiredValidator(errorText: "Full name is required"),
        MinLengthValidator(3, errorText: "Minimum 3 character required"),
      ]),
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
        Get.find<SignupController>().email = value;
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
          "Create Account",
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
