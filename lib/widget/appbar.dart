import 'package:flutter/material.dart';
import '../constant.dart';
import '../services/service.dart';
import 'popup.dart';

class AppBarWidget extends StatelessWidget {
  String title = "";
  // bool addbutton = false;
  bool menubutton = false;
  // bool uploadbutton = false;
  // bool downloadbutton = false;
  bool back = false;

  // final Function? onTapAdd;
  // final Function? onTapUpload;
  // final Function? onTapdownload;

  AppBarWidget(
      this.title,
      // this.addbutton,
      // this.onTapAdd,
      this.menubutton,
      this.back,
      // this.uploadbutton,
      // this.onTapUpload,
      // this.downloadbutton,
      // this.onTapdownload,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
          // color: BLUE,
          gradient: LinearGradient(
              colors: [
                PURPLE,
                PINK,
              ],
              begin: const FractionalOffset(0.2, 0.0),
              end: const FractionalOffset(0.5, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      (menubutton == true)
                          ? IconButton(
                              onPressed: () => Scaffold.of(context).openDrawer(),
                              icon: const Icon(
                                Icons.menu,
                                color: WHITE,
                              ),
                            )
                          // : (back == true)
                          //     ? IconButton(
                          //         onPressed: () {
                          // Get.back();
                          //         },
                          //         icon: const Icon(
                          //           Icons.arrow_back,
                          //           color: WHITE,
                          //         ),
                          //       )
                          : const SizedBox(
                              width: 40,
                            ),
                      // (back == true)
                      //     ? IconButton(
                      //         onPressed: () => () {
                      //           Get.back();
                      //         },
                      //         icon: const Icon(
                      //           Icons.arrow_back,
                      //           color: WHITE,
                      //         ),
                      //       )
                      //     : const SizedBox(),
                      Text(
                        title.toString(),
                        style: const TextStyle(color: WHITE),
                      ),
                    ],
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      // (uploadbutton == true)
                      //     ? Column(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         children: [
                      //           IconButton(
                      //             onPressed: () {
                      //               onTapUpload!.call();
                      //             },
                      //             icon: const Icon(
                      //               Icons.upload,
                      //               color: WHITE,
                      //             ),
                      //           ),
                      //         ],
                      //       )
                      //     : const SizedBox(),
                      // (downloadbutton == true)
                      //     ? Column(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         children: [
                      //           IconButton(
                      //             onPressed: () {
                      //               onTapdownload!.call();
                      //             },
                      //             icon: const Icon(
                      //               Icons.download,
                      //               color: WHITE,
                      //             ),
                      //           ),
                      //         ],
                      //       )
                      //     : const SizedBox(),
                      // (addbutton == true)
                      //     ? Column(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         children: [
                      //           IconButton(
                      //             onPressed: () {
                      //               onTapAdd!.call();
                      //             },
                      //             icon: const Icon(
                      //               Icons.add,
                      //               color: WHITE,
                      //             ),
                      //           ),
                      //         ],
                      //       )
                      //     : const SizedBox(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () async {
                              showMyDialog("", "Are you sure want to ", "Logout ", "Logout", () {
                                Service.logout();
                              });
                              // await Service.logout();
                            },
                            icon: const Icon(
                              Icons.power_settings_new_outlined,
                              color: WHITE,
                              // size: 18,
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
