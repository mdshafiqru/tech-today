import 'package:flutter/material.dart';

class EditPostView extends StatefulWidget {
  const EditPostView({super.key});

  @override
  State<EditPostView> createState() => _EditPostViewState();
}

class _EditPostViewState extends State<EditPostView> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _postKey = GlobalKey<FormState>();

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
    );
  }
}
