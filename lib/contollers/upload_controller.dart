import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/models/post_model.dart';
import 'package:flutter_instagram_clone/pages/main_page.dart';
import 'package:flutter_instagram_clone/services/data_service.dart';
import 'package:flutter_instagram_clone/services/file_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UploadController extends GetxController {
  bool isLoading = false;
  File? image;
  TextEditingController captionController = TextEditingController();

  _imageFromCamera() async {
    XFile? imagePhoto = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);

    image = File(imagePhoto!.path);
    update();
  }

  _imageFromGallery() async {
    XFile? imagePhoto = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);

    image = File(imagePhoto!.path);
    update();
  }

  void showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  onTap: () {
                    _imageFromGallery();
                    Navigator.pop(context);
                  },
                  leading: Icon(Icons.add_to_photos),
                  title: Text("Pick Photo"),
                ),
                ListTile(
                  onTap: () {
                    _imageFromCamera();
                    Navigator.pop(context);
                  },
                  leading: Icon(Icons.camera_alt),
                  title: Text("Take Photo"),
                ),
              ],
            ),
          );
        });
  }

  void cancelPhoto() {
    image = null;
    update();
  }

  // for post
  uploadNewPost() {
    String caption = captionController.text.trim().toString();
    if (image == null || caption.isEmpty) return;

    //Send post to Server
    _apiPostImage();
  }

  void _apiPostImage() {
    isLoading = true;
    update();

    FileService.uploadImage(image!, FileService.folderPostImg)
        .then((imageUrl) => {
              _resPostImage(imageUrl),
            });
  }

  _resPostImage(String imageUrl) async {
    String caption = captionController.text.trim().toString();
    Post post = Post(postImage: imageUrl, caption: caption);

    _apiStorePost(post);
  }

  void _apiStorePost(Post post) async {
    // Post to posts folder
    Post posted = await DataService.storePost(post);

    // Post to feeds folder
    DataService.storeFeed(post).then((value) => {
          _moveToFeed(),
        });
  }

  void _moveToFeed() {
    isLoading = false;
    update();

    Get.to(MainPage.id);
  }
}
