import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final Function() onPressed;
  final String label;
  final Color color;

  CustomButton(
      {required this.onPressed, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(label),
      style: TextButton.styleFrom(
        primary: Colors.white,
        backgroundColor: color,
        textStyle: GoogleFonts.rubik(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
        fixedSize: Size(300, 60),
      ),
    );
  }
}

