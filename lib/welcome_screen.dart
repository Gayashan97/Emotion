// ignore_for_file: prefer_const_constructors

import 'package:emotion/chat_screen.dart';
import 'package:emotion/components/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';
import 'package:emotion/registration_screen.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static const id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 5000),
      upperBound: 15,
    );

    _controller.forward();

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("HOME"),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/bg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'logo',
                  child: Image.asset(
                    'images/logo.png',
                    width: _controller.value * 10,
                    height: _controller.value * 10,
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedTextKit(
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    ColorizeAnimatedText(
                      "EMOTION",
                      textStyle: GoogleFonts.monoton(
                        textStyle: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      speed: Duration(milliseconds: 1000),
                      colors: [
                        Colors.pinkAccent,
                        Colors.blueAccent,
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 120,
                ),
                ZoomInLeft(
                  preferences: AnimationPreferences(
                    duration: Duration(milliseconds: 5000),
                  ),
                  child: CustomButton(
                    onPressed: () {
                      Navigator.pushNamed(context, LoginScreen.id);
                    },
                    label: "LOGIN",
                    color: Colors.blue,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ZoomInRight(
                  preferences: AnimationPreferences(
                    duration: Duration(milliseconds: 5000),
                  ),
                  child: CustomButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RegistrationScreen.id);
                    },
                    label: "REGISTER",
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
