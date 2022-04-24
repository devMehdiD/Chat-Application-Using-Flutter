import 'package:chatapp/homeapp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'auth/sign_in.dart';
import 'pageapp/discussions.dart';

bool concted = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // ignore: unnecessary_null_comparison

  runApp(const MyApp());
  var user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    concted = true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black12, foregroundColor: Colors.white),
          scaffoldBackgroundColor: Colors.black12),

      // ignore: prefer_const_constructors
      home: concted ? HomeApp() : const Signin(),
      routes: {
        "HomeApp": (context) => const HomeApp(),
        'Homechat': (context) => const FerstPage(),
        'Login': (context) => const Signin()
      },
    );
  }
}
