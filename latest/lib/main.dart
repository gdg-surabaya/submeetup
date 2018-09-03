import 'package:flutter/material.dart';
import 'package:gdgsbymeetup/add_attendees.dart';
import './pages/home.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Surabaya Meetup',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Surabaya Meetup'),
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == "addAttendees") {
          return MaterialPageRoute(
            builder: (context) {
              return new AddAttendees();
            },
          );
        } else {
          // new MyHomePage(title: 'Surabaya Meetup');
        }
      },
    );
  }
}
