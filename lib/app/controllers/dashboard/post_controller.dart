import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/app_string.dart';
import '../../constants/helper_function.dart';
import '../../models/dashboard/like.dart';
import '../../models/dashboard/post.dart';
import '../../models/response_status.dart';
import '../../service/post_service.dart';

class PostController extends GetxController {
  final _postService = PostService();
  final _imagePicker = ImagePicker();
  var allPosts = <Post>[].obs;

  var loadingData = false.obs;
  var likeUnlikeLoading = false.obs;
  var creatingPost = false.obs;
  var updatingPost = false.obs;

  var networkImage = false.obs;

  String selectedCategoryId = "";
  var selectedCategory = "All Category".obs;
  String title = "";
  String description = "";

  String editCategoryId = "";
  String editTitle = "";
  String editDescription = "";

  var thumbnailPath = "".obs;
  var imagePaths = <String>[].obs;
  var networkImages = <String>[].obs;
  List<String> deletedImages = <String>[];

  var deletedThumbnail = "";

  editPost(String postId) async {
    if (!updatingPost.value) {
      updatingPost.value = true;

      if (editCategoryId.isNotEmpty) {
        if (thumbnailPath.isNotEmpty) {
          //

          final content = {
            "title": editTitle,
            "description": editDescription,
            "postId": postId,
            "categoryId": editCategoryId,
            "deletedThumbnail": deletedThumbnail,
          };

          if (!networkImage.value) {
            imagePaths.insert(0, thumbnailPath.value);
          }

          final response = await _postService.editPost(content, imagePaths, deletedImages);

          if (response.error == null) {
            final responseStatus = response.data != null ? response.data as ResponseStatus : ResponseStatus();

            bool success = responseStatus.success ?? false;

            if (success) {
              editTitle = "";
              editDescription = "";
              editCategoryId = "";
              thumbnailPath.value = "";
              deletedThumbnail = "";
              imagePaths.clear();
              deletedImages.clear();
              getAllPosts();
              Get.back();
              Get.back();
              updatingPost.value = false;
            } else {
              updatingPost.value = false;
              showError(error: responseStatus.message ?? "");
            }
          } else if (response.error == UN_AUTHENTICATED) {
            updatingPost.value = false;
            logout();
          } else {
            updatingPost.value = false;
            showError(error: response.error ?? "");
          }
        } else {
          updatingPost.value = false;
          showError(title: "Thumbnail", error: "Select a thumbnail image first");
        }
      } else {
        updatingPost.value = false;
        showError(title: "Category", error: "Select a post category first");
      }
    }
  }

  createPost() async {
    if (!creatingPost.value) {
      creatingPost.value = true;

      if (selectedCategoryId.isNotEmpty) {
        if (thumbnailPath.isNotEmpty) {
          //

          final content = {
            "title": title,
            "description": description,
            "categoryId": selectedCategoryId,
          };

          imagePaths.insert(0, thumbnailPath.value);

          final response = await _postService.createPost(content, imagePaths);

          if (response.error == null) {
            final responseStatus = response.data != null ? response.data as ResponseStatus : ResponseStatus();

            bool success = responseStatus.success ?? false;

            if (success) {
              title = "";
              description = "";
              selectedCategoryId = "";
              thumbnailPath.value = "";
              imagePaths.clear();
              getAllPosts();
              Get.back();
              creatingPost.value = false;
            } else {
              creatingPost.value = false;
              showError(error: responseStatus.message ?? "");
            }
          } else if (response.error == UN_AUTHENTICATED) {
            creatingPost.value = false;
            logout();
          } else {
            creatingPost.value = false;
            showError(error: response.error ?? "");
          }
        } else {
          creatingPost.value = false;
          showError(title: "Thumbnail", error: "Select a thumbnail image first");
        }
      } else {
        creatingPost.value = false;
        showError(title: "Category", error: "Select a post category first");
      }
    }
  }

  selectThumbnail({String? imageUrl}) async {
    var pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (networkImage.value) {
        deletedThumbnail = imageUrl ?? "";
        networkImage.value = false;
      }
      thumbnailPath.value = pickedFile.path;
    } else {
      Get.snackbar(
        "Not selected",
        "No image selected.",
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  selectOtherImages() async {
    final files = await _imagePicker.pickMultiImage();

    for (var item in files) {
      imagePaths.add(item.path);
    }
  }

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
