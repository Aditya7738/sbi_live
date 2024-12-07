import 'package:flutter/material.dart';
import '../constant.dart';

class ButtonWidget extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final double? width;
  final Color? buttonColor;
  final Color buttonBorder;
  final double? buttonHeight;
  final Color? textcolor;
  const ButtonWidget({
    Key? key,
    required this.onPressed,
    required this.text,
    this.width,
    this.buttonColor = BUTTONCOLOR,
    this.buttonBorder = BUTTONCOLOR,
    this.buttonHeight,
    this.textcolor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: buttonColor,
          side: BorderSide(color: buttonBorder),
        ),
        onPressed: () {
          onPressed.call();
        },
        child: Text(text,
            style: TextStyle(
              color: textcolor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            )),
      ),
    );
  }
}
