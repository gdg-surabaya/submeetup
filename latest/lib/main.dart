import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:gdgsbymeetup/add_attendees.dart';
import 'package:gdgsbymeetup/config.dart';
import 'package:gdgsbymeetup/dashboard.dart';
import 'package:gdgsbymeetup/list_attendees.dart';
import 'package:gdgsbymeetup/utils.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_firebase_ui/flutter_firebase_ui.dart';
import 'package:firebase_database/firebase_database.dart';

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
      onGenerateRoute: (RouteSettings settings){
        if (settings.name == "addAttendees"){
          return MaterialPageRoute(
            builder: (context){
              return new AddAttendees();
            },
          );
        }else{
          // new MyHomePage(title: 'Surabaya Meetup');
        }
      },
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
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  StreamSubscription<FirebaseUser> _listener;
  FirebaseUser _currentUser;
  BuildContext _ctx;

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        // print("onMessage:");
        // print(message["data"]);
        // var msg=JSON.decode(message);
        if (message["data"]!=null){
          alert(context,"Push Message",message["data"]);
        }
      },
      onLaunch: (Map<String, dynamic> message) {
        print("onLaunch: $message");
        alert(context,"Push Message",message);
      },
      onResume: (Map<String, dynamic> message) {
        print("onResume: $message");
        alert(context,"Push Message",message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      _firebaseMessaging.subscribeToTopic("fcmadmin");
      // setState(() {
      //   _homeScreenText = "Push Messaging token: $token";
      // });
      // print(_homeScreenText);
    });
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
    Navigator.pushNamed(_ctx,"addAttendees");
  }

  // Future<List<dynamic>> getData() async {
  //   var response;
  //   try{
  //     response = await http.get(
  //       Uri.encodeFull("https://jsonplaceholder.typicode.com/users"),
  //       headers:{
  //         "Accept": "application/json"
  //       }
  //     );
      
  //     return JSON.decode(response.body);
  //   }catch(ex) {
  //     return new List<dynamic>();
  //   }

  // }


 


  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      print( "barcode "+barcode );
      print(field_hash);
      FirebaseDatabase().reference().child(node_registered).orderByChild(field_hash).equalTo(barcode).once().then( (DataSnapshot ds){
        // if (ds.value.)
        print("ds "+ds.key);
        print(ds.value);
        if (ds.value!=null){
          ds.value.forEach( (d,map){
            // var map=ds.value[ds.key];
            // print("map");
            // print(map);
            var json={
              "email" : map["email"],
              "name" : map["name"],
              "hash" : map["hash"],
              "check_in_time" : DateTime.now().millisecondsSinceEpoch,
            };
            DatabaseReference attendeeCheckInRef=FirebaseDatabase().reference().child(node_check_in).push();
            attendeeCheckInRef.set(json);
            attendeeCheckInRef.setPriority(-1 * (DateTime.now().millisecondsSinceEpoch)); 
          });
        }
      });
      // setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        alert(context,"Warning","Mohon setujui permission camera");
        // setState(() {
        //   this.barcode = 'The user did not grant the camera permission!';
        // });
      } else {
        alert(context,"Warning","Unknown Error");
        // setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException{
      alert(context,"Warning","User returned using the 'back'-button before scanning anything");
      // setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      alert(context,"Warning","Unknown Error");
    }
  }
  @override
  Widget build(BuildContext context) {
    this._ctx=context;
    // print("build");
    // getData().then( (res){
    //   if (res.length>0){
    //     if (items==null){
    //       setState( (){
    //         items=res;
    //         listAttendees= new ListAttendees(items);
    //       });
    //     }
    //   }
    // });

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
