import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:gdgsbymeetup/config.dart';
import 'package:gdgsbymeetup/utils.dart';
class Dashboard extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              decoration: new BoxDecoration(
                  color: Colors.green,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(5.0),
                      topRight: const Radius.circular(5.0),
                      bottomLeft: const Radius.circular(5.0),
                      bottomRight: const Radius.circular(5.0)
                      )
              ),              
              // color: Colors.blue,
              height: 100.0,
              padding: EdgeInsets.all(5.0),
              margin: EdgeInsets.fromLTRB(10.0, 25.0, 5.0, 5.0),
              width: MediaQuery.of(context).size.width/2-15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Text("Check In",style: TextStyle(color: Colors.white,fontSize:18.0,fontWeight:FontWeight.bold)),
                  new Text(""),
                  StreamBuilder(
                    stream: FirebaseDatabase().reference().child(node_check_in).onValue,
                    builder: (BuildContext context, AsyncSnapshot<Event> snapshot){
                      // return new Text("asd");
                      // alert(context,"test",snapshot.hasData.toString());
                      if (snapshot.hasData && snapshot.data!=null){
                        if ( (snapshot.data.snapshot.value) is List ){
                          var map=(snapshot.data.snapshot.value) as List<dynamic>;
                          print("mapyy "+(map.length).toString());
                          // print(map);
                          if (map==null){
                            return new Text( "0" ,style: TextStyle(color: Colors.white,fontSize:25.0,fontWeight:FontWeight.bold));
                          }else
                            return new Text( (map.length).toString()+"" ,style: TextStyle(color: Colors.white,fontSize:25.0,fontWeight:FontWeight.bold));
                        }else{
                          var map=(snapshot.data.snapshot.value) as Map<dynamic,dynamic>;
                          print("mapz ");
                          print(map);
                          if (map==null){
                            return new Text( "0" ,style: TextStyle(color: Colors.white,fontSize:25.0,fontWeight:FontWeight.bold));
                          }else
                            return new Text( (map.keys.length).toString()+"" ,style: TextStyle(color: Colors.white,fontSize:25.0,fontWeight:FontWeight.bold));

                        }
                      }else{
                        return new Text( "0" ,style: TextStyle(color: Colors.white,fontSize:25.0,fontWeight:FontWeight.bold));
                      }
                    },
                  ),
                ],
              ),
            ),
            Container(
              // color: Colors.blue,
              decoration: new BoxDecoration(
                  color: Colors.blue[700],
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(5.0),
                      topRight: const Radius.circular(5.0),
                      bottomLeft: const Radius.circular(5.0),
                      bottomRight: const Radius.circular(5.0)
                      )
              ),              

              height: 100.0,
              padding: EdgeInsets.all(5.0),
              margin: EdgeInsets.fromLTRB(5.0, 25.0, 5.0, 5.0),
              width: MediaQuery.of(context).size.width/2-15,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Text("On The Spot",style: TextStyle(color: Colors.white,fontSize:18.0,fontWeight:FontWeight.bold)),
                  new Text(""),
                  StreamBuilder(
                    stream: FirebaseDatabase().reference().child(node_on_the_spot).onValue,
                    builder: (BuildContext context, AsyncSnapshot<Event> snapshot){
                      // return new Text("asd");
                      if (snapshot.hasData){
                        var map=(snapshot.data.snapshot.value) as Map<dynamic,dynamic>;                      
                        if (map==null){
                          return new Text( "0" ,style: TextStyle(color: Colors.white,fontSize:25.0,fontWeight:FontWeight.bold));
                        }else
                          return new Text( map.keys.length.toString()+"" ,style: TextStyle(color: Colors.white,fontSize:25.0,fontWeight:FontWeight.bold));
                        
                      }else{
                        return new Text( "0" ,style: TextStyle(color: Colors.white,fontSize:25.0,fontWeight:FontWeight.bold));
                      }
                    },
                  ),

                  // new Text("123",style: TextStyle(color: Colors.white,fontSize:25.0,fontWeight:FontWeight.bold))
                ],
              ),
            )

          ],
        ),

        // new Text(""),
        // new Container(
        //   margin:EdgeInsets.only(left:10.0),
        //   alignment: Alignment.centerLeft,
        //   child:
        //   new Text("Chart",style: TextStyle(fontWeight:FontWeight.bold,fontSize:15.0),),
        // ),

        new Text(""),
        new Container(
          margin:EdgeInsets.only(left:10.0),
          alignment: Alignment.centerLeft,
          child:
          new Text("Latest Checked In Users",style: TextStyle(fontWeight:FontWeight.bold,fontSize:15.0),),
        ),
        

        new Flexible(
          child: new FirebaseAnimatedList(
            // key: new ValueKey<bool>(_anchorToBottom),
            // key: new ValueKey<bool>(false),
            query: FirebaseDatabase().reference().child(node_check_in).orderByChild(field_check_in_time),
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
                      new Text(snapshot.value["name"], style: TextStyle(fontSize:17.0,fontWeight:FontWeight.bold),),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child : new Text(snapshot.value["email"],textAlign: TextAlign.end,)
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
  }
}