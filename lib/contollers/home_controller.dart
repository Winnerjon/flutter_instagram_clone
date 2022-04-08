import 'package:flutter_instagram_clone/models/post_model.dart';
import 'package:flutter_instagram_clone/services/data_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  bool isLoading = false;
  List<Post> items = [];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    apiLoadFeeds();
  }

  void apiLoadFeeds() async{
    isLoading =true;
    update();

    DataService.loadFeeds().then((posts) => {
      _resLoadFeeds(posts),
    });
  }

  _resLoadFeeds(List<Post> posts) {
      isLoading = false;
      items = posts;
      update();
  }

  void _apiPostLike(Post post) async {
    isLoading = true;
    update();

    await DataService.likePost(post, true);

      isLoading = false;
      post.isLiked = true;
      update();
  }

  void _apiPostUnLike(Post post) async {
      isLoading = true;
      update();

    await DataService.likePost(post, false);

      isLoading = false;
      post.isLiked = true;
      update();
  }

  void updateLike(Post post) {
    if(post.isLiked) {
      _apiPostUnLike(post);
    }else{
      _apiPostLike(post);
    }
  }

  // void deletePost(Post post) async {
  //   bool result = await Utils.dialogCommon(context, "Instagram Clone", "Do you want to remove a post?", false);
  //
  //   if(result) {
  //       isLoading = true;
  //       update();
  //   }
  //
  //   DataService.removePost(post);
  //
  //   isLoading = false;
  //   update();
  //
  //   apiLoadFeeds();
  // }
}