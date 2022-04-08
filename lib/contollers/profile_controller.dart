import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/models/post_model.dart';
import 'package:flutter_instagram_clone/models/user_model.dart';
import 'package:flutter_instagram_clone/services/data_service.dart';
import 'package:flutter_instagram_clone/services/file_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  int axisCount = 1;
  int countPosts = 0;
  bool isLoading = false;
  File? _image;
  User? user;
  List<Post> items = [];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _apiLoadUser();
    _apiLoadPost();
  }

  _imageFromCamera() async{
    XFile? image = await ImagePicker().pickImage(source: ImageSource.camera,imageQuality: 50);

    _image = File(image!.path);
    update();

    _apiChangePhoto();
  }

  _imageFromGallery() async{
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 50);

    _image = File(image!.path);
    update();

    _apiChangePhoto();
  }

  void showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  onTap: (){
                    _imageFromGallery();
                    Navigator.pop(context);
                  },
                  leading: Icon(Icons.add_to_photos),
                  title: Text("Pick Photo"),
                ),
                ListTile(
                  onTap: (){
                    _imageFromCamera();
                    Navigator.pop(context);
                  },
                  leading: Icon(Icons.camera_alt),
                  title: Text("Take Photo"),
                ),
              ],
            ),
          );
        }
    );
  }

  // for load user
  void _apiLoadUser() async{
    isLoading = true;
    update();

    DataService.loadUser().then((value) => _showUserInfo(value));
  }

  void _showUserInfo(User user) {
    this.user = user;
    isLoading = false;
    update();
  }

  // for edit user
  void _apiChangePhoto(){
    if(_image == null) return;

    isLoading =true;
    update();

    FileService.uploadImage(_image!, FileService.folderUserImg).then((value) => _apiUpdateUser(value));
  }

  void _apiUpdateUser(String imageUrl) async{
    isLoading = false;
    user!.imageUrl = imageUrl;
    update();

    await DataService.updateUser(user!);
  }

  // for load post
  void _apiLoadPost() {
    DataService.loadPosts().then((posts) => {
      _resLoadPost(posts),
    });
  }

  void _resLoadPost(List<Post> posts) {
    items = posts;
    countPosts = posts.length;
    update();
  }

  // void deletePost(Post post) async {
  //   bool result = await Utils.dialogCommon(context, "Instagram Clone", "Do you want to remove a post?", false);
  //
  //   if(result) {
  //     setState(() {
  //       isLoading = true;
  //     });
  //   }
  //
  //   DataService.removePost(post);
  //
  //   setState(() {
  //     isLoading = false;
  //   });
  //
  //   _apiLoadPost();
  // }

  void swapOneCategory() {
    axisCount = 1;
    update();
  }

  void swapTwoCategory() {
    axisCount = 2;
    update();
  }
}