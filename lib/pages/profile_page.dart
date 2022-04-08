import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/contollers/profile_controller.dart';
import 'package:flutter_instagram_clone/models/post_model.dart';
import 'package:flutter_instagram_clone/services/auth_service.dart';
import 'package:flutter_instagram_clone/views/appbar_widget.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  static const String id = "/profile_page";

  const ProfilePage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (profileController) {
        return Scaffold(
          appBar: appBar("Profile", Icon(Icons.exit_to_app,color: Colors.black,), (){AuthService.signOutUser(context);}),
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
                          badgeContent: GestureDetector(
                            onTap: () {
                              profileController.showPicker(context);
                            },
                              child: Icon(
                            Icons.add,
                            size: 23,
                          )),
                          child: Container(
                            height: 96,
                            width: 96,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(color: Colors.white, width: 2)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(75),
                              child:  profileController.user?.imageUrl == null || profileController.user!.imageUrl!.isEmpty ? const Image(
                                image: AssetImage("assets/images/profile.png"),
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ) : Image(
                                image: NetworkImage(profileController.user!.imageUrl!),
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
                      profileController.user == null ? "" : profileController.user!.fullName.toUpperCase(),
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    ),

                    /// #email
                    Text(
                      profileController.user == null ? "" : profileController.user!.email,
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w300),
                    ),

                    /// #statistics
                    Container(
                      height: 110,
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
                                    profileController.countPosts.toString(),
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
                                    profileController.user == null ? "0" : profileController.user!.followersCount.toString(),
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
                                    profileController.user == null ? "0" : profileController.user!.followingCount.toString(),
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

                    //listgrid
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: IconButton(
                                onPressed: profileController.swapOneCategory,
                                icon: Icon(Icons.list_alt),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: IconButton(
                                onPressed: profileController.swapTwoCategory,
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
                            crossAxisCount: profileController.axisCount),
                        itemCount: profileController.items.length,
                        itemBuilder: (ctx, index) {
                          return _itemOfPost(context,profileController,profileController.items[index]);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              if(profileController.isLoading) const Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _itemOfPost(BuildContext context,ProfileController controller,Post post) {
    return GestureDetector(
      onLongPress: () {},
        child: Container(
      margin: EdgeInsets.all(5),
      child: Column(
        children: [
          Expanded(
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              imageUrl: post.postImage,
              placeholder: (context, url) => Container(color: Colors.grey,),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            post.caption,
            style: TextStyle(color: Colors.black87.withOpacity(0.7)),
            maxLines: 2,
          ),
        ],
      ),
    ));
  }
}
