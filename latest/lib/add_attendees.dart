import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:gdgsbymeetup/config.dart';
import 'package:gdgsbymeetup/utils.dart';

class AddAttendees extends StatefulWidget{
  @override
  AddAttendeesState createState() {
    // TODO: implement createState
    return AddAttendeesState();
  }
}
class AddAttendeesState extends State<AddAttendees>{
  var _formKey = GlobalKey<FormState>();
  // var state;
  // AddAttendees(this.state){

  // }
  // final _formKey = GlobalKey<FormState>();
  TextEditingController namaTextController=TextEditingController();
  TextEditingController emailTextController=TextEditingController();
  TextEditingController teleponTextController=TextEditingController();
  String gender="Pria";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    List<DropdownMenuItem<String>> genderList=new List<DropdownMenuItem<String>>();
    genderList.add(new DropdownMenuItem(value: "Pria",child: new Text("Pria")));
    genderList.add(new DropdownMenuItem(value: "Wanita",child: new Text("Wanita")));


    return new Scaffold(
      appBar: AppBar(
        title: new Text("Add Attendees"),
      ),
      body: new Card(
        margin: EdgeInsets.all(10.0),
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: new Form(
            
            key: _formKey,
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text("Nama"),
                TextFormField(
                  controller: namaTextController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                  },                  // style: TextStyle(),
                ),

                new Text(""),
                new Text("e-Mail"),
                TextFormField(
                  controller: emailTextController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                  },                  
                  // style: TextStyle(),
                ),

                new Text(""),
                new Text("Telepon"),
                TextFormField(
                  controller: teleponTextController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                  },                  
                  // style: TextStyle(),
                ),

                new Text(""),
                new Text("Gender"),
                DropdownButton(
                  value: gender,
                  items: genderList,
                  onChanged: (res){
                    setState((){
                      gender=res;
                    });
                  },
                ),

                new Text(""),                
                new RaisedButton(
                  child: new Text("Save"),
                  onPressed: (){
                    if (_formKey.currentState.validate()){
                      var jso={
                        "nama":namaTextController.text,
                        "email":emailTextController.text,
                        "telepon":teleponTextController.text,
                        "gender":gender,
                        "registrationTime": (DateTime.now().toUtc().millisecondsSinceEpoch)
                      };
                      DatabaseReference newDataRef=FirebaseDatabase().reference().child(node_on_the_spot).push();
                      String key=newDataRef.key;
                      newDataRef.set(jso ).then( (status){
                        alert(context,"Success","On the spot attendee has been saved successfully");
                      });
                      newDataRef.setPriority( -1* (DateTime.now().toUtc().millisecondsSinceEpoch));
                    }
                  },
                )

              ],
            ),
          ),
        ),
      )
    );
  }

}