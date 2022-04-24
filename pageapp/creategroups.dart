import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../chanelcreate.dart';

class Groups extends StatefulWidget {
  const Groups({Key? key}) : super(key: key);

  @override
  _GroupsState createState() => _GroupsState();
}

class _GroupsState extends State<Groups> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  var checked = false;
  List imagemembers = [];
  List<Map<String, dynamic>> nameanduserid_members = [];
  dynamic selectedindex;
  var contact = FirebaseFirestore.instance
      .collection("users")
      .where("userid", isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots(includeMetadataChanges: true);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          onPressed: () {
            if (imagemembers.length > 1) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => chanelcreate(
                            members: imagemembers,
                            nameanduserid_members: nameanduserid_members,
                          )));
            }
          },
          label: const Text("Create Groups")),
      body: ListView(children: [
        const SizedBox(
          height: 90,
        ),
        Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            height: MediaQuery.of(context).size.height,
            child: StreamBuilder(
                stream: contact,
                builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (_, index) {
                          Color? mycolor = Colors.red[100 * index];

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 70,
                                child: ListTile(
                                  tileColor: Colors.white,
                                  leading:
                                      snapshot.data!.docs[index]['url'] != null
                                          ? CircleAvatar(
                                              radius: 30,
                                              backgroundImage: NetworkImage(
                                                  snapshot.data!.docs[index]
                                                      ['url']),
                                            )
                                          : const CircleAvatar(
                                              radius: 30,
                                              backgroundImage: AssetImage(
                                                "assets/personn.png",
                                              ),
                                            ),
                                  title: Text(
                                      snapshot.data!.docs[index]["username"]),
                                  onLongPress: () {
                                    setState(() {
                                      selectedindex = index;
                                      imagemembers.add(snapshot
                                          .data!.docs[selectedindex]["url"]);
                                      /////////////////////////////////////
                                      nameanduserid_members.add({
                                        "url": snapshot
                                            .data!.docs[selectedindex]["url"],
                                        "username": snapshot.data!
                                            .docs[selectedindex]["username"],
                                        "userid": snapshot
                                            .data!.docs[selectedindex]["userid"]
                                      });
                                    });
                                  },
                                  onTap: () {
                                    try {
                                      setState(() {
                                        selectedindex = index;
                                        imagemembers.remove((snapshot
                                            .data!.docs[selectedindex]["url"]));
                                        nameanduserid_members.remove(snapshot
                                            .data!.docs[selectedindex]["url"]);
                                        nameanduserid_members.remove(snapshot
                                            .data!
                                            .docs[selectedindex]["username"]);
                                        nameanduserid_members.remove(snapshot
                                            .data!
                                            .docs[selectedindex]["userid"]);
                                      });
                                    } catch (e) {
                                      print("$e");
                                    }
                                  },
                                  trailing: imagemembers.contains(
                                          snapshot.data!.docs[index]["url"])
                                      ? const Icon(Icons.check_circle_outlined,
                                          color: Colors.black)
                                      : const Icon(
                                          Icons.check_circle_outlined,
                                          color: Colors.grey,
                                        ),
                                )),
                          );
                        });
                  }
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.white,
                  ));
                })),
      ]),
    );
  }
}
