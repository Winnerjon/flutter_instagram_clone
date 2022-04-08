import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/contollers/likes_controller.dart';
import 'package:flutter_instagram_clone/models/post_model.dart';
import 'package:flutter_instagram_clone/views/appbar_widget.dart';
import 'package:get/get.dart';

class LikesPage extends StatelessWidget {
  static const String id = "/likes_page";

  const LikesPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GetBuilder<LikesController>(
      builder: (likeController) {
        return Scaffold(
          appBar: appBar("Like", null,null),
          body: Stack(
            children: [
              ListView.builder(
                itemCount: likeController.items.length,
                itemBuilder: (context, index) {
                  return itemBodyList(context,likeController,likeController.items[index]);
                },
              ),

              if(likeController.isLoading) const Center(
                child: CircularProgressIndicator(),
              )
            ],
          ),
        );
      }
    );
  }

  Widget itemBodyList(BuildContext context,LikesController controller,Post post) {
    return Column(
      children: [
        /// #profile
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: post.imageUser != null ? CachedNetworkImage(
              height: 40,
              imageUrl: post.imageUser!,
              placeholder: (context, url) => const Image(image: AssetImage("assets/images/user.png")),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ) : const Image(image: AssetImage("assets/images/profile.png"), height: 40,),
          ),
          title: Text(
            post.fullName,
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            post.createdDate.substring(0,16),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          trailing: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_horiz,
              color: Colors.black,
              size: 30,
            ),
          ),
        ),

        /// #post
        CachedNetworkImage(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
          imageUrl: post.postImage,
          placeholder: (context, url) => Container(color: Colors.grey,),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),

        /// #post icon
        Container(
          height: 45,
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          controller.updateLike(post);
                        },
                        icon: Icon(post.isLiked ? Icons.favorite : Icons.favorite_border,
                          color: post.isLiked ? Colors.red : Colors.black,
                          size: 28,
                        )
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        CupertinoIcons.conversation_bubble,
                        size: 28,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        CupertinoIcons.paperplane_fill,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 5),
                  child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        CupertinoIcons.bookmark,
                        size: 26,
                      )
                  ),
                ),
              ),
            ],
          ),
        ),

        /// #post commend
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Text(
            post.caption,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
