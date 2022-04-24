import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'auth/methode.dart';

AudioPlayer audioplayer = AudioPlayer();

creategroupwidget(url) async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    File file = File(image.path);
    var random = Random().nextInt(10000);
    var ref = FirebaseStorage.instance.ref("mesagesimage/$random");
    await ref.putFile(file);
    url = await ref.getDownloadURL();
  }
}

sendmessageimage(
    myimage, chatromid, myname, sendbyimage, imagemessage, source) async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(source: source);
  if (image != null) {
    myimage = File(image.path);
    var random = Random().nextInt(100000);
    var ref = FirebaseStorage.instance.ref("mesagesimage/$random");
    await ref.putFile(myimage);
    dynamic urlimage = await ref.getDownloadURL();
    FirebaseFirestore.instance
        .collection("chatrom")
        .doc(chatromid)
        .collection("chats")
        .add({
      "message": null,
      "imagemessage": urlimage,
      "myname": myname,
      "sendbyimage": sendbyimage,
      "time": DateTime.now().millisecondsSinceEpoch,
      "messagetime": "${DateTime.now().hour}:${DateTime.now().minute}"
    });
    FirebaseFirestore.instance.collection("chatrom").doc(chatromid).update({
      "lastmessge": "send image",
      "timelastmessage": "${DateTime.now().hour}:${DateTime.now().minute}"
    });
    await playesong();
  } else {
    imagemessage = null;
  }
}

sendmessageimagetogeroupe(docid, myname, source) async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(source: source);
  if (image != null) {
    File myimage = File(image.path);
    var random = Random().nextInt(100000);
    var ref = FirebaseStorage.instance.ref("mesagesimage/$random");
    await ref.putFile(myimage);
    dynamic urlimage = await ref.getDownloadURL();
    FirebaseFirestore.instance
        .collection("groupe")
        .doc(docid)
        .collection("chats")
        .add({
      "message": null,
      "imagemessage": urlimage,
      "myname": myname,
      "time": DateTime.now().millisecondsSinceEpoch,
      "messagetime": "${DateTime.now().hour}:${DateTime.now().minute}"
    });
    await playesong();
  }
}

playesong() async {
  AudioCache audioCache = AudioCache(fixedPlayer: audioplayer);
  await audioCache.play("song.mp3");
}

sendnoatificatoin(String message, String id, String name) async {
  var serverkey =
      "AAAAvn1MKu4:APA91bGooCFtuxMJXajQv_ydCUVKD6LO6Ri3V3xE7cR2z47GE-2NJn1vNmIkleSuBzpMKjmc1cKMzFl7piVBFfXyazWAq7A2gM5BM0hB_lD2_GMb_U9ya7jlDaXPPAKBEdDSijqZZNvC";
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  try {
    DocumentSnapshot<Map<String, dynamic>> userid =
        await FirebaseFirestore.instance.collection("users").doc(id).get();
    var token = userid.get("token");
    await http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverkey',
      },
      body: jsonEncode(<String, dynamic>{
        'notification': <String, dynamic>{
          'body': message.toString(),
          'title': name.toString()
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          "title": name.toString(),
          "body": message.toString()
        },
        'to': token,
      }),
    );
  } catch (e) {
    print("==========error= $e");
  }
}

Future<void> Createchatrom(
    String username2, userid2, urlimage1, urlimage2, myname) async {
  try {
    String chatromid = authentification().generateromId(username2, myname);
    var userid1 = FirebaseAuth.instance.currentUser!.uid;
    Map<String, dynamic> chatrom = {
      "users": FieldValue.arrayUnion(
          [username2, myname, userid1, userid2, urlimage1, urlimage2]),
      "lastmessge": "",
      "timelastmessage": "${DateTime.now().hour} ${DateTime.now().minute}",
      "chatromid": chatromid,
      "time": DateTime.now().millisecondsSinceEpoch
    };
    await authentification().createchatromwithuserid(chatromid, chatrom);
  } catch (e) {
    // ignore: avoid_print
    print(e);
  }
}
