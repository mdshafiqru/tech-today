// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../../constants/api_string.dart';
import '../../../../constants/colors.dart';
import '../../../../controllers/dashboard/home_controller.dart';
import '../../../../controllers/dashboard/post_controller.dart';
import '../../../../models/dashboard/post.dart';

class EditPostView extends StatefulWidget {
  const EditPostView({super.key, required this.post});

  final Post post;

  @override
  State<EditPostView> createState() => _EditPostViewState();
}

class _EditPostViewState extends State<EditPostView> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _postEditKey = GlobalKey<FormState>();

  setValues() {
    final controller = Get.find<PostController>();
    _titleController.text = widget.post.title ?? "";
    _descriptionController.text = widget.post.description ?? "";
    controller.editTitle = widget.post.title ?? "";
    controller.editDescription = widget.post.description ?? "";
    controller.editCategoryId = widget.post.category!.id ?? "";
    controller.selectedCategory.value = widget.post.category!.name ?? "";

    // thumbnail
    controller.networkImage.value = widget.post.category!.name != null ? true : false;
    controller.thumbnailPath.value = widget.post.thumbnail ?? "";
    controller.deletedThumbnail = "";

    // other images
    controller.networkImages.clear();
    controller.networkImages.addAll(widget.post.images ?? []);
    controller.deletedImages = [];
  }

  @override
  void initState() {
    setValues();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Post"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.w),
          child: Form(
            key: _postEditKey,
            child: ListView(
              children: [
                SizedBox(height: 20.w),
                _category(),
                SizedBox(height: 15.w),
                _titleField(),
                SizedBox(height: 15.w),
                _descriptionField(),
                SizedBox(height: 15.w),
                _selectThumbnail(),
                SizedBox(height: 15.w),
                _selectOtherImages(),
                SizedBox(height: 15.w),
                _updateButton(),
                SizedBox(height: 20.w),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _updateButton() {
    final controller = Get.find<PostController>();
    return MaterialButton(
      height: 40.w,
      color: kBaseColor,
      onPressed: () {
        if (_postEditKey.currentState!.validate()) {
          _postEditKey.currentState!.save();
          controller.editPost(widget.post.id ?? "");
        }
      },
      child: Obx(() {
        return controller.updatingPost.value
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
                style: TextStyle(fontSize: 15.sp, color: whiteColor),
              );
      }),
    );
  }

  Widget _selectThumbnail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.r),
              ),
              color: whiteBackgroundColor,
              onPressed: () {
                Get.find<PostController>().selectThumbnail(imageUrl: widget.post.thumbnail ?? "");
              },
              child: Row(
                children: [
                  Icon(Icons.image),
                  SizedBox(width: 5.w),
                  Text("Select Post Thumbnail"),
                ],
              ),
            ),
          ],
        ),
        Obx(() {
          final controller = Get.find<PostController>();
          String thumbnailPath = controller.thumbnailPath.value;

          return thumbnailPath.isEmpty
              ? Container()
              : SizedBox(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      controller.networkImage.value ? Image.network(imageBaseUrl + thumbnailPath) : Image.file(File(thumbnailPath)),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          onPressed: () {
                            bool networkImage = controller.networkImage.value;
                            if (networkImage) {
                              controller.deletedThumbnail = widget.post.thumbnail ?? "";
                            }
                            controller.thumbnailPath.value = "";
                          },
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
        }),
      ],
    );
  }

  Widget _selectOtherImages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.r),
              ),
              color: whiteBackgroundColor,
              onPressed: () {
                Get.find<PostController>().selectOtherImages();
              },
              child: Row(
                children: [
                  Icon(Icons.image),
                  SizedBox(width: 5.w),
                  Text("Select Other Images"),
                ],
              ),
            ),
          ],
        ),
        Obx(() {
          final controller = Get.find<PostController>();
          final images = controller.networkImages;

          return images.isEmpty
              ? Container()
              : Wrap(
                  children: List.generate(images.length, (index) {
                    String path = images[index];
                    return Padding(
                      padding: EdgeInsets.all(5.w),
                      child: SizedBox(
                        width: 150.w,
                        child: Stack(
                          children: [
                            Image.network(imageBaseUrl + path),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: IconButton(
                                onPressed: () {
                                  controller.deletedImages.add(path);
                                  controller.networkImages.removeAt(index);
                                },
                                icon: Icon(Icons.delete, color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                );
        }),
        Obx(() {
          final imagePaths = Get.find<PostController>().imagePaths;

          return imagePaths.isEmpty
              ? Container()
              : Wrap(
                  children: List.generate(imagePaths.length, (index) {
                    String path = imagePaths[index];
                    return Padding(
                      padding: EdgeInsets.all(5.w),
                      child: SizedBox(
                        width: 150.w,
                        child: Stack(
                          children: [
                            Image.file(File(path)),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: IconButton(
                                onPressed: () {
                                  Get.find<PostController>().imagePaths.removeAt(index);
                                },
                                icon: Icon(Icons.delete, color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                );
        }),
      ],
    );
  }

  Widget _titleField() {
    return TextFormField(
      style: TextStyle(fontSize: 14.sp),
      decoration: InputDecoration(
        labelText: "Title",
        border: OutlineInputBorder(borderSide: BorderSide(color: kBaseColor)),
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 13.w),
      ),
      controller: _titleController,
      onSaved: (value) {
        Get.find<PostController>().editTitle = value ?? "";
      },
      validator: MultiValidator([
        RequiredValidator(errorText: "Title is required"),
        MinLengthValidator(3, errorText: "Minimum 3 character required"),
      ]),
    );
  }

  Widget _descriptionField() {
    return TextFormField(
      style: TextStyle(fontSize: 14.sp),
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: "Description",
        border: OutlineInputBorder(borderSide: BorderSide(color: kBaseColor)),
        contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 13.w),
      ),
      maxLines: 8,
      controller: _descriptionController,
      onSaved: (value) {
        Get.find<PostController>().editDescription = value ?? "";
      },
      validator: MultiValidator([
        RequiredValidator(errorText: "Description is required"),
        MinLengthValidator(3, errorText: "Minimum 3 character required"),
      ]),
    );
  }

  Widget _category() {
    return Obx(() {
      var categories = Get.find<HomeController>().categories;

      var categoryNames = ["All Category"];

      for (var item in categories) {
        categoryNames.add(item.name ?? "");
      }

      return DropdownSearch(
        showSearchBox: true,
        items: categoryNames,
        selectedItem: Get.find<PostController>().selectedCategory.value,
        onChanged: (name) {
          String selectedId = "";

          for (var item in categories) {
            if (item.name == name) {
              selectedId = item.id ?? "";
              break;
            }
          }
          Get.find<PostController>().editCategoryId = selectedId;
        },
      );
    });
  }
}
