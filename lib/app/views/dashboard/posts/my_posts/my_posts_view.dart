import 'package:blog/app/controllers/dashboard/post_controller.dart';
import 'package:blog/app/views/dashboard/home/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../../constants/colors.dart';
import '../../../../models/dashboard/post.dart';

class MyPostView extends StatelessWidget {
  const MyPostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My All Posts"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Obx(() {
          var posts = Get.find<PostController>().myPosts;
          bool loading = Get.find<PostController>().gettingMyPosts.value;

          return loading
              ? Center(
                  child: SizedBox(
                  height: 30.w,
                  width: 30.w,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballSpinFadeLoader,
                    colors: const [kBaseColor],
                    strokeWidth: 5.w,
                  ),
                ))
              : posts.isEmpty
                  ? Center(
                      child: Text("You have not posts yet!", style: TextStyle(fontSize: 14.sp)),
                    )
                  : ListView(
                      children: List.generate(posts.length, (index) {
                        Post post = posts[index];
                        return PostCard(
                          post: post,
                          index: index,
                          deletedPosts: false,
                          savedPosts: false,
                        );
                      }),
                    );
        }),
      ),
    );
  }
}
