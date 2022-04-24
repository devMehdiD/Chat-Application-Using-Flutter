import 'dart:io';
import 'dart:math';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'methode.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  // ignore: prefer_typing_uninitialized_variables
  var path;
  // ignore: prefer_typing_uninitialized_variables
  var url;
  Widget loacaimage = Image.asset(
    "assets/personn.png",
    fit: BoxFit.fill,
    width: 150,
    height: 150,
  );
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  late String email;
  late String password;
  late String username;
  bool isEmail(String input) => EmailValidator.validate(input);
  bool haidentext1 = true;
  bool haidentext2 = true;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  valid() {
    var form = formstate.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView(
        children: [
          Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Form(
              key: formstate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                            child: ClipRRect(
                                clipBehavior: Clip.antiAlias,
                                borderRadius: BorderRadius.circular(100),
                                child: SizedBox(
                                  height: 200,
                                  width: 200,
                                  child: GridTile(
                                    child: path != null
                                        ? Image.file(
                                            path!,
                                            fit: BoxFit.cover,
                                            width: 150,
                                            height: 150,
                                          )
                                        : loacaimage,
                                    footer: Container(
                                      padding: const EdgeInsets.only(right: 30),
                                      alignment: Alignment.bottomRight,
                                      child: IconButton(
                                          onPressed: () async {
                                            await getimage();
                                          },
                                          icon: const Icon(
                                            Icons.camera_alt,
                                            color: Colors.redAccent,
                                            size: 30,
                                          )),
                                    ),
                                  ),
                                )))
                      ]),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            // ignore: sized_box_for_whitespace
                            Container(
                              height: 70,
                              child: TextFormField(
                                validator: (val) {
                                  if (val!.length < 2 || val.length > 6) {
                                    return "Invalid Format";
                                  }
                                },
                                onSaved: (val) {
                                  setState(() {
                                    username = val!;
                                  });
                                },
                                cursorColor: Colors.red,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.black,
                                  ),
                                  hintText: "User Name",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            // ignore: sized_box_for_whitespace
                            Container(
                              height: 70,
                              child: TextFormField(
                                validator: (val) {
                                  if (isEmail("$val") == false) {
                                    return "Email incorecte";
                                  }
                                },
                                onSaved: (val) {
                                  email = val!;
                                },
                                cursorColor: Colors.red,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.black,
                                  ),
                                  hintText: "example@gmail.com",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          height: 70,
                          child: TextFormField(
                            onSaved: (val) {
                              password = val!;
                            },
                            validator: (val) {
                              if (val!.length < 6 || val.length > 12) {
                                return "Weak Password";
                              }
                            },
                            obscureText: haidentext1,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.black,
                              ),
                              hintText: "Password",
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      haidentext1 = !haidentext1;
                                    });
                                  },
                                  icon: haidentext1
                                      ? const Icon(
                                          Icons.visibility_off,
                                          color: Colors.black,
                                        )
                                      : const Icon(Icons.visibility,
                                          color: Colors.black)),
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Have Account Sign in ?",
                                style: TextStyle(
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: MaterialButton(
                      color: Colors.redAccent,
                      elevation: 10,
                      height: 40,
                      minWidth: 250,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      textColor: Colors.black87,
                      onPressed: () async {
                        if (valid() == true) {
                          await authentification().signinwithemail(
                              username, email, password, url, context);
                        }
                      },
                      child: const Text("Sign Up"),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  getimage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      var myimage = File(image.path);
      path = myimage;
      var random = Random().nextInt(100000);
      var storage = FirebaseStorage.instance.ref("userimage/$random");
      await storage.putFile(myimage);
      var urlimage = await storage.getDownloadURL();
      // ignore: avoid_print
      print("url===========================$urlimage");
      setState(() {
        url = urlimage;

        // ignore: avoid_print
      });
    }
  }
}
