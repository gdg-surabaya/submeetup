import 'package:flutter/material.dart';
import 'package:gdgsbymeetup/firebase_ui/signin_screen.dart';
import 'package:gdgsbymeetup/firebase_ui/utils.dart';
import 'package:gdgsbymeetup/pages/signins/email/email.dart';

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
//      appBar: new AppBar(
//        title: new Text(widget.title),
//        elevation: 0.0,
//      ),
      body:
//      new FirebaseEmailSignInButton(),
      new SignInScreen(title: widget.title, providers: [ProvidersTypes.google, ProvidersTypes.facebook, ProvidersTypes.email],),
    );
  }
}
