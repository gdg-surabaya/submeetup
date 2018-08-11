import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gdgsbymeetup/list_attendees.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Surabaya Meetup'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;


  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String barcode;
  List<dynamic> items;
  ListAttendees listAttendees=new ListAttendees( new List<dynamic>() );

  Future<List<dynamic>> getData() async {
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

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    getData().then( (res){
      if (res.length>0){
        if (items==null){
          setState( (){
            items=res;
            listAttendees= new ListAttendees(items);
          });
        }
      }
    });


    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: new Text(widget.title),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.insert_chart)),
              Tab(icon: Icon(Icons.list)),
            ],
          ),
        ),
        body:TabBarView(
          children: [
            new Text(""),
            listAttendees,
          ],
        ),

        floatingActionButton: new FloatingActionButton(
          onPressed: scan,
          tooltip: 'Scan Attendee QR Code',
          child: new Icon(Icons.camera_enhance),
        ), // This trailing comma makes auto-formatting nicer for build methods.

      ),
    );
  }
}
