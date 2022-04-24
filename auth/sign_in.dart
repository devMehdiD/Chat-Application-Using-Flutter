// ignore_for_file: avoid_unnecessary_containers, avoid_print

import 'package:chatapp/auth/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'methode.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  _ChoseAuthState createState() => _ChoseAuthState();
}

class _ChoseAuthState extends State<Signin> {
  bool isEmail(String input) => EmailValidator.validate(input);
  bool scren = false;
  bool haidentext1 = true;
  bool haidentext2 = true;

  TextEditingController controller = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  late String emailuser;
  late String phoneno;
  late String smsCode;
  late String verificationId;

  GlobalKey<FormState> form = GlobalKey<FormState>();
  GlobalKey<FormState> phoneform = GlobalKey<FormState>();
  late String email;
  late String password;
  late String username;
  var userinfo = FirebaseFirestore.instance.collection("users");
  validatorofphone() {
    var phone = phoneform.currentState;
    if (phone!.validate()) {
      phone.save();
      return true;
    } else {
      return false;
    }
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView(children: [
        Container(
          color: Colors.white,
          height: size.height,
          width: size.width,
          child: Form(
            key: formstate,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Center(
                    child: Image.asset(
                  "assets/myicon.png",
                  height: 200,
                  width: 200,
                )),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    height: 70,
                    child: TextFormField(
                      onSaved: (val) {
                        email = val!;
                      },
                      validator: (val) {
                        if (isEmail("$val") == false) {
                          return "Email incorecte";
                        }
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.black,
                        ),
                        hintText: "example@gmail.com",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        focusColor: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Container(
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
                      obscureText: haidentext2,
                      decoration: InputDecoration(
                        focusColor: Colors.black,
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.black,
                        ),
                        hintText: "Password",
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                haidentext2 = !haidentext2;
                              });
                            },
                            icon: haidentext2
                                ? const Icon(
                                    Icons.visibility_off,
                                    color: Colors.black,
                                  )
                                : const Icon(
                                    Icons.visibility,
                                    color: Colors.black,
                                  )),
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 40,
                  ),
                  child: Container(
                      child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 600),
                              pageBuilder: (buildcontext, animation, second) {
                                var begin = const Offset(0, 1);
                                var end = Offset.zero;
                                var twen =
                                    Tween<Offset>(begin: begin, end: end);
                                var animationposition = animation.drive(twen);
                                return SlideTransition(
                                  position: animationposition,

                                  /// child:  ForgetPassword(),
                                );
                              }));
                    },
                    child: const Text(
                      "Forget Password ?",
                      style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline),
                    ),
                  )),
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: MaterialButton(
                    elevation: 10,
                    color: Colors.redAccent,
                    height: 40,
                    minWidth: 250,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    textColor: Colors.black87,
                    textTheme: ButtonTextTheme.normal,
                    onPressed: () async {
                      if (valid() == true) {
                        // ignore: await_only_futures
                        await authentification()
                            .loginWithemail(email, password, context);
                      }
                    },
                    child: const Text("Sign In"),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Dont have account ? ",
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                  transitionDuration:
                                      const Duration(milliseconds: 600),
                                  pageBuilder:
                                      (buildcontext, animation, second) {
                                    var begin = const Offset(0.0, 1);
                                    var end = Offset.zero;
                                    var twen = Tween(begin: begin, end: end);
                                    var position = animation.drive(twen);
                                    return SlideTransition(
                                      position: position,
                                      child: const Signup(),
                                    );
                                  }));
                        },
                        child: const Text(
                          "Sign up ",
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
