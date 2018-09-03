import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'dart:async';
import '../utils.dart';
import '../config.dart';
import '../list_attendees.dart';
import './dashboard.dart';

import 'package:flutter/services.dart';
import './signin_screen.dart';

class MyHomePage extends StatefulWidget {
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
        if (message["data"] != null) {
          alert(context, "Push Message", message["data"]);
        }
      },
      onLaunch: (Map<String, dynamic> message) {
        print("onLaunch: $message");
        alert(context, "Push Message", message);
      },
      onResume: (Map<String, dynamic> message) {
        print("onResume: $message");
        alert(context, "Push Message", message);
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
  Dashboard dashboard = new Dashboard();
  ListAttendees listAttendees = new ListAttendees(new List<dynamic>());

  void addOnTheSpot() {
    Navigator.pushNamed(_ctx, "addAttendees").then((data) {
      // alert(context,"Notif","BACK ")
    });
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

  _confirmDialog(map) {
    print("confirm dialog");
    String title = "Confirmation";
    List<Widget> widgets = new List<Widget>();
    widgets.add(new Text("Id : " + map["id"].toString()));
    widgets.add(new Text("Nama : " + map["namaLengkap"].toString()));
    widgets.add(new Text("Gender : " + map["gender"].toString()));
    widgets.add(new Text("Pekerjaan : " + map["pekerjaan"].toString()));
    widgets.add(new Text("Company : " + map["perusahaaninstitusi"].toString()));

    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(title),
          content: new SingleChildScrollView(
            child: new ListBody(children: widgets),
          ),
          actions: <Widget>[
            new FlatButton(
                child: new Text('Confirm'),
                onPressed: () {
                  var json = {
                    "id": map["id"],
                    "email": map["emailAddress"],
                    "name": map["namaLengkap"],
                    "hash": map["hash"],
                    "check_in_time": DateTime.now().millisecondsSinceEpoch,
                  };
                  DatabaseReference attendeeCheckInRef = FirebaseDatabase()
                      .reference()
                      .child(nodeCheckIn)
                      .child("checkin_" + map["id"].toString());
                  attendeeCheckInRef.set(json);
                  // attendeeCheckInRef.setPriority(-1 * (DateTime.now().millisecondsSinceEpoch));
                  Navigator.of(context).pop();
                }),
            new FlatButton(
              child: new Text('Cancel'),
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

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      print("barcode " + barcode);
      print(fieldHash);
      FirebaseDatabase()
          .reference()
          .child(nodeRegistered)
          .orderByChild(fieldHash)
          .equalTo(barcode)
          .once()
          .then((DataSnapshot ds) {
        // if (ds.value.)
        // print("ds "+ds.key);
        // print(ds.value);
        if (ds.value != null) {
          // ds.value.forEach( (d,map){
          if (ds.value is List) {
            for (var i = 0; i < ds.value.length; i++) {
              var map = ds.value[i];
              // print(d);
              // print(map);
              if (map != null) {
                FirebaseDatabase()
                    .reference()
                    .child(nodeCheckIn +
                        "/" +
                        nodeCheckIn +
                        "_" +
                        map["id"].toString())
                    .once()
                    .then((DataSnapshot snap) {
                  if (snap != null && snap.value != null) {
                    alert(context, "Error", "Already Signed in");
                  } else {
                    _confirmDialog(map);
                  }
                });
              }
            }
          } else {
            var hashmap = ds.value;

            var map = hashmap.values.first;
            // print ("mapzzz");
            // print (map);
            if (map != null) {
              FirebaseDatabase()
                  .reference()
                  .child(nodeCheckIn +
                      "/" +
                      nodeCheckIn +
                      "_" +
                      map["id"].toString())
                  .once()
                  .then((DataSnapshot snap) {
                if (snap != null && snap.value != null) {
                  alert(context, "Error", "Already Signed in");
                } else {
                  _confirmDialog(map);
                }
              });
            }
          }
          // });//FOREACH
        } else {
          alert(context, "Error", "QR Code not valid");
        }
      });
      // setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        alert(context, "Warning", "Mohon setujui permission camera");
        // setState(() {
        //   this.barcode = 'The user did not grant the camera permission!';
        // });
      } else {
        alert(context, "Warning", "Unknown Error");
        // setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      alert(context, "Warning",
          "User returned using the 'back'-button before scanning anything");
      // setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      alert(context, "Warning", "Unknown Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    this._ctx = context;
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
      return new SignInPage(title: "Surabaya Meetup");
    } else {
      return DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            leading: new FlatButton(onPressed: (){
              showDialog(context: context, builder: (_){
                return new AlertDialog(
                  title: new Text("Sign Out"),
                  content: new Text("Are you sure to sign out?"),
                  actions: <Widget>[
                    new FlatButton(onPressed: () => Navigator.of(context).pop(), child: new Text("No")),
                    new FlatButton(onPressed: () async {
                      await _auth.signOut();
                      Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(builder: (_) => new MyHomePage()), (_) => false);
                    }, child: new Text("Yes")),
                  ],
                );
              });
            }, child: new Icon(Icons.exit_to_app, color: Colors.white,)),
            actions: <Widget>[
              new GestureDetector(
                onTap: addOnTheSpot,
                child: Container(
                  margin: EdgeInsets.only(right: 8.0),
                  child: new Icon(Icons.add_box),
                ),
              )
            ],
            title: new Text("Surabaya Meetup"),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.insert_chart)),
                Tab(icon: Icon(Icons.list)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              dashboard,
              listAttendees,
            ],
          ),
          floatingActionButton: new FloatingActionButton(
            onPressed: scan,
            tooltip: 'Scan Attendee QR Code',
            child: new Icon(Icons.camera_enhance),
          ),
        ),
      );
    }
  }
}
