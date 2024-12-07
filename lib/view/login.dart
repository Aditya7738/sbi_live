import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:sbi/controller/splash.dart';
import 'package:sbi/services/local_auth_services.dart';
import '../constant.dart';
import '../services/service.dart';
import '../widget/button.dart';
import '../widget/textformfield.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    SplashController splashController = Get.put(SplashController());

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: WHITE,
      body: Obx(
        () {
          return Container(
            // alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            child: FormBuilder(
              key: splashController.fbKeyLogin,
              // autovalidate: true,
              child: Center(
                child: SingleChildScrollView(
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
                      // Text(
                      //   "Login",
                      //   style: TextStyle(
                      //     fontSize: Get.width / 18,
                      //     color: BLACK,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: Service.userNameController,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          // errorText: "Enter username",
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          prefixIcon: const Icon(
                            Icons.person,
                            color: GREY_DARK,
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: GREY),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: GREY),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: GREY),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: GREY),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: GREY),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: GREY),
                          ),
                          filled: true,
                          hintStyle: const TextStyle(
                            color: GREY_DARK,
                            fontSize: 12,
                          ),
                          errorStyle: const TextStyle(
                            color: RED,
                          ),
                          hintText: "Username",
                          fillColor: Colors.white,
                        ),

                        keyboardType: TextInputType.name,
                        // validator: validateMobile,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "Enter username"),
                        ]),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormFieldWidget(
                        hinttext: "Password",
                        controller: Service.passwordController,
                        errortext: "Enter password",
                        keyboardType: TextInputType.visiblePassword,
                        inputFormatter: r'[a-z A-Z 0-9 @.&,!#]',
                        // isPassword: true,
                        obscureText: !Service.showPass.value,
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: GREY_DARK,
                        ),
                        onTap: () {},
                      ),
                      // const SizedBox(height: 5),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   crossAxisAlignment: CrossAxisAlignment.end,
                      //   children: [
                      //     smallText(
                      //       "Forgot Password ?",
                      //       GREY_DARK,
                      //     ),
                      //     const SizedBox(
                      //       width: 5,
                      //     ),
                      //     InkWell(
                      //       onTap: () {},
                      //       child: smallText("Click Here", RED),
                      //     )
                      //   ],
                      // ),
                      (splashController.isLoading.value)
                          ? Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    loadingWidget(),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.only(
                                // left: Get.height / 30,
                                // right: Get.height / 30,
                                top: Get.height / 30,
                              ),
                              child: ButtonWidget(
                                onPressed: () {
                                  splashController.login();
                                  splashController.update();
                                },
                                text: "Login",
                                buttonBorder: PURPLE,
                                buttonColor: PURPLE,
                                textcolor: WHITE,
                              ),
                            ),
                      // SizedBox(height: 20),
                      // Container(
                      //   margin: EdgeInsets.only(
                      //     // left: Get.height / 30,
                      //     // right: Get.height / 30,
                      //     top: Get.height / 30,
                      //   ),
                      //   child: ButtonWidget(
                      //     onPressed: () {
                      //       // loginController.login();
                      //       // loginController.update();
                      //     },
                      //     text: "Forgot Password",
                      //     buttonBorder: GREEN,
                      //     buttonColor: GREEN,
                      //     textcolor: WHITE,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
