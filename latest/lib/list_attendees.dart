import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListAttendees extends StatefulWidget{
  List<dynamic> items;
  ListAttendees(this.items){

  }
  @override
  ListAttendeesState createState() {
    // TODO: implement createState
    return new ListAttendeesState(this.items);
  }

}


class ListAttendeesState extends State<ListAttendees>{
  List<dynamic> items;
  ListAttendeesState(this.items){
    print("this.items");
    print(this.items);
  }
  //why dont we initialize in here?

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context,idx){

        return new Text(items[idx]["name"]);
      },
    );
  }

}