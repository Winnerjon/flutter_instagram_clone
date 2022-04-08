import 'package:flutter_instagram_clone/models/post_model.dart';
import 'package:flutter_instagram_clone/services/data_service.dart';
import 'package:get/get.dart';

class LikesController extends GetxController {
  List<Post> items = [];
  bool isLoading = false;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _apiLoadLike();
  }

  void _apiLoadLike() async{
    isLoading = true;
    update();

    DataService.loadLike().then((posts) => {
      _resLoadLikes(posts),
    });
  }

  void _resLoadLikes(List<Post> posts) {
    items = posts;
    isLoading = false;
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

  void _apiUnPostLike(Post post) async {
    isLoading = true;
    update();

    await DataService.likePost(post, false);
    isLoading = false;
    post.isLiked = false;
    update();

    _apiLoadLike();
  }

  void updateLike(Post post) {
    if(post.isLiked) {
      _apiUnPostLike(post);
    }else{
      _apiPostLike(post);
    }
  }
}