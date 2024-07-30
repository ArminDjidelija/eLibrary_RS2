import 'package:flutter/material.dart';

class BaseMobileScreen extends StatefulWidget {
  String? title;
  Widget? widget;
  Widget appBarWidget = Text("");
  BaseMobileScreen(
      {super.key, this.title, this.widget, required this.appBarWidget});

  @override
  State<BaseMobileScreen> createState() => _BaseMobileScreenState();
}

class _BaseMobileScreenState extends State<BaseMobileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // leading: widget.appBarWidget,
          title: Text(widget.title.toString()),
          leading: Text(""),
          actions: [widget.appBarWidget!],
        ),
        body: widget.widget);
  }
}
