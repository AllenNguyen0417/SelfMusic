import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:first_firebase_project/services/database.dart';
import 'home.dart';

class SettingForms extends StatefulWidget {
  const SettingForms({Key? key}) : super(key: key);

  @override
  _SettingFormsState createState() => _SettingFormsState();
}

class _SettingFormsState extends State<SettingForms>{
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final singerController = TextEditingController();
  final coverController = TextEditingController();
  final urlController = TextEditingController();

  String title = '';
  String singer = '';
  String cover = '';
  String url = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Text(
            'Add Song',
            style: TextStyle(
              fontSize: 18.0
            ),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            controller: titleController,
            decoration: InputDecoration
                (
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: "Song",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
              ),
            validator: (val) => val!.isEmpty ? 'Please enter a music name' : null,
            onChanged: (val) => setState(() => title = val),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            controller: singerController,
            decoration: InputDecoration
              (
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Singer",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
            ),
            validator: (val) => val!.isEmpty ? 'Please enter a singer name' : null,
            onChanged: (val) => setState(() => singer = val),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            controller: coverController,
            decoration: InputDecoration
              (
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Image",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
            ),
            validator: (val) => val!.isEmpty ? 'Please enter a cover name' : null,
            onChanged: (val) => setState(() => cover = val),
          ),
          SizedBox(height: 20.0),
          TextFormField(
            controller: urlController,
            decoration: InputDecoration
              (
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "URL",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
            ),
            validator: (val) => val!.isEmpty ? 'Please enter a link of song' : null,
            onChanged: (val) => setState(() => url = val),
          ),
          SizedBox(height: 20.0),
          MaterialButton(
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
            elevation: 5.0,
            minWidth: MediaQuery.of(context).size.width,
            child: Text(
              'Add Song',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async{
              if(_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                // dynamic result = await FirebaseDatabase.instance.reference().child("playlist/${titleController.text}").set( // get UID instead
                dynamic result = await FirebaseDatabase.instance.reference().child("${getCurrentUID()}/${titleController.text}").set(
                    {
                      "title": titleController.text,
                      "singer": singerController.text,
                      "cover": coverController.text,
                      "url": urlController.text,
                    }
                ).then((value) {
                  showDialog(context: context, builder: (BuildContext context) {
                    // set up the buttons
                    Widget continueButton = FlatButton(
                      child: Text("Back!"),
                      onPressed:  () {
                        setState(() {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => Home()), (route) => false
                          );
                        });
                      },
                    );
                    return AlertDialog(
                      title: Text("Successfully added!"),
                      actions: [
                        continueButton,
                      ],
                    );
                  });
                }).catchError((error){
                  print("Failed to add" + error.toString());
                });
                if(result == null){
                  setState(() {});
                }
              }
            },
            color: Colors.pink[300],
          ),
        ],
      ),
    );
  }
}
