import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  final String title;
  final Color color;

  const SignInPage({Key key, this.title, this.color = Colors.white,}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        elevation: 4.0,
      ),
    );
  }
}
