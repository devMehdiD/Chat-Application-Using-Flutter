import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Infouser extends StatefulWidget {
  dynamic image;
  dynamic name;
  Infouser({Key? key, required this.image, required this.name})
      : super(key: key);

  @override
  _InfouserState createState() => _InfouserState();
}

class _InfouserState extends State<Infouser>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("${widget.name}"),
      ),

      // ignore: prefer_const_constructors
    );
  }
}
