import 'package:chatapp/DicscusionGroupe/diccsucsiongroupe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GroupView extends StatefulWidget {
  const GroupView({Key? key}) : super(key: key);

  @override
  _GroupViewState createState() => _GroupViewState();
}

class _GroupViewState extends State<GroupView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    print("=====================${FirebaseAuth.instance.currentUser!.uid}");
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
      body: ListView(children: [
        SizedBox(
          height: 90,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                )),
            child: getgroups(Axis.vertical, true, true),
          ),
        ),
      ]),
    );
  }

  getgroups(Axis axis, bool showtrilling, bool showname) {
    var stream = FirebaseFirestore.instance.collection("groupe");
    return StreamBuilder(
        stream: stream.snapshots(includeMetadataChanges: true),
        builder: (c, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
                scrollDirection: axis,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (_, index) {
                  List ids = [];
                  List<dynamic> sna = snapshot.data!.docs[index].get("members");
                  sna.forEach((element) {
                    ids.add(element["userid"]);
                  });
                  bool id =
                      ids.contains(FirebaseAuth.instance.currentUser!.uid);

                  print(id);
                  if (id == true) {
                    return Container(
                        margin: const EdgeInsets.all(10),
                        height: 70,
                        child: ListTile(
                            onTap: () {
                              // ignore: avoid_print
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Discisiongroupe(
                                          docid: snapshot.data!.docs[index].id,
                                          imagegroupe: snapshot
                                              .data!.docs[index]["imagegroupe"],
                                          chanelname: snapshot.data!.docs[index]
                                              ["namechanel"])));
                            },
                            trailing: showtrilling
                                ? Text(
                                    "you + ${sna.length - 1} users",
                                    style: TextStyle(color: Colors.red),
                                  )
                                : null,
                            title: showname
                                ? Text(
                                    snapshot.data!.docs[index]['namechanel'],
                                  )
                                : null,
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                  snapshot.data!.docs[index]['imagegroupe']),
                            )));
                  }
                  return SizedBox();
                });
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
