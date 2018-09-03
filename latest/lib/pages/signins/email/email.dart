import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gdgsbymeetup/pages/signins/email/email_view.dart';

class FirebaseEmailSignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new SizedBox.expand(
      child: new FlatButton.icon(
        color: Colors.red,
        onPressed: () => Navigator.push(context, new CupertinoPageRoute(builder: (_) => new FirebaseEmailSignInPage())),
        materialTapTargetSize: MaterialTapTargetSize.padded,
        icon: new Icon(
          Icons.mail,
          color: Colors.white,
          size: 24.0,
        ),
        label: new Text(
          'Sign in with Email',
          style: new TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
