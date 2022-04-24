import 'package:audioplayers/audioplayers.dart';
import 'package:chatapp/image.dart';
import 'package:chatapp/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class Conversation extends StatefulWidget {
  dynamic chanelname;
  dynamic chatromid;
  dynamic myname;
  dynamic urlimage;
  dynamic sendbyimage;
  Conversation(
      {Key? key,
      required this.chanelname,
      required this.chatromid,
      required this.myname,
      required this.urlimage,
      required this.sendbyimage})
      : super(key: key);

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation>
    with SingleTickerProviderStateMixin {
  TextEditingController controller = TextEditingController();
  dynamic imagemessage;
  dynamic myimage;
  dynamic lastsince = "...";
  dynamic thidid;

  @override
  void initState() {
    getlastsign();
    updatelastsignin();
    super.initState();
  }

  updatelastsignin() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "lastsign": FirebaseAuth.instance.currentUser!.metadata.lastSignInTime
    });
  }

  getlastsign() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var id = FirebaseFirestore.instance
        .collection("chatrom")
        .doc(widget.chatromid)
        .get();
    var data = await id.then((value) => value.get("users"));
    if (data[2] == uid) {
      thidid = data[3];
    } else
      thidid = data[2];

    var user = FirebaseFirestore.instance.collection("users").doc(thidid).get();
    var lasttime = await user.then((value) => value.get("lastsenn"));
    setState(() {
      lastsince = lasttime;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  //Remember to add extendBody: true to scaffold!
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/background.jpg"), fit: BoxFit.cover)),
      child: Scaffold(
        appBar: AppBar(
            elevation: 0,
            title: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.urlimage),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "${widget.chanelname}",
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      "Last since at $lastsince",
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                  ),
                )
              ],
            )),
        body: ListView(
          children: [
            Container(
                padding: const EdgeInsets.only(left: 10),
                height: MediaQuery.of(context).size.height - 150,
                child: getmessage(widget.chatromid, size)),
            textfieldTosendmessage(),
          ],
        ),
      ),
    );
  }

  Widget getmessage(romid, Size size) {
    var allmessage = FirebaseFirestore.instance
        .collection("chatrom")
        .doc(romid)
        .collection("chats")
        .orderBy(
          "time",
        );

    return StreamBuilder(
        stream: allmessage.snapshots(includeMetadataChanges: false),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            ScrollController listcontroller = ScrollController(
                initialScrollOffset: snapshot.data!.docs.length * 111);
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                controller: listcontroller,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (_, i) {
                  dynamic length;
                  if (snapshot.data!.docs[i]['message'] != null) {
                    length = int.parse(
                        "${snapshot.data!.docs[i]["message"].length}");
                  }

                  bool messageby = false;
                  if ("${snapshot.data!.docs[i]["myname"]}" == widget.myname) {
                    messageby = true;
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      messageby
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: snapshot.data!.docs[i]['message'] !=
                                          null
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          width: length == 1 || length == 2
                                              ? 50
                                              : size.width / 2 + length,
                                          height: length > 10
                                              ? length / 1.5 + 10
                                              : 60,
                                          decoration: const BoxDecoration(
                                              color: Color(0xffc7cec4),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              )),
                                          child: Center(
                                              child: GridTile(
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Text(
                                                  "${snapshot.data!.docs[i]['message']}",
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                )),
                                            footer: Align(
                                              alignment: Alignment.bottomRight,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 6),
                                                child: Text(
                                                  "${snapshot.data!.docs[i]['messagetime']}",
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10),
                                                ),
                                              ),
                                            ),
                                          )),
                                        )
                                      : null,
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, right: 10),
                                    child: GridTile(
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: snapshot.data!.docs[i]
                                                    ["imagemessage"] !=
                                                null
                                            ? InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) => Sendimage(
                                                              urlimage: snapshot
                                                                      .data!
                                                                      .docs[i][
                                                                  "imagemessage"],
                                                              tag: snapshot
                                                                  .data!
                                                                  .docs[i])));
                                                },
                                                child: Hero(
                                                  tag: snapshot.data!.docs[i],
                                                  child: Image.network(
                                                    snapshot.data!.docs[i]
                                                        ["imagemessage"],
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              )
                                            : null,
                                      ),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundImage: NetworkImage(
                                        "${snapshot.data!.docs[i]["sendbyimage"]}"),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: snapshot.data!.docs[i]['message'] !=
                                          null
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          width: length == 1 || length == 2
                                              ? 50
                                              : size.width / 2 + length,
                                          height: length > 10
                                              ? length / 1.5 + 10
                                              : 60,
                                          decoration: const BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              )),
                                          child: Center(
                                              child: GridTile(
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Text(
                                                  "${snapshot.data!.docs[i]['message']}",
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                )),
                                            footer: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 6),
                                                child: Text(
                                                  "${snapshot.data!.docs[i]['messagetime']}",
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10),
                                                ),
                                              ),
                                            ),
                                          )),
                                        )
                                      : null,
                                ),
                                Padding(
                                    padding:
                                        const EdgeInsets.only(top: 10, left: 5),
                                    child: GridTile(
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: snapshot.data!.docs[i]
                                                    ["imagemessage"] !=
                                                null
                                            ? InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) => Sendimage(
                                                              urlimage: snapshot
                                                                      .data!
                                                                      .docs[i][
                                                                  "imagemessage"],
                                                              tag: snapshot
                                                                  .data!
                                                                  .docs[i])));
                                                },
                                                child: Hero(
                                                  tag: snapshot.data!.docs[i],
                                                  child: Image.network(
                                                    snapshot.data!.docs[i]
                                                        ["imagemessage"],
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              )
                                            : null,
                                      ),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: CircleAvatar(
                                    radius: 10,
                                    backgroundImage: NetworkImage(
                                        "${snapshot.data!.docs[i]["sendbyimage"]}"),
                                  ),
                                ),
                              ],
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  );
                });
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("eroor"),
            );
          }
          return const Center(
            child: Text("Start conversation"),
          );
        });
  }

//////// add message

  addmessage() async {
    if (controller.text != "") {
      await playesong();
      Map<String, dynamic> message = {
        "message": controller.text,
        "imagemessage": imagemessage,
        "sendbyimage": widget.sendbyimage,
        "myname": widget.myname,
        "time": DateTime.now().millisecondsSinceEpoch,
        "messagetime": "${DateTime.now().hour}:${DateTime.now().minute}"
      };
      (Map<String, dynamic> messageinfo, chatromid, lastmesage) {
        FirebaseFirestore.instance
            .collection("chatrom")
            .doc(chatromid)
            .collection("chats")
            .add(messageinfo)
            .catchError((e) {
          // ignore: avoid_print
          print("$e");
        });
        FirebaseFirestore.instance.collection("chatrom").doc(chatromid).update({
          "lastmessge": lastmesage,
          "timelastmessage": "${DateTime.now().hour}:${DateTime.now().minute}",
          "time": DateTime.now().millisecondsSinceEpoch
        });
      }(message, widget.chatromid, controller.text);
      String text = controller.text;
      controller.clear();
      await sendnoatificatoin(text, thidid, widget.myname);
    }
  }

  Widget textfieldTosendmessage() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            sendmessageimage(myimage, widget.chatromid, widget.myname,
                widget.sendbyimage, imagemessage, ImageSource.camera);
          },
          icon: const Icon(
            Icons.photo,
            color: Colors.white,
          ),
        ),
        IconButton(
            onPressed: () async {
              sendmessageimage(myimage, widget.chatromid, widget.myname,
                  widget.sendbyimage, imagemessage, ImageSource.gallery);
            },
            icon: const Icon(
              Icons.camera_alt,
              color: Colors.white,
            )),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: MediaQuery.of(context).size.width - 70,
              decoration: const BoxDecoration(),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {});
                },
                minLines: 1,
                maxLines: 10,
                controller: controller,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffc7cec4),
                  hintText: "Type your Message",
                  suffixIcon: IconButton(
                      onPressed: () async {
                        await addmessage();
                      },
                      icon: controller.text.isNotEmpty
                          ? const CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Icon(Icons.send, color: Colors.white),
                            )
                          : const SizedBox()),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.white)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
