// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../constants/api_string.dart';
import '../../../constants/app_string.dart';
import '../../../constants/colors.dart';
import '../../../constants/helper_function.dart';
import '../../../controllers/dashboard/profile_controller.dart';
import '../posts/deleted_posts/deleted_posts_view.dart';
import '../posts/my_posts/my_posts_view.dart';
import '../posts/saved_posts/saved_posts_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _passwordKey = GlobalKey<FormState>();

  final _currentPassController = TextEditingController();
  final _newPassController = TextEditingController();

  @override
  void dispose() {
    _currentPassController.dispose();
    _newPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
          child: ListView(
            children: [
              SizedBox(height: 10.w),
              _profileImage(),
              SizedBox(height: 10.w),
              _infoCard(),
              SizedBox(height: 5.w),
              _changePassword(),
              SizedBox(height: 5.w),
              _myPosts(),
              SizedBox(height: 5.w),
              _savedPost(),
              SizedBox(height: 5.w),
              _deletedPosts(),
              SizedBox(height: 5.w),
              _logout(),
              SizedBox(height: 5.w),
            ],
          ),
        ),
      ),
    );
  }

  Widget _changePassword() {
    return GestureDetector(
      onTap: () {
        final controller = Get.find<ProfileController>();
        controller.showPasswordCard.value = !controller.showPasswordCard.value;
      },
      child: Card(
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(8.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.lock),
                        SizedBox(width: 10.w),
                        Text(
                          "Change Password",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ],
                    ),
                  ),
                  Obx(() {
                    bool showPasswordCard = Get.find<ProfileController>().showPasswordCard.value;
                    return showPasswordCard ? Icon(Icons.arrow_drop_down) : Icon(Icons.arrow_right);
                  }),
                ],
              ),
              SizedBox(height: 5.w),
              Obx(() {
                bool showPasswordCard = Get.find<ProfileController>().showPasswordCard.value;
                return showPasswordCard
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Form(
                          key: _passwordKey,
                          child: Column(
                            children: [
                              SizedBox(height: 5.w),
                              TextFormField(
                                style: TextStyle(fontSize: 13.sp),
                                decoration: InputDecoration(
                                  labelText: "Current Password",
                                ),
                                validator: MultiValidator([
                                  RequiredValidator(errorText: "Current Password is required"),
                                  MinLengthValidator(6, errorText: "Minimum 6 character required"),
                                ]),
                                controller: _currentPassController,
                                onSaved: (value) {
                                  Get.find<ProfileController>().currentPass = value ?? "";
                                },
                              ),
                              SizedBox(height: 10.w),
                              TextFormField(
                                style: TextStyle(fontSize: 13.sp),
                                decoration: InputDecoration(
                                  labelText: "New Password",
                                ),
                                validator: MultiValidator([
                                  RequiredValidator(errorText: "New Password is required"),
                                  MinLengthValidator(6, errorText: "Minimum 6 character required"),
                                ]),
                                controller: _newPassController,
                                onSaved: (value) {
                                  Get.find<ProfileController>().newPass = value ?? "";
                                },
                              ),
                              SizedBox(height: 10.w),
                              MaterialButton(
                                minWidth: double.infinity,
                                color: kBaseColor,
                                onPressed: () async {
                                  if (_passwordKey.currentState!.validate()) {
                                    _passwordKey.currentState!.save();
                                    bool changed = await Get.find<ProfileController>().updatePassword();
                                    if (changed) {
                                      _currentPassController.clear();
                                      _newPassController.clear();
                                    }
                                  }
                                },
                                child: Obx(() {
                                  final controller = Get.find<ProfileController>();
                                  return controller.changingPassword.value
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
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _myPosts() {
    return ProfileItemCard(
      prefixIcon: Icons.notes_rounded,
      text: "My Posts",
      suffixIcon: Icons.arrow_right,
      onTap: () {
        Get.to(() => MyPostView());
      },
    );
  }

  Widget _savedPost() {
    return ProfileItemCard(
      prefixIcon: Icons.notes_rounded,
      text: "Saved Posts",
      suffixIcon: Icons.arrow_right,
      onTap: () {
        Get.to(() => SavedPostView());
      },
    );
  }

  Widget _deletedPosts() {
    return ProfileItemCard(
      prefixIcon: Icons.notes_rounded,
      text: "Deleted Posts",
      suffixIcon: Icons.arrow_right,
      onTap: () {
        Get.to(() => DeletedPostView());
      },
    );
  }

  Widget _logout() {
    return ProfileItemCard(
      prefixIcon: Icons.logout,
      text: "Logout",
      onTap: () {
        logout();
      },
    );
  }

  Widget _infoCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(8.0.w),
        child: Obx(() {
          final user = Get.find<ProfileController>().user.value;
          return SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        user.name ?? "",
                        style: TextStyle(fontSize: 15.sp, color: kBaseColor),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.edit_note,
                        size: 25.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.w),
                Text(
                  "Email: ${user.email ?? "N/A"}",
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(height: 3.w),
                Text(
                  "Phone: ${user.phone ?? "N/A"}",
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(height: 3.w),
                Text(
                  "Total Posts: ${user.postCount ?? "N/A"}",
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(height: 3.w),
                Text(
                  "Joining Date: ${getCustomDate(user.createdAt ?? "") ?? "N/A"}",
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(height: 3.w),
                Text(
                  "Short Bio: ${user.shortBio ?? "N/A"}",
                  style: TextStyle(fontSize: 14.sp),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _profileImage() {
    return Obx(() {
      var user = Get.find<ProfileController>().user.value;
      String avatar = user.avatar ?? "";

      String avatarUrl = imageBaseUrl + avatar;

      return Container(
        width: 80.w,
        height: 80.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
          border: Border.all(width: 0.5.w, color: Colors.grey[400]!),
          image: DecorationImage(
            image: avatar.isNotEmpty ? NetworkImage(avatarUrl) : AssetImage(DEFAULT_USER_IMAGE) as ImageProvider<Object>,
          ),
        ),
      );
    });
  }
}

class ProfileItemCard extends StatelessWidget {
  const ProfileItemCard({
    super.key,
    required this.prefixIcon,
    required this.text,
    this.suffixIcon,
    required this.onTap,
  });

  final IconData prefixIcon;
  final String text;
  final IconData? suffixIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(8.0.w),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(prefixIcon),
                    SizedBox(width: 10.w),
                    Text(text, style: TextStyle(fontSize: 14.sp)),
                  ],
                ),
              ),
              if (suffixIcon != null) Icon(suffixIcon),
            ],
          ),
        ),
      ),
    );
  }
}
