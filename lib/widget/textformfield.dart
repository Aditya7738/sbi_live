// ignore_for_file: must_be_immutable, unused_local_variable, body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constant.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../services/service.dart';

class TextFormFieldWidget extends StatefulWidget {
  final String hinttext;
  final TextEditingController? controller;
  final bool readonly;
  final Function? onTap;
  final String errortext;
  final String inputFormatter;
  final int maxline;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget prefixIcon;
  final bool? isPassword;
  final bool isContactNo;
  const TextFormFieldWidget({
    Key? key,
    this.hinttext = "",
    textColor,
    this.controller,
    this.readonly = false,
    this.onTap,
    this.errortext = "",
    this.inputFormatter = "",
    this.maxline = 1,
    this.keyboardType,
    this.obscureText = false,
    this.isContactNo = false,
    this.prefixIcon = const SizedBox(),
    this.isPassword = false,
  }) : super(key: key);

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  bool showPassfield = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: BLUE,
      readOnly: widget.readonly,
      controller: widget.controller,
      textCapitalization: TextCapitalization.words,
      textAlign: TextAlign.left,
      enabled: true,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          prefixIcon: widget.prefixIcon,
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
          suffixIcon: (widget.isPassword == true)
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      Service.showPass.value = !Service.showPass.value;
                    });
                  },
                  icon: (Service.showPass.value == true)
                      ? Icon(
                          Icons.visibility,
                          color: BLUE,
                        )
                      : Icon(
                          Icons.visibility_off,
                          color: BLUE,
                        ))
              : const SizedBox(),
          hintText: widget.hinttext,
          fillColor: Colors.white,
          errorStyle: TextStyle(
            color: RED,
          )),
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: widget.errortext),
      ]),
      onTap: () {
        widget.onTap!.call();
      },
    );
  }
}

String? validateEmail(String? value) {
  if (value != null) {
    if (value.length > 5 && value.contains('@') && value.endsWith('.com')) {
      return null;
    }
    return 'Enter email id';
  }
  return null;
}

String? validateMobile(String? value) {
  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = RegExp(pattern);
  if (value!.isEmpty) {
    return 'Please enter mobile number';
  } else if (!regExp.hasMatch(value)) {
    return 'Please enter valid mobile number';
  }
  return null;
}
