import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Sendimage extends StatefulWidget {
  dynamic urlimage;
  dynamic tag;

  Sendimage({Key? key, required this.urlimage, required this.tag})
      : super(key: key);

  @override
  _ImageState createState() => _ImageState();
}

class _ImageState extends State<Sendimage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool isloading = false;

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
        body: Center(
      child: Hero(
        child: Image.network(widget.urlimage),
        tag: widget.tag,
      ),
    ));
  }
}
