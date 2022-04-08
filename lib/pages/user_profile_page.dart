import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/models/post_model.dart';
import 'package:flutter_instagram_clone/models/user_model.dart';
import 'package:flutter_instagram_clone/services/data_service.dart';
import 'package:flutter_instagram_clone/views/appbar_widget.dart';

class UserProfilePage extends StatefulWidget {
  static const String id = "/user_profile_page";
  final User? user;

  const UserProfilePage({Key? key,this.user}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  int axisCount = 1;
  int countPosts = 0;
  bool isLoading = false;
  List<Post> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiLoadPost();
  }

  // for load post
  void _apiLoadPost() {
    DataService.loadPosts().then((posts) => {
      _resLoadPost(posts),
    });
  }

  void _resLoadPost(List<Post> posts) {
    setState(() {
      items = posts;
      countPosts = posts.length;
    });
  }

  void _apiFollowUser(User someone) async {
    setState(() {
      isLoading = true;
    });

    await DataService.followUser(someone);
    if(mounted) {
      setState(() {
        someone.followed = true;
        isLoading = false;
      });
    }

    DataService.storePostToMyFeed(someone);
  }

  void _apiUnFollowUser(User someone) async {
    setState(() {
      isLoading = true;
    });

    await DataService.unFollowUser( someone);
    if(mounted) {
      setState(() {
        someone.followed = false;
        isLoading = false;
      });
    }

    DataService.removePostMyFeed(someone);
  }

  void updateFollow(User user) {
    if(user.followed) {
      _apiUnFollowUser(user);
    }else{
      _apiFollowUser(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("Profile", null, null),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// #profile image
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.12,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.purple,
                    child: Badge(
                      padding: EdgeInsets.all(0),
                      position: BadgePosition.bottomEnd(bottom: 3, end: 0),
                      badgeColor: Colors.deepPurple,
                      child: Container(
                        height: 96,
                        width: 96,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.white, width: 2)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(75),
                          child:  widget.user?.imageUrl == null || widget.user!.imageUrl!.isEmpty ? const Image(
                            image: AssetImage("assets/images/profile.png"),
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ) : Image(
                            image: NetworkImage(widget.user!.imageUrl!),
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 13,
                ),

                /// #name
                Text(
                  widget.user == null ? "" : widget.user!.fullName.toUpperCase(),
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),

                /// #email
                Text(
                  widget.user == null ? "" : widget.user!.email,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w300),
                ),

                /// #statistics
                Container(
                  height: 90,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      /// #posts
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                countPosts.toString(),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Posts",
                                style: TextStyle(color: Colors.grey, fontSize: 16),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 40,
                        color: Colors.grey.shade300,
                      ),

                      /// #followers
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.user == null ? "0" : widget.user!.followersCount.toString(),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Followers",
                                style: TextStyle(color: Colors.grey, fontSize: 16),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 40,
                        color: Colors.grey.shade300,
                      ),

                      /// #following
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.user == null ? "0" : widget.user!.followingCount.toString(),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Following",
                                style: TextStyle(color: Colors.grey, fontSize: 16),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: MaterialButton(
                    height: 40,
                    minWidth: MediaQuery.of(context).size.width,
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1.5,
                      ),
                    ),
                    child: Text(widget.user!.followed ? "Following" : "Follow",style: TextStyle(fontSize: 18),),
                    onPressed: (){
                      updateFollow(widget.user!);
                    },
                  ),
                ),

                //listgrid
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                axisCount = 1;
                              });
                            },
                            icon: Icon(Icons.list_alt),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                axisCount = 2;
                              });
                            },
                            icon: Icon(Icons.grid_view),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //#myposts
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: axisCount),
                    itemCount: items.length,
                    itemBuilder: (ctx, index) {
                      return _itemOfPost(index);
                    },
                  ),
                ),
              ],
            ),
          ),

          if(isLoading) const Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _itemOfPost(int index) {
    return Container(
      margin: EdgeInsets.all(5),
      child: Column(
        children: [
          Expanded(
            child: CachedNetworkImage(
              width: MediaQuery.of(context).size.width,
              imageUrl: items[index].postImage,
              placeholder: (context, url) => Container(color: Colors.grey,),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            items[index].caption,
            style: TextStyle(color: Colors.black87.withOpacity(0.7)),
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
