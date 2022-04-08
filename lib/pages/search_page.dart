import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/contollers/search_controller.dart';
import 'package:flutter_instagram_clone/models/user_model.dart';
import 'package:flutter_instagram_clone/views/appbar_widget.dart';
import 'package:get/get.dart';

class SearchPage extends StatelessWidget {
  static const String id = "/search_page";

  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("Search", null, null),
      body: GetBuilder<SearchController>(
        builder: (searchController) {
          return SingleChildScrollView(
            child: Column(
              children: [

                /// #search textfield
                Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade300,
                  ),
                  child: TextField(
                    controller: searchController.controller,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search,color: Colors.grey,),
                      hintText: "Search",
                      border: InputBorder.none
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height - 214,
                  child: ListView.builder(
                    itemCount: searchController.items.length,
                    itemBuilder: (context,index){
                      return itemFindList(searchController, searchController.items[index]);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget itemFindList(SearchController controller, User user) {
    return ListTile(
      onTap: () => controller.getUserProfilePage(user),
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: user.imageUrl != null ? CachedNetworkImage(
          height: 45,
          width: 45,
          fit: BoxFit.cover,
          imageUrl: user.imageUrl!,
          placeholder: (context, url) => const Image(image: AssetImage("assets/images/profile.png")),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ) : const Image(image: AssetImage("assets/images/profile.png"), height: 45,width: 45,),
      ),
      title: Text(
        user.fullName,
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        user.email,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
      ),
      trailing: MaterialButton(
        height: 33,
        minWidth: 100,
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(
            color: Colors.grey.shade400,
            width: 1.5,
          ),
        ),
        child: Text(user.followed ? "Following" : "Follow"),
        onPressed: (){
          controller.updateFollow(user);
        },
      ),
    );
  }
}
