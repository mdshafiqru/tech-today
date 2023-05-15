import 'package:blog/app/constants/helper_function.dart';
import 'package:blog/app/views/dashboard/posts/deleted_posts/deleted_posts_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Profile page"),
              MaterialButton(
                onPressed: () {
                  Get.to(() => DeletedPostView());
                },
                child: Text("Deleted Posts"),
              ),
              MaterialButton(
                onPressed: () {
                  logout();
                },
                child: Text("Logout"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
