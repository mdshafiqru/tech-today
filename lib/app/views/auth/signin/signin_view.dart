// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../constants/colors.dart';
import '../../../controllers/auth/forget_pass_controller.dart';
import '../../../controllers/auth/signin_controller.dart';
import '../../../controllers/auth/signup_controller.dart';
import '../forget_pass/forget_pass_view.dart';
import '../signup/signup_view.dart';

class SigninView extends StatefulWidget {
  const SigninView({super.key});

  @override
  State<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  // controllers
  final _signupController = Get.put(SignupController());
  final _signinController = Get.put(SigninController());
  final _forgetPassController = Get.put(ForgetPassController());

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _signinKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
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
            key: _signinKey,
            child: ListView(
              children: [
                SizedBox(height: 50.w),
                _logo(),
                SizedBox(height: 15.w),
                _title(),
                SizedBox(height: 25.w),
                _emailField(),
                SizedBox(height: 15.w),
                _passwordField(),
                SizedBox(height: 15.w),
                _signinButton(),
                SizedBox(height: 15.w),
                _createForgetRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createForgetRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => SignupView());
          },
          child: Text(
            "Create Account",
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

  Widget _signinButton() {
    final controller = Get.find<SigninController>();
    return MaterialButton(
      height: 40.w,
      color: kBaseColor,
      onPressed: () {
        if (_signinKey.currentState!.validate()) {
          controller.handleSignin();
        }
      },
      child: Obx(() {
        return controller.checkingSignin.value
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
                "Sign In",
                style: TextStyle(fontSize: 15.sp, color: whiteColor),
              );
      }),
    );
  }

  Widget _passwordField() {
    return Obx(() {
      final controller = Get.find<SigninController>();
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
          controller.password = value;
        },
        validator: MultiValidator([
          RequiredValidator(errorText: "Password is required"),
          MinLengthValidator(6, errorText: "Password must be at least 6 character long."),
        ]),
      );
    });
  }

  Widget _emailField() {
    final controller = Get.find<SigninController>();
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
        controller.email = value;
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
          "Sign In",
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
