import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdgsbymeetup/list_attendees.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_firebase_ui/flutter_firebase_ui.dart';
import 'package:gdgsbymeetup/dashboard.dart';

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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<FirebaseUser> _listener;
  FirebaseUser _currentUser;
  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }
  @override
  void dispose() {
    _listener.cancel();
    super.dispose();
  }

  void _checkCurrentUser() async {
    _currentUser = await _auth.currentUser();
    _currentUser?.getIdToken(refresh: true);

    _listener = _auth.onAuthStateChanged.listen((FirebaseUser user) {
      setState(() {
        _currentUser = user;
      });
    });
  }


  String barcode;
  List<dynamic> items;
  Dashboard dashboard=new Dashboard();
  ListAttendees listAttendees=new ListAttendees( new List<dynamic>() );

  void addOnTheSpot(){
    
  }

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

    if (_currentUser == null) {
      return new SignInScreen(
        title: "Surabaya Meetup",
        header: new Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: new Padding(
            padding: const EdgeInsets.all(16.0),
            child: new Text("Surabaya Meetup"),
          ),
        ),
        providers: [
          ProvidersTypes.google,
          ProvidersTypes.facebook,
          ProvidersTypes.email
        ],
      );
    } else {

      return DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              new GestureDetector(
                onTap: addOnTheSpot,
                child: Container(
                  margin: EdgeInsets.only(right:10.0),
                  child:new Icon(Icons.add_box),
                )
              )
              
            ],
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
              dashboard,
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
}
