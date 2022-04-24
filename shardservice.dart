import 'package:shared_preferences/shared_preferences.dart';

class Shredservice {
  static const loggedinkey = "LOGGED";
  static const myusername = "usname";
  static const username2 = "";
  static const urlimage = "url";
  static const sendbyimage = "sendbyimage";

  // SAVE DATE IN THE KEYS
  static Future<bool> saveloggedin(bool loggedin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(loggedinkey, loggedin);
  }

  static Future<bool> savesendbyimage(String senbyimg) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sendbyimage, senbyimg);
  }

  static Future<bool> saveimage(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(urlimage, url);
  }

  static Future<bool> saveusername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(myusername, username);
  }

  static Future<bool> saveemail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(username2, email);
  }

  // GET DATE

  static Future<String?> getloggedin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(loggedinkey);
  }

  static Future<String?> getmyusername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(myusername);
  }

  static Future<String?> getusername2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(username2);
  }

  static Future<String?> geturlimage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(urlimage);
  }

  static Future<String?> getsendbyimage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sendbyimage);
  }
}
