import 'package:chatapp/image.dart';
import 'package:chatapp/shardservice.dart';
import 'package:chatapp/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class Discisiongroupe extends StatefulWidget {
  dynamic docid;
  dynamic imagegroupe;
  dynamic chanelname;
  Discisiongroupe(
      {Key? key,
      required this.docid,
      required this.imagegroupe,
      required this.chanelname})
      : super(key: key);

  @override
  _DiscisiongroupeState createState() => _DiscisiongroupeState();
}

class _DiscisiongroupeState extends State<Discisiongroupe>
    with SingleTickerProviderStateMixin {
  TextEditingController controller = TextEditingController();
  dynamic myname;
  getinfo() async {
    myname = await Shredservice.getmyusername();
  }

  @override
  void initState() {
    getinfo();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  backgroundImage: NetworkImage(widget.imagegroupe),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "${widget.chanelname}",
                )
              ],
            )),
        body: ListView(
          children: [
            Container(
                padding: const EdgeInsets.only(left: 10),
                height: MediaQuery.of(context).size.height - 150,
                child: getchat()),
            textfiledTowriteMessage()
          ],
        ),
      ),
    );
  }

  getchat() {
    var chat = FirebaseFirestore.instance
        .collection("groupe")
        .doc(widget.docid)
        .collection("chats")
        .orderBy("time")
        .snapshots(includeMetadataChanges: true);
    return StreamBuilder(
        stream: chat,
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
                controller: ScrollController(
                    initialScrollOffset: snapshot.data!.docs.length * 100),
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (_, index) {
                  bool ismymessage =
                      snapshot.data!.docs[index]['myname'] == myname;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ismymessage
                          ? Column(
                              children: [
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: snapshot.data!.docs[index]
                                              ['message'] !=
                                          null
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          width: double.tryParse(
                                                  "${snapshot.data!.docs[index]['message'].length}")! *
                                              40,
                                          height: 70,
                                          decoration: const BoxDecoration(
                                              color: Color(0xffc7cec4),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              )),
                                          child: Center(
                                              child: GridTile(
                                            header: const Padding(
                                              padding: EdgeInsets.all(5),
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: Text(
                                                  "Me",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Text(
                                                  "${snapshot.data!.docs[index]['message']}",
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
                                                  "${snapshot.data!.docs[index]['messagetime']}",
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
                                        top: 10, right: 5),
                                    child: GridTile(
                                      child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: snapshot.data!.docs[index]
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
                                                                        .docs[index]
                                                                    [
                                                                    "imagemessage"],
                                                                tag: snapshot
                                                                        .data!
                                                                        .docs[
                                                                    index])));
                                                  },
                                                  child: Hero(
                                                    tag: snapshot
                                                        .data!.docs[index],
                                                    child: Image.network(
                                                      snapshot.data!.docs[index]
                                                          ["imagemessage"],
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                )
                                              : null),
                                    ))
                              ],
                            )
                          : Column(
                              children: [
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: snapshot.data!.docs[index]
                                              ['message'] !=
                                          null
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          width: double.tryParse(
                                                  "${snapshot.data!.docs[index]['message'].length}")! *
                                              40,
                                          height: 70,
                                          decoration: const BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              )),
                                          child: Center(
                                              child: GridTile(
                                            header: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Text(
                                                  "${snapshot.data!.docs[index]['myname']}",
                                                  style: const TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Text(
                                                    "${snapshot.data!.docs[index]['message']}",
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                    ))),
                                            footer: Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 6),
                                                child: Text(
                                                  "${snapshot.data!.docs[index]['messagetime']}",
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
                                        child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: GridTile(
                                              child: Align(
                                                alignment: Alignment.bottomLeft,
                                                child: snapshot.data!
                                                                .docs[index]
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
                                                                              .docs[index]
                                                                          [
                                                                          "imagemessage"],
                                                                      tag: snapshot
                                                                          .data!
                                                                          .docs[index])));
                                                        },
                                                        child: Hero(
                                                          tag: snapshot.data!
                                                              .docs[index],
                                                          child: Image.network(
                                                            snapshot.data!
                                                                    .docs[index]
                                                                [
                                                                "imagemessage"],
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                      )
                                                    : null,
                                              ),
                                            ))))
                              ],
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  );
                });
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  sendmessage(
    chanelid,
    myname,
    message,
  ) async {
    await playesong();
    await FirebaseFirestore.instance
        .collection("groupe")
        .doc(chanelid)
        .collection("chats")
        .add({
      "message": message,
      "myname": myname,
      "time": DateTime.now().millisecondsSinceEpoch,
      "imagemessage": null,
      "messagetime": "${DateTime.now().hour}:${DateTime.now().minute}"
    });
  }

  Widget textfiledTowriteMessage() => Row(
        children: [
          IconButton(
            onPressed: () {
              sendmessageimagetogeroupe(
                  widget.docid, myname, ImageSource.gallery);
            },
            icon: const Icon(
              Icons.photo,
              color: Colors.white,
            ),
          ),
          IconButton(
              onPressed: () async {
                sendmessageimagetogeroupe(
                    widget.docid, myname, ImageSource.camera);
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
                  controller: controller,
                  minLines: 1,
                  maxLines: 10,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xffc7cec4),
                    hintText: "Type your Message",
                    suffixIcon: IconButton(
                        onPressed: () async {
                          if (controller.text.isNotEmpty &&
                              controller.text != " ") {
                            await sendmessage(
                              widget.docid,
                              myname,
                              controller.text,
                            );
                            controller.clear();
                          }
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
