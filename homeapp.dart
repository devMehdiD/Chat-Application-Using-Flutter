import 'package:chatapp/pageapp/discussions.dart';
import 'package:chatapp/pageapp/groupe.dart';
import 'package:chatapp/shardservice.dart';
import 'package:chatapp/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'auth/methode.dart';
import 'pageapp/creategroups.dart';

class HomeApp extends StatefulWidget {
  const HomeApp({Key? key}) : super(key: key);

  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> with SingleTickerProviderStateMixin {
  dynamic myname;
  dynamic myurlimage;
  dynamic message;
  dynamic chatromid;
  getmyusetrname() async {
    var doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    await Shredservice.saveusername(doc['username']);
    myname = await Shredservice.getmyusername();
    await Shredservice.savesendbyimage("${doc['url']}");
    myurlimage = await Shredservice.getsendbyimage();
  }

  List members = [];
  List items = [FerstPage(), GroupView(), Groups()];
  int selecteditem = 0;
  Color? colorofnaviagtionbar = Colors.blue;
  @override
  void initState() {
    getmyusetrname();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: search(),
          elevation: 0,
          actions: [
            Padding(
                padding: EdgeInsets.only(top: 5, right: 5),
                child: myurlimage != null
                    ? CircleAvatar(
                        backgroundColor: Colors.blue,
                        backgroundImage: NetworkImage(myurlimage),
                      )
                    : const Icon(
                        Icons.person,
                        size: 30,
                      ))
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Log Out "),
                onTap: () {
                  try {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, "Login", (route) => false);
                  } catch (e) {
                    print(e);
                  }
                },
              )
            ],
          ),
        ),
        body: items.elementAt(selecteditem),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selecteditem,
          elevation: 0,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          items: const [
            BottomNavigationBarItem(
                label: "Discussions", icon: Icon(Icons.message)),
            BottomNavigationBarItem(
                label: "Groupe",
                //label: "Groups",
                icon: Icon(Icons.people_alt)),
            BottomNavigationBarItem(
                label: "Create Groupe",
                //label: "Groups",
                icon: Icon(Feather.edit_2)),
          ],
          onTap: (selcted) {
            setState(() {
              selecteditem = selcted;
            });
          },
        ));
  }

  Widget search() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        height: 50,
        child: TypeAheadFormField(
            suggestionsBoxDecoration: const SuggestionsBoxDecoration(),
            textFieldConfiguration: TextFieldConfiguration(
                style: TextStyle(color: Colors.white),
                controller: controller,
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    hintStyle: TextStyle(color: Colors.white),
                    hintText: "Search a Frends ...",
                    suffixIcon: Icon(
                      Icons.search,
                      size: 30,
                      color: Colors.white,
                    ))),
            onSuggestionSelected: (suggestion) {},
            itemBuilder: (buildContext, dynamic suggestoin) {
              return ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage("${suggestoin['url']}"),
                ),
                title: Text(suggestoin['username']),
                subtitle: Text(suggestoin['email']),
                trailing: ElevatedButton(
                    onPressed: () async {
                      if (suggestoin['username'] != myname) {
                        await Createchatrom(
                            suggestoin['username'],
                            suggestoin['userid'],
                            myurlimage,
                            suggestoin['url'],
                            myname);
                      } else {
                        return null;
                      }
                    },
                    child: const Text('Message')),
              );
            },
            suggestionsCallback: (patren) async {
              return await authentification().getuserbyname(patren);
            }),
      ),
    );
  }

  // ignore: non_constant_identifier_names

}
