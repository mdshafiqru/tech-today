// ignore_for_file: prefer_const_constructors

import 'package:blog/app/constants/api_string.dart';
import 'package:blog/app/controllers/dashboard/comment_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constants/helper_function.dart';
import '../../../../models/auth/user.dart';
import '../../../../models/dashboard/comment.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({
    super.key,
    required this.comment,
    required this.commentIndex,
    required this.postIndex,
  });

  final Comment comment;
  final int commentIndex, postIndex;

  @override
  Widget build(BuildContext context) {
    User user = comment.user != null ? comment.user as User : User();

    String avatar = user.avatar ?? "";
    String avatarUrl = imageBaseUrl + avatar;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.w),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                avatar.isNotEmpty
                    ? Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          image: DecorationImage(
                            image: NetworkImage(avatarUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Icon(Icons.person, size: 35.sp),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name ?? "",
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        comment.text ?? "",
                        style: TextStyle(fontSize: 13.sp),
                      ),
                      SizedBox(height: 5.w),
                      Row(
                        children: [
                          Text(getTimeAgo(comment.createdAt ?? "")),
                          SizedBox(width: 10.w),
                          Text("|"),
                          SizedBox(width: 10.w),
                          Text(
                            "${comment.replyCount ?? 0} replies",
                            style: TextStyle(fontSize: 11.sp),
                          ),
                          SizedBox(width: 10.w),
                          Text("|"),
                          SizedBox(width: 10.w),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              "reply",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          if (user.id == userId) Text("|"),
                          SizedBox(width: 10.w),
                          if (user.id == userId)
                            GestureDetector(
                              onTap: () {
                                Get.find<CommentController>().deleteComment(comment.id ?? "", commentIndex, postIndex);
                              },
                              child: Text(
                                "delete",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 5.w),
            Divider(),
          ],
        ),
      ),
    );
  }
}
