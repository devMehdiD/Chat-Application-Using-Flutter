import 'dart:io';
import 'dart:math';
import 'package:chatapp/shardservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class chanelcreate extends StatefulWidget {
  List members = [];

  List<Map<String, dynamic>> nameanduserid_members = [];
  chanelcreate({
    Key? key,
    required this.members,
    required this.nameanduserid_members,
  }) : super(key: key);

  @override
  _CreatechanelState createState() => _CreatechanelState();
}

class _CreatechanelState extends State<chanelcreate>
    with SingleTickerProviderStateMixin {
  TextEditingController controller = TextEditingController();
  dynamic imagegroupe;
  var nameofgroup = "Groupe Name";
  dynamic myname;
  dynamic myimage;
  dynamic uid;
  getmyinfo() async {
    myimage = await Shredservice.getsendbyimage();
    myname = await Shredservice.getmyusername();
    uid = FirebaseAuth.instance.currentUser!.uid;
    setState(() {
      widget.nameanduserid_members
          .add({"url": myimage, "username": myname, "userid": uid});
    });
  }

  @override
  void initState() {
    getmyinfo();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView(children: [
        Column(
          children: [
            Center(
                child: ClipRRect(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(100),
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: GridTile(
                        child: imagegroupe != null
                            ? Image.file(
                                imagegroupe!,
                                fit: BoxFit.cover,
                                width: 150,
                                height: 150,
                              )
                            : Image.asset("assets/personn.png",
                                width: 150, height: 150),
                        footer: Container(
                          padding: const EdgeInsets.only(right: 30),
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                              onPressed: () async {
                                await choseimage();
                              },
                              icon: const Icon(
                                Icons.camera_alt,
                                color: Colors.redAccent,
                                size: 30,
                              )),
                        ),
                      ),
                    ))),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  nameofgroup,
                  style: const TextStyle(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40),
              child: Center(
                child: TextField(
                  controller: controller,
                  onChanged: (val) {
                    setState(() {
                      nameofgroup = val;
                    });
                  },
                  decoration: const InputDecoration(hintText: "groupe name"),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 100,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.members.length,
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(widget.members[index]),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            if (controller.text != null && controller.text == "") {
              return null;
            } else {
              var random = Random().nextInt(10000);
              var ref = FirebaseStorage.instance.ref("mesagesimage/$random");
              if (imagegroupe != null) {
                await ref.putFile(imagegroupe);
                var image = await ref.getDownloadURL();
                await creategrup_ofmemebers(
                    widget.nameanduserid_members, controller.text, image);
                Navigator.pop(context);
              } else {
                print("chose image");
              }
            }
          },
          label: Text("Create Groupe")),
    );
  }

  choseimage() async {
    ImagePicker imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imagegroupe = File(image.path);
      });
      print(widget.members);
    } else {
      print('no image');
    }
  }

  creategrup_ofmemebers(members, chanelname, imagegroupe) async {
    try {
      await FirebaseFirestore.instance.collection("groupe").add({
        "members": members,
        "namechanel": chanelname,
        "imagegroupe": imagegroupe,
        //"userid":members['userid']
      });
    } catch (e) {
      print("**************************************");
    }
  }
}
