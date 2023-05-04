// ignore_for_file: prefer_const_constructors

import 'package:blog/app/views/dashboard/admin_dashboard/admin_dashboard.dart';
import 'package:blog/app/views/dashboard/dashboard/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../constants/app_string.dart';
import '../auth/signin/signin_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  checkLogin() {
    Future.delayed(Duration(milliseconds: 100)).then((value) {
      bool isLoggedIn = GetStorage().read(IS_LOGGED_IN) ?? false;

      if (isLoggedIn) {
        Get.offAll(() => DashboardView());
      } else {
        Get.offAll(() => SigninView());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
