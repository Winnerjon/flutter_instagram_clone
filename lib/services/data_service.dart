import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_instagram_clone/models/post_model.dart';
import 'package:flutter_instagram_clone/models/user_model.dart';
import 'package:flutter_instagram_clone/services/http_service.dart';
import 'package:flutter_instagram_clone/services/shared_preferences.dart';
import 'package:flutter_instagram_clone/services/utils.dart';

class DataService {
  // int
  static final instance = FirebaseFirestore.instance;

  // folder
  static const String userFolder = "users";
  static const String postFolder = "posts";
  static const String feedFolder = "feeds";
  static const String followersFolder = "followers";
  static const String followingFolder = "following";

  // User
  static Future storeUser(User user) async {
    user.uid = (await Prefs.loadUserId())!;
    Map<String, String> params = await Utils.deviceParams();

    user.device_id = params["device_id"]!;
    user.device_type = params["device_type"]!;
    user.device_token = params["device_token"]!;

    instance.collection(userFolder).doc(user.uid).set(user.toJson());
  }

  static Future<User> loadUser() async {
    String uid = (await Prefs.loadUserId())!;
    var value = await instance.collection(userFolder).doc(uid).get();
    User user = User.fromJson(value.data()!);

    var querySnepshot1 = await instance.collection(userFolder).doc(uid).collection(followersFolder).get();
    user.followersCount = querySnepshot1.docs.length;

    var querySnepshot2 = await instance.collection(userFolder).doc(uid).collection(followingFolder).get();
    user.followingCount = querySnepshot2.docs.length;

    return user;
  }

  static Future updateUser(User user) async {
    return instance.collection(userFolder).doc(user.uid).update(user.toJson());
  }

  // Search
  static Future<List<User>> searchUsers(String keyword) async {
    User user = await loadUser();
    List<User> users = [];
    // write request
    var querySnepshot = await instance.collection(userFolder).orderBy(
        "fullName").startAt([keyword]).endAt([keyword + '\uf8ff']).get();

    for (var element in querySnepshot.docs) {
      users.add(User.fromJson(element.data()));
    }
    users.remove(user);

    List<User> following = [];
    var querySnepshot2 = await instance.collection(userFolder).doc(user.uid).collection(followingFolder).get();

    for(var result in querySnepshot2.docs) {
      following.add(User.fromJson(result.data()));
    }

    for(User user in users) {
      if(following.contains(user)){
        user.followed = true;
      }else{
        user.followed = false;
      }
    }

    return users;
  }

  // Post
  static Future<Post> storePost(Post post) async {
    // filled post
    User me = await loadUser();
    post.uid = me.uid;
    post.fullName = me.fullName;
    post.imageUser = me.imageUrl;
    post.createdDate = DateTime.now().toString();

    String postId = instance
        .collection(userFolder)
        .doc(me.uid)
        .collection(postFolder)
        .doc()
        .id;
    post.id = postId;

    await instance.collection(userFolder).doc(me.uid).collection(postFolder).doc(postId).set(post.toJson());
    return post;
  }

  static Future<List<Post>> loadPosts() async {
    List<Post> posts = [];
    String uid = (await Prefs.loadUserId())!;
    var querySnepshot = await instance.collection(userFolder).doc(uid).collection(postFolder).get();

    for (var element in querySnepshot.docs) {
      posts.add(Post.fromJson(element.data()));
    }

    return posts;
  }

  // Feed
  static Future<Post> storeFeed(Post post) async {
    String uid = (await Prefs.loadUserId())!;
    await instance.collection(userFolder).doc(uid)
        .collection(feedFolder)
        .doc(post.id)
        .set(post.toJson());
    return post;
  }

  static Future<List<Post>> loadFeeds() async {
    List<Post> posts = [];
    String uid = (await Prefs.loadUserId())!;
    var querySnepshot = await instance.collection(userFolder)
        .doc(uid)
        .collection(feedFolder)
        .get();

    for (var element in querySnepshot.docs) {
      Post post = Post.fromJson(element.data());
      if (post.uid == uid) post.isMine = true;
      posts.add(post);
    }
    return posts;
  }

  // Like
  static Future<Post> likePost(Post post, bool liked) async {
    String uid = (await Prefs.loadUserId())!;
    post.isLiked = liked;

    await instance.collection(userFolder).doc(uid).collection(feedFolder).doc(
        post.id).update(post.toJson());

    if (uid == post.uid) {
      await instance.collection(userFolder).doc(uid).collection(postFolder).doc(
          post.id).update(post.toJson());
    }

    return post;
  }

  static Future<List<Post>> loadLike() async {
    String uid = (await Prefs.loadUserId())!;
    List<Post> posts = [];

    var querySnapshot = await instance.collection(userFolder).doc(uid)
        .collection(feedFolder).where("isLiked", isEqualTo: true)
        .get();

    for (var element in querySnapshot.docs) {
      Post post = Post.fromJson(element.data());
      if (post.uid == uid) post.isMine == true;
      posts.add(post);
    }

    return posts;
  }

  // Following and follower
  static Future<User> followUser(User someone) async {
    User me = await loadUser();

    // I followed to someone
    await instance.collection(userFolder).doc(me.uid).collection(
        followingFolder).doc(someone.uid).set(someone.toJson());

    // I am in someone's follower
    await instance.collection(userFolder).doc(someone.uid).collection(
        followersFolder).doc(me.uid).set(me.toJson());

    // for notification
    await HttpService.POST(HttpService.paramsCreate(someone.device_token, me.fullName, someone.fullName)).then((value) => {
      print("response notification: ${value.toString()}")
    });

    return someone;
  }

  static Future<User> unFollowUser(User someone) async {
    User me = await loadUser();

    // I followed to someone
    await instance.collection(userFolder).doc(me.uid).collection(
        followingFolder).doc(someone.uid).delete();

    // I am in someone's follower
    await instance.collection(userFolder).doc(someone.uid).collection(
        followersFolder).doc(me.uid).delete();

    return someone;
  }

  static Future storePostToMyFeed(User someone) async {
    // Store someone`s posts to my feed
    List<Post> posts = [];

    var querySnapshot = await instance.collection(userFolder)
        .doc(someone.uid)
        .collection(postFolder)
        .get();

    for (var element in querySnapshot.docs) {
      var post = Post.fromJson(element.data());
      post.isLiked = false;
      posts.add(post);
    }

    for (Post post in posts) {
      storeFeed(post);
    }
  }

  // remove
  static Future removePostMyFeed(User someone) async {
    // Remove someone`s posts from my feed

    List<Post> posts = [];

    var querySnepshot = await instance.collection(userFolder).doc(someone.uid).collection(postFolder).get();

    for (var element in querySnepshot.docs) {
      posts.add(Post.fromJson(element.data()));
    }

    for(Post post in posts) {
      removeFeed(post);
    }
  }

  static Future removeFeed(Post post) async {
    String uid = (await Prefs.loadUserId())!;

    return await instance.collection(userFolder).doc(uid).collection(feedFolder).doc(post.id).delete();
  }

  static Future removePost(Post post) async {
    await removeFeed(post);

    return await instance.collection(userFolder).doc(post.uid).collection(postFolder).doc(post.id).delete();
  }
}