import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/contollers/upload_controller.dart';
import 'package:flutter_instagram_clone/views/appbar_widget.dart';
import 'package:get/get.dart';

class UploadPage extends StatelessWidget {
  static const String id = "/upload_page";

  const UploadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UploadController>(
      builder: (uploadController) {
        return Scaffold(
          appBar: appBar(
              "Upload",
              Icon(
                Icons.post_add_outlined,
                color: Colors.black,
                size: 27,
              ),
              uploadController.uploadNewPost),
          body: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    uploadController.showPicker(context);
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey.shade300,
                    child: uploadController.image != null
                        ? Stack(
                            children: [
                              Image.file(
                                  uploadController.image!,
                                height: double.infinity,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),

                              Container(
                                height: double.infinity,
                                width: double.infinity,
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  onPressed: uploadController.cancelPhoto,
                                  icon: Icon(Icons.cancel_outlined, color: Colors.white,),
                                ),
                              )
                            ],
                          )
                        : Center(
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.grey,
                              size: 60,
                            ),
                          ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    controller: uploadController.captionController,
                    maxLength: null,
                    decoration: InputDecoration(
                      hintText: "Caption",
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
