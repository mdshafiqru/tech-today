import 'dart:convert';

import 'package:blog/app/constants/app_string.dart';
import 'package:blog/app/constants/helper_function.dart';
import 'package:blog/app/controllers/dashboard/post_controller.dart';
import 'package:blog/app/models/dashboard/comment_response.dart';
import 'package:blog/app/models/dashboard/reply_response.dart';
import 'package:blog/app/models/response_status.dart';
import 'package:get/get.dart';

import '../../models/dashboard/comment.dart';
import '../../models/dashboard/reply.dart';
import '../../service/comment_service.dart';

class CommentController extends GetxController {
  final _commentService = CommentService();

  var comments = <Comment>[].obs;
  var replies = <Reply>[].obs;

  var gettingComments = false.obs;
  var creatingComment = false.obs;
  var isCommentTyping = false.obs;
  var deletingComment = false.obs;

  // replies
  var gettingReplies = false.obs;
  var creatingReply = false.obs;
  var isReplyTyping = false.obs;
  var deletingReply = false.obs;

  var showReply = false.obs;
  var showReplyEntry = false.obs;
  var selectedCommentIndex = 0.obs;

  String commentText = "";
  String replyText = "";

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

  getReplies(String commentId) async {
    if (!gettingReplies.value) {
      gettingReplies.value = true;

      replies.clear();

      final response = await _commentService.getReplies(commentId);

      if (response.error == null) {
        var replyList = response.data != null ? response.data as List<dynamic> : [];

        for (var item in replyList) {
          replies.add(item);
        }
        gettingReplies.value = false;
      } else if (response.error == UN_AUTHENTICATED) {
        logout();
        gettingReplies.value = false;
      } else {
        gettingReplies.value = false;
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

  Future<bool> createReply(String commentId, int commentIndex) async {
    bool created = false;

    if (!creatingReply.value && replyText.isNotEmpty) {
      creatingReply.value = true;

      var body = jsonEncode({
        "text": replyText.trim(),
        "commentId": commentId,
      });

      final response = await _commentService.createReply(body);

      if (response.error == null) {
        final responseStatus = response.data != null ? response.data as ResponseStatus : ResponseStatus();

        bool success = responseStatus.success ?? false;

        if (success) {
          final replyResponse = responseStatus.data != null ? responseStatus.data as ReplyResponse : ReplyResponse();

          final reply = replyResponse.reply != null ? replyResponse.reply as Reply : Reply();

          final comment = comments[commentIndex];
          comment.replyCount = replyResponse.replyCount ?? 0;
          comments[commentIndex] = comment;

          replies.add(reply);
          created = true;

          creatingReply.value = false;
        } else {
          showError(error: responseStatus.message ?? "");
          creatingReply.value = false;
        }
      } else if (response.error == UN_AUTHENTICATED) {
        logout();
        creatingReply.value = false;
      } else {
        showError(error: response.error ?? "");
        creatingReply.value = false;
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

  deleteReply(String replyId, int replyIndex, int commentIndex) async {
    if (!deletingReply.value) {
      deletingReply.value = true;

      final response = await _commentService.deleteReply(replyId);

      if (response.error == null) {
        final status = response.data != null ? response.data as ResponseStatus : ResponseStatus();

        bool success = status.success ?? false;

        if (success) {
          final comment = comments[commentIndex];
          int count = comment.replyCount ?? 0;
          comment.replyCount = count != 0 ? count - 1 : count;

          comments[commentIndex] = comment;

          replies.removeAt(replyIndex);
          deletingReply.value = false;
          //
        } else {
          showError(error: status.message ?? "");
          deletingReply.value = false;
        }
      } else if (response.error == UN_AUTHENTICATED) {
        logout();
        deletingReply.value = false;
      } else {
        showError(error: response.error ?? "");
        deletingReply.value = false;
      }
    }
  }
}
