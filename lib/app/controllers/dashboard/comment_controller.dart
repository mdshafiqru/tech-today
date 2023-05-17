import 'dart:convert';

import 'package:blog/app/constants/app_string.dart';
import 'package:blog/app/constants/helper_function.dart';
import 'package:blog/app/controllers/dashboard/post_controller.dart';
import 'package:blog/app/models/dashboard/comment_response.dart';
import 'package:blog/app/models/response_status.dart';
import 'package:get/get.dart';

import '../../models/dashboard/comment.dart';
import '../../service/comment_service.dart';

class CommentController extends GetxController {
  final _commentService = CommentService();

  var comments = <Comment>[].obs;

  var gettingComments = false.obs;
  var creatingComment = false.obs;
  var isCommentTyping = false.obs;
  var deletingComment = false.obs;

  String commentText = "";

  getComments(String postId) async {
    if (!gettingComments.value) {
      gettingComments.value = true;

      comments.clear();

      final response = await _commentService.getComments(postId);

      if (response.error == null) {
        var commentList = response.data != null ? response.data as List<dynamic> : [];

        for (var item in commentList) {
          comments.add(item);
        }
        gettingComments.value = false;
      } else if (response.error == UN_AUTHENTICATED) {
        logout();
        gettingComments.value = false;
      } else {
        gettingComments.value = false;
      }
    }
  }

  Future<bool> createComment(String postId, int postIndex) async {
    bool created = false;

    if (!creatingComment.value && commentText.isNotEmpty) {
      creatingComment.value = true;

      var body = jsonEncode({
        "text": commentText.trim(),
        "postId": postId,
      });

      final response = await _commentService.createComment(body);

      if (response.error == null) {
        final responseStatus = response.data != null ? response.data as ResponseStatus : ResponseStatus();

        bool success = responseStatus.success ?? false;

        if (success) {
          final commentResponse = responseStatus.data != null ? responseStatus.data as CommentResponse : CommentResponse();

          final comment = commentResponse.comment != null ? commentResponse.comment as Comment : Comment();

          final post = Get.find<PostController>().allPosts[postIndex];
          post.commentCount = commentResponse.commentCount ?? 0;

          Get.find<PostController>().allPosts[postIndex] = post;

          comments.add(comment);
          created = true;

          creatingComment.value = false;
        } else {
          showError(error: responseStatus.message ?? "");
          creatingComment.value = false;
        }
      } else if (response.error == UN_AUTHENTICATED) {
        logout();
        creatingComment.value = false;
      } else {
        showError(error: response.error ?? "");
        creatingComment.value = false;
      }
    }
    return created;
  }

  deleteComment(String commentId, int commentIndex, int postIndex) async {
    if (!deletingComment.value) {
      deletingComment.value = true;

      final response = await _commentService.deleteComment(commentId);

      if (response.error == null) {
        final status = response.data != null ? response.data as ResponseStatus : ResponseStatus();

        bool success = status.success ?? false;

        if (success) {
          final post = Get.find<PostController>().allPosts[postIndex];
          int count = post.commentCount ?? 0;
          post.commentCount = count != 0 ? count - 1 : count;

          Get.find<PostController>().allPosts[postIndex] = post;

          comments.removeAt(commentIndex);
          deletingComment.value = false;
          //
        } else {
          showError(error: status.message ?? "");
          deletingComment.value = false;
        }
      } else if (response.error == UN_AUTHENTICATED) {
        logout();
        deletingComment.value = false;
      } else {
        showError(error: response.error ?? "");
        deletingComment.value = false;
      }
    }
  }
}
