import 'dart:async';
import 'package:flutter/material.dart';

Future<Null> alert(context,title,content) async {
  return showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return new AlertDialog(
        title: new Text(title),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new Text(content),
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
              // Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}   