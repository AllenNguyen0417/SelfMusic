import 'package:first_firebase_project/screens/authenticate/sign_in.dart';
import 'package:first_firebase_project/services/auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {

  final toggleView;
  const Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>(); // Flutter built-in validation
  String email = '';
  String password = '';
  String error = '';
  String name = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.pink[100],
        elevation: 0.0,
        centerTitle: false,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0 ),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            'Create new',
                            style: TextStyle(
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold,
                            )

                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            'account!',
                            style: TextStyle(
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold,
                            )

                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 70.0),
              // TextFormField(
              //   decoration: InputDecoration
              //     (
              //       contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              //       hintText: "Full Name",
              //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
              //   ),
              //   validator: (val) => val!.isEmpty ? 'Enter an email' : null,
              //   onChanged: (val){
              //   setState(() => name = val);
              // },
              //
              // ),
              // SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration
                  (
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintText: "Username",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                ),
                validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                onChanged: (val){
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration
                  (
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintText: "Password",
                    border:  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                ),
                obscureText: true,
                validator: (val) => val!.length < 6  ? 'Enter a password with at least 6 characters' : null,
                onChanged: (val){
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 20.0),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
                elevation: 5.0,
                minWidth: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                onPressed: () async {
                  if(_formKey.currentState!.validate()){
                    _formKey.currentState!.save();
                    dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                    if(result == null){
                      setState(() => error = ('Please enter a valid email'));
                    }
                    else {
                      showDialog(context: context, builder: (BuildContext context) {
                        // set up the buttons

                        Widget continueButton = FlatButton(
                          child: Text("Go to Sign In"),
                          onPressed:  () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => SignIn(toggleView: null)), (route) => false
                            );
                          },
                        );
                        return AlertDialog(
                          title: Text("Register Successful!"),
                          actions: [
                            continueButton,
                          ],
                        );
                      });
                    }
                  }
                },
                color: Colors.pink[300],
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
