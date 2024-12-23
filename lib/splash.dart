import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constant.dart';
import 'controller/splash.dart';
// import 'splashcontroller.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SplashController splashController = Get.put(SplashController());

    // if (false
    //     //Platform.isAndroid
    //     ) {
    return PopScope(
      canPop: false,
      child:
          //  Scaffold(
          //   body: Center(
          //     child: Text('Hello World'),
          //   ),
          // ),

          Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: WHITE,
        body:
            // Center(
            //   child: Text('Hello World'),
            // ),

            SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Image.asset(
                        'assets/images/sbilogo.png',
                        width: 150,
                      ),
                    ),

                    // Center(
                    //   child: Text('Hello World'),
                    // ),
                  ],
                ),
              ),

              // Center(
              //   child: Text('Hello World'),
              // ),
            ],
          ),
        ),
      ),
    );

    // } else {
    //   return PopScope(
    //     canPop: false,
    //     child: CupertinoPageScaffold(
    //       resizeToAvoidBottomInset: false,
    //       backgroundColor: WHITE,
    //       child: SafeArea(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: <Widget>[
    //             Expanded(
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: <Widget>[
    //                   Center(
    //                     child: Image.asset(
    //                       'assets/images/sbilogo.png',
    //                       width: 150,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   );
    // }
  }
}
