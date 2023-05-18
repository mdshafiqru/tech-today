// ignore_for_file: prefer_const_constructors

import 'package:blog/app/constants/api_string.dart';
import 'package:blog/app/controllers/dashboard/comment_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../constants/helper_function.dart';
import '../../../../models/auth/user.dart';
import '../../../../models/dashboard/comment.dart';
import '../../../../models/dashboard/reply.dart';

class ReplyCard extends StatelessWidget {
  const ReplyCard({
    super.key,
    required this.reply,
    required this.replyIndex,
    required this.commentIndex,
  });

  final Reply reply;
  final int commentIndex, replyIndex;

  @override
  Widget build(BuildContext context) {
    User user = reply.user != null ? reply.user as User : User();

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
                    : Icon(Icons.person, color: Colors.blue, size: 35.sp),
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
                        reply.text ?? "",
                        style: TextStyle(fontSize: 13.sp),
                      ),
                      SizedBox(height: 5.w),
                      Row(
                        children: [
                          Text(getTimeAgo(reply.createdAt ?? "")),
                          SizedBox(width: 10.w),
                          Text("|"),
                          SizedBox(width: 10.w),
                          if (user.id == userId)
                            GestureDetector(
                              onTap: () {
                                Get.find<CommentController>().deleteReply(reply.id ?? "", replyIndex, commentIndex);
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
