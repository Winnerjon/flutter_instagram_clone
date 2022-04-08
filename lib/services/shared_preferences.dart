
import 'package:shared_preferences/shared_preferences.dart';

class Prefs{

  static storeUserId(String userId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("id", userId);
  }

  static Future<String?> loadUserId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("id");
  }

  static Future<bool> remove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove("id");
  }

  static storeUserToken(String token) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
  }

  static Future<String?> loadUserToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<bool> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove("token");
  }

  }

