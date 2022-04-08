import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/models/user_model.dart';
import 'package:flutter_instagram_clone/pages/user_profile_page.dart';
import 'package:flutter_instagram_clone/services/data_service.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  TextEditingController controller = TextEditingController();
  List<User> items = [];
  bool isLoading = false;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _apiSerachUser("");
  }

  void _apiSerachUser(String keyword) {
    isLoading = true;
    update();

    DataService.searchUsers(keyword).then((users) => _resSearchUser(users));
  }

  void _resSearchUser(List<User> users) {
    isLoading = false;
    items = users;
    update();
  }

  void _apiFollowUser(User someone) async {
    isLoading = true;
    update();

    await DataService.followUser(someone);
    someone.followed = true;
    isLoading = false;
    update();

    DataService.storePostToMyFeed(someone);
  }

  void _apiUnFollowUser(User someone) async {
    isLoading = true;
    update();

    await DataService.unFollowUser( someone);
    someone.followed = false;
    isLoading = false;
    update();

    DataService.removePostMyFeed(someone);
  }

  void updateFollow(User user) {
    if(user.followed) {
      _apiUnFollowUser(user);
    }else{
      _apiFollowUser(user);
    }
  }

  void getUserProfilePage(User user) {
    Get.off(MaterialPageRoute(builder: (_) =>UserProfilePage(user: user,)));
  }
}