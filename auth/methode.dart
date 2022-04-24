import 'package:another_flushbar/flushbar.dart';
import 'package:chatapp/shardservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class authentification {
  flushbar(message, title, context) {
    return Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      title: title,
      duration: const Duration(seconds: 3),
      message: message,
      backgroundColor: Colors.white,
      borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
      titleColor: Colors.black,
      messageColor: Colors.black,
    ).show(context);
  }

  var userinfo = FirebaseFirestore.instance.collection("users");
  signinwithemail(username, email, password, url, context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = FirebaseAuth.instance.currentUser;
      await user!.sendEmailVerification();

      await userinfo.doc(user.uid).set({
        'username': username,
        'email': email,
        'userid': user.uid,
        "url": url,
        "lastsenn": "${DateTime.now().hour} : ${DateTime.now().minute}",
        "token": await FirebaseMessaging.instance.getToken()
      });

      Navigator.pop(context);
      flushbar(
          "Account Created Pleaze Verrify Your Account ", "Succeeded", context);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Navigator.pop(context);
        flushbar("weak-password", "Erro", context);
      }
      if (e.code == 'email-already-in-use') {
        Navigator.pop(context);
        // ignore: avoid_print
        flushbar("email-already-in-use", "Error", context);
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  loginWithemail(email, password, context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      getnamebyemail().then((value) async {
        var doucument = value.docs;
        await Shredservice.saveemail("${doucument.first.data()['username']}");
        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({"token": await FirebaseMessaging.instance.getToken()});
      });

      Navigator.pushNamedAndRemoveUntil(
          context, "HomeApp", ModalRoute.withName("/"));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //Navigator.pop(context);
        flushbar("user-not-found", "Error", context);
      } else if (e.code == 'wrong-password') {
        // Navigator.pop(context);
        // ignore: avoid_print
        flushbar("Wrong-Password", "Error", context);

        //showloding();

      }
    }
  }

  Future<List<DocumentSnapshot>> getuserbyname(patren) =>
      FirebaseFirestore.instance
          .collection("users")
          .where("username", isEqualTo: patren)
          .get()
          .then((value) => value.docs);
  // ignore: avoid_function_literals_in_foreach_calls);

  Future<QuerySnapshot<Map<String, dynamic>>> getnamebyemail() async =>
      await FirebaseFirestore.instance
          .collection("users")
          .where("userid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

  generateromId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$a _$b";
    } else {
      return "$b _$a";
    }
  }

  createchatromwithuserid(chatromid, Map<String, dynamic> chatromMap) {
    FirebaseFirestore.instance
        .collection("chatrom")
        .doc(chatromid)
        .set(chatromMap)
        // ignore: avoid_print
        .onError((error, stackTrace) => print("$error"));
  }
}


      
  // ignore: avoid_function_literals_in_foreach_calls);

