// ignore_for_file: prefer_const_constructors

import 'package:emotion/chat_screen.dart';
import 'package:emotion/components/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isHidden = true;
  late String username;
  late String password;
  bool showSpinner = false;
  late String email;

  final _auth = FirebaseAuth.instance;

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  // Function to show the alert dialog
  void _showAlertDialog(BuildContext context) {
    Alert(
        context: context,
        title: "RESET PASSWORD",
        content: TextField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            icon: Icon(Icons.email),
            labelText: 'Email',
          ),
          onChanged: (value) {
            email = value;
          },
        ),
        buttons: [
          DialogButton(
            onPressed: () async {
              try {
                await _auth.sendPasswordResetEmail(email: email);
              } catch (e) {
                print(e);
              }
              Navigator.pop(context);
            },
            child: Text(
              "SEND EMAIL",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("LOGIN"),
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Image.asset(
                      'images/logo.png',
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextField(
                    onChanged: (value) {
                      username = value;
                    },
                    decoration: InputDecoration(
                      icon: Icon(
                        FontAwesomeIcons.user,
                        size: 20,
                        color: Colors.black,
                      ),
                      hintText: "USERNAME",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    obscureText: _isHidden,
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: InputDecoration(
                      icon: Icon(
                        FontAwesomeIcons.key,
                        size: 20,
                        color: Colors.black,
                      ),
                      hintText: "PASSWORD",
                      suffixIcon: GestureDetector(
                        child: Icon(
                          Icons.visibility,
                          size: 20,
                        ),
                        onTap: () {
                          _togglePasswordView();
                        },
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 5,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 75,
                      left: 20,
                    ),
                    child: CustomButton(
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          final existingUser =
                              await _auth.signInWithEmailAndPassword(
                                  email: username, password: password);
                          if (existingUser != null) {
                            Navigator.pushNamed(context, ChatScreen.id);
                          }
                        } catch (e) {
                          print(e);
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      },
                      label: "LOGIN",
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    child: Text(
                      "FORGOT PASSWORD",
                      style: GoogleFonts.syncopate(
                        textStyle: TextStyle(
                          fontSize: 15,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    onTap: () {
                      _showAlertDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
