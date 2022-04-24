// ignore_for_file: unused_local_variable
import 'dart:async';
import 'package:chatapp/shardservice.dart';
import 'package:chatapp/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../DicscusionGroupe/conversaton.dart';

class FerstPage extends StatefulWidget {
  const FerstPage({Key? key}) : super(key: key);

  @override
  _HomechatState createState() => _HomechatState();
}

class _HomechatState extends State<FerstPage>
    with SingleTickerProviderStateMixin {
  dynamic myname;
  dynamic myurlimage;
  dynamic message;
  dynamic chatromid;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  getmyusetrname() async {
    var doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    await Shredservice.saveusername(doc['username']);
    myname = await Shredservice.getmyusername();
    print(myname);
    await Shredservice.savesendbyimage("${doc['url']}");
    myurlimage = await Shredservice.getsendbyimage();
  }

  @override
  void initState() {
    online();
    getmyusetrname();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ignore: prefer_typing_uninitialized_variables

  Future<void> online() async {
    var userinfo = FirebaseFirestore.instance.collection("users");
    var user = FirebaseAuth.instance.currentUser;

    await userinfo.doc(user!.uid).update({
      "lastsenn": "${DateTime.now().day}"
          "/"
          "${DateTime.now().year}"
          "/"
          "${DateTime.now().month}"
          " "
          "${DateTime.now().hour}"
          ":"
          "${DateTime.now().minute}"
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          SizedBox(
              height: 70,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .where("userid", isNotEqualTo: uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (_, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                child: GestureDetector(
                                  onTap: () {
                                    try {
                                      Createchatrom(
                                          "${snapshot.data!.docs[index]['username']}",
                                          snapshot.data!.docs[index]['userid'],
                                          myurlimage,
                                          snapshot.data!.docs[index]['url'],
                                          myname);
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                        snapshot.data!.docs[index]['url']),
                                  ),
                                ),
                              ),
                            );
                          });
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  })),
          const SizedBox(height: 20),
          Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
            height: MediaQuery.of(context).size.height,
            child: getuserschat(),
          )
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names

  getuserschat() {
    dynamic users;

    try {
      users = FirebaseFirestore.instance.collection("chatrom").where("users",
          arrayContains: FirebaseAuth.instance.currentUser!.uid);
    } catch (e) {
      // ignore: avoid_print
      print('$e');
    }

    return StreamBuilder(
        stream: users.snapshots(includeMetadataChanges: true),
        builder: (buildcontxt, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext buildContext, index) {
                dynamic id = snapshot.data!.docs[index].id;
                var urlimage1 = snapshot.data!.docs[index]['users'][4];
                var urlimage2 = snapshot.data!.docs[index]['users'][5];
                var username1 = snapshot.data!.docs[index]['users'][0];
                dynamic url;
                var username2 = snapshot.data!.docs[index]['users'][1];
                // ignore: prefer_typing_uninitialized_variables
                var namechanel;
                if (username1 == myname) {
                  namechanel = username2;
                } else {
                  namechanel = username1;
                }

                if (urlimage1 != myurlimage) {
                  url = urlimage1;
                } else {
                  url = urlimage2;
                }
                return Slidable(
                  endActionPane:
                      ActionPane(motion: const ScrollMotion(), children: [
                    SlidableAction(
                      onPressed: (BuildContext buildContext) {
                        FirebaseFirestore.instance
                            .collection("chatrom")
                            .doc(id)
                            .delete()
                            // ignore: avoid_print
                            .onError((error, stackTrace) => print(error));
                        FirebaseFirestore.instance
                            .collection("chatrom")
                            .doc(id)
                            .collection("chats")
                            .doc()
                            .delete();
                      },
                      backgroundColor: const Color(0xFFFE4A49),
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ]),
                  child: SizedBox(
                    height: 100,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => Conversation(
                                        chanelname: namechanel,
                                        chatromid:
                                            snapshot.data!.docs[index].id,
                                        myname: myname,
                                        urlimage: url,
                                        sendbyimage: myurlimage,
                                      )));
                        },
                        leading: url != null
                            ? CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(url),
                              )
                            : const CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage(
                                  "assets/personn.png",
                                ),
                              ),
                        subtitle:
                            Text("${snapshot.data!.docs[index]["lastmessge"]}"),
                        title: Text(
                          "$namechanel",
                          style: const TextStyle(fontSize: 20),
                        ),
                        trailing: Text(
                          "${snapshot.data!.docs[index]["timelastmessage"]}",
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return Column(
              children: const [
                /// iMAGE hERE
              ],
            );
          }
          if (snapshot.hasError) {
            return const Center(child: Text("error"));
          }
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        });
  }
}
