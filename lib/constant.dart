// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';

import 'package:get/get.dart';

const Color GREY = Color(0xffECF0F2);
const Color GREY_DARK = Color(0xff8a94a6);
const Color GREY_LIGHTER = Color(0xfff6f7f8);
const Color BLUE = Colors.blue; //Color(0xff03b8f1);
const Color LightBLUE = Color.fromARGB(255, 242, 242, 245);
const Color WHITE = Color(0xffffffff);
const Color BLACK = Color(0xff000000);
const Color BUTTONCOLOR = Color(0xffB4B4BE);
const Color GREEN = Color(0xff81BC06);
const Color LIGHTGREEN = Color(0xffd0ffeb);
const Color ORANGE = Color(0xffFFBA08);
const Color PINK = Color.fromARGB(255, 173, 4, 60);
const Color LIGHTORANGE = Color.fromARGB(255, 236, 216, 169);
const Color RED = Color(0xffeb2a2f);
const Color LIGHTRED = Color(0xffffe7d3);
const Color PURPLE = Color.fromARGB(255, 105, 5, 122);

const Map<int, Color> COLOR = {
  50: Color.fromRGBO(161, 32, 64, .1),
  100: Color.fromRGBO(161, 32, 64, .2),
  200: Color.fromRGBO(161, 32, 64, .3),
  300: Color.fromRGBO(161, 32, 64, .4),
  400: Color.fromRGBO(161, 32, 64, .5),
  500: Color.fromRGBO(161, 32, 64, .6),
  600: Color.fromRGBO(161, 32, 64, .7),
  700: Color.fromRGBO(161, 32, 64, .8),
  800: Color.fromRGBO(161, 32, 64, .9),
  900: Color.fromRGBO(161, 32, 64, 1),
};
Text titleText(text, Color color, [align = TextAlign.center]) {
  return Text(text,
      textAlign: align,
      style: TextStyle(
        color: color,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ));
}

Text smallText(text, Color color,
    [FontWeight wt = FontWeight.normal, align = TextAlign.center]) {
  return Text(
    text,
    textAlign: (align == "") ? TextAlign.left : align,
    style: TextStyle(
      color: color,
      fontSize: 10,
      fontWeight: wt,
      overflow: TextOverflow.visible,
    ),
  );
}

Text buttontext(text, Color color, Color bgcolor, [align = TextAlign.center]) {
  return Text(
    text,
    textAlign: (align == "") ? TextAlign.center : align,
    style: TextStyle(
        color: color,
        backgroundColor: bgcolor,
        fontSize: 18,
        fontWeight: FontWeight.bold),
  );
}

Text normaltext(text, Color color,
    [FontWeight wt = FontWeight.normal, align = TextAlign.left]) {
  return Text(
    text,
    textAlign: (align == "") ? TextAlign.left : align,
    style: TextStyle(color: color, fontSize: 12, fontWeight: wt),
  );
}

flutterToastMsg(String txt) {
  return ScaffoldMessenger.of(Get.context!).showSnackBar(
    SnackBar(
      backgroundColor: PURPLE,
      duration: const Duration(seconds: 2),
      content: normaltext(
        txt,
        WHITE,
      ),
    ),
  );
}

loadingWidget() {
  return const SizedBox(
    height: 25,
    width: 25,
    child: CircularProgressIndicator(
      color: PURPLE,
      strokeWidth: 2,
    ),
  );
}

PopupMenuEntry<int> buildPopupMenuItem(
    String text, BuildContext context, int value) {
  return PopupMenuItem(
    value: value,
    child: Text(
      text,
      style: TextStyle(
          // fontSize: 14,
          color: (text == "Logout") ? RED : BLUE),
    ),
  );
}
