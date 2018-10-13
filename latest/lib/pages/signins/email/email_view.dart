import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdgsbymeetup/pages/signins/buttons.dart';

class FirebaseEmailSignInPage extends StatefulWidget {
  @override
  _FirebaseEmailSignInPageState createState() =>
      _FirebaseEmailSignInPageState();
}

class _FirebaseEmailSignInPageState extends State<FirebaseEmailSignInPage> {
  TextEditingController _controllerEmail = new TextEditingController();
  TextEditingController _controllerPassword = new TextEditingController();
  bool _isChecking = false;

  @override
  void dispose() {
    super.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Sign In with Email"),
        elevation: 0.0,
      ),
      body: new Stack(
        children: <Widget>[
          new Padding(
            padding: const EdgeInsets.all(16.0),
            child: new Column(
              children: <Widget>[
                new TextField(
                  controller: _controllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: new InputDecoration(
                    labelText: "Email",
                  ),
                  style: new TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).textTheme.display1.color),
                ),
                new TextField(
                  controller: _controllerPassword,
                  obscureText: true,
                  autocorrect: false,
                  decoration: new InputDecoration(labelText: "Password"),
                  style: new TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).textTheme.display1.color),
                ),
                new SizedBox(height: 24.0),
                new Container(
                  alignment: Alignment.centerLeft,
                  child: new InkWell(
                    child: new Text(
                      "Trouble signing in?",
                      style: Theme.of(context).textTheme.caption,
                    ),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
          new BottomPositionedButton(buttonText: "Login", onTap: (){
            final FirebaseAuth auth = FirebaseAuth.instance;

          }, isLoading: _isChecking,),
        ],
      ),
    );
  }
}
