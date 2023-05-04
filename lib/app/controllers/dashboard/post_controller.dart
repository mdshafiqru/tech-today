import 'package:blog/app/models/response_status.dart';
import 'package:get/get.dart';

import '../../constants/app_string.dart';
import '../../constants/helper_function.dart';
import '../../models/dashboard/like.dart';
import '../../models/dashboard/post.dart';
import '../../service/post_service.dart';

class PostController extends GetxController {
  final _postService = PostService();
  var allPosts = <Post>[].obs;

  var loadingData = false.obs;
  var likeUnlikeLoading = false.obs;

  getAllPosts() async {
    loadingData.value = true;
    var response = await _postService.getAllPosts();

    if (response.error == null) {
      var postList = response.data != null ? response.data as List<dynamic> : [];

      allPosts.clear();
      for (var item in postList) {
        allPosts.add(item);
      }
      loadingData.value = false;
    } else if (response.error == UN_AUTHENTICATED) {
      logout();
      loadingData.value = false;
    }
  }

  likeUnlike(String postId, int index) async {
    if (!likeUnlikeLoading.value) {
      likeUnlikeLoading.value = true;

      final response = await _postService.likeUnlike(postId);

      if (response.error == null) {
        //

        final responseStatus = response.data != null ? response.data as ResponseStatus : ResponseStatus();

        bool success = responseStatus.success ?? false;

        if (success) {
          //

          Like like = responseStatus.data != null ? responseStatus.data as Like : Like();

          final post = allPosts[index];
          post.isLiked = like.isLiked ?? false;
          post.likeCount = like.likeCount ?? 0;

          allPosts[index] = post;
        } else {
          showError(error: responseStatus.message ?? "");
        }

        likeUnlikeLoading.value = false;
      } else if (response.error == UN_AUTHENTICATED) {
        likeUnlikeLoading.value = false;
        logout();
      } else {
        likeUnlikeLoading.value = false;
        showError(error: response.error ?? "");
      }
    }
  }

  @override
  void onInit() {
    getAllPosts();
    super.onInit();
  }
}
