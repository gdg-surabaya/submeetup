import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// class ListAttendees extends StatefulWidget{
//   List<dynamic> items;
//   ListAttendees(this.items){

//   }
//   @override
//   ListAttendeesState createState() {
//     // TODO: implement createState
//     return new ListAttendeesState(this.items);
//   }

// }


// class ListAttendeesState extends State<ListAttendees>{

  
class ListAttendees extends StatelessWidget{
  List<dynamic> items;
  // ListAttendeesState(this.items){
  ListAttendees(this.items){
    print("this.items");
    print(this.items);
  }
  //why dont we initialize in here?

  Future<List<dynamic>> getData(BuildContext context) async {
    var response;
    try{
      response = await http.get(
        Uri.encodeFull("https://jsonplaceholder.typicode.com/users"),
        headers:{
          "Accept": "application/json"
        }
      );
      
      return JSON.decode(response.body);
    }catch(ex) {
      return new List<dynamic>();
    }

  }
  TextEditingController msgController=new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final FirebaseAuth _auth = FirebaseAuth.instance;

    GlobalKey key=new GlobalKey();

    DatabaseReference chatRef=FirebaseDatabase().reference().child("chats");
    return Column(
      children: <Widget>[
        new Row(
          children: <Widget>[
            Expanded(
              child: new TextField(
                controller: msgController,
              ),
            ),
            RaisedButton(
              child: new Text("Send"), onPressed: () {
                _auth.currentUser().then((user){
                  String msg=msgController.text;
                  String mykey=chatRef.push().key;
                  FirebaseDatabase().reference().child("users/"+user.uid).once().then( (snapshot){
                    chatRef.child(mykey).set({
                      'message':msg,
                      'uid':user.uid,
                      'username':"" 
                    });
                    chatRef.child(mykey).setPriority(-1 * (DateTime.now().millisecondsSinceEpoch)); 

                  });
                });
              },
            )
          ],
        ),
        new Flexible(
          child: new FirebaseAnimatedList(
            key:key,
            // key: new ValueKey<bool>(_anchorToBottom),
            // key: new ValueKey<bool>(false),
            query: FirebaseDatabase().reference().child("chats").orderByPriority(),
            // reverse: _anchorToBottom,
            // sort: _anchorToBottom  
            //     ? (DataSnapshot a, DataSnapshot b) => b.key.compareTo(a.key)
            //     : null,
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
                  // print("indez "+index.toString());
              return new SizeTransition(
                sizeFactor: animation,
                
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding:EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(snapshot.value["uid"], style: TextStyle(fontSize:17.0,fontWeight:FontWeight.bold),),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child : new Text(snapshot.value["message"],textAlign: TextAlign.end,)
                      ),
                      new Divider()
                      // new Text(snapshot.value["email"],textAlign: TextAlign.end,)                      
                    ],
                  ),
                )
              );
            },
          ),
        ),
      ],
    );
    // return StreamBuilder(
    //   stream:chatRef.onValue,
    //   builder: (BuildContext context, AsyncSnapshot snapshot) {
    //     if (snapshot.hasData){
    //       items=snapshot.data;
    //       return ListView.builder(
    //         itemCount: items.length,
    //         itemBuilder: (context,idx){

    //           return new Container(
    //             padding:EdgeInsets.fromLTRB(10.0,5.0,10.0,5.0),
    //             child: new Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: <Widget>[
    //                 new Text(items[idx]["name"], style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.0)),
    //                 new Wrap(
    //                   children: <Widget>[
    //                     new Container(
    //                       margin: EdgeInsets.all(5.0),
    //                       child: new Chip(
                          
    //                         label: new Text(items[idx]["username"]),
    //                       ),

    //                     ),
    //                     new Container(
    //                       margin: EdgeInsets.all(5.0),
    //                       child: new Chip(
                          
    //                         label: new Text(items[idx]["email"]),
    //                       ),

    //                     ),
    //                     new Container(
    //                       margin: EdgeInsets.all(5.0),
    //                       child: new Chip(
                          
    //                         label: new Text(items[idx]["website"]),
    //                       ),

    //                     ),

    //                   ],
    //                 )
    //               ],
    //             )
    //           );
    //         },
    //       );
    //     }else{
    //       return new Text("loading data");
    //     }
    //   },
    // );

  }

}