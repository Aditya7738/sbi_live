import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import '../constant.dart';

class DropDownWidget extends StatefulWidget {
  final String hinttext;
  final String errortext;
  final String selectedvalue;
  final bool isExpanded;
  bool isdropDown;
  final List<String> list;
  final String value;
  final TextEditingController? controller;
  final Widget icon;
  final Function? onTap;

  DropDownWidget({
    Key? key,
    this.hinttext = "",
    this.errortext = "",
    textColor,
    this.isExpanded = false,
    this.isdropDown = false,
    this.selectedvalue = "",
    this.onTap,
    this.list = const [],
    this.value = "",
    this.controller,
    this.icon = const SizedBox(),
  }) : super(key: key);

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  String? selectedvalue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
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
          errorStyle: const TextStyle(color: RED),
          fillColor: WHITE,
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        ),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(errorText: widget.errortext),
        ]),
        isExpanded: widget.isExpanded,
        hint: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Row(
            children: [
              widget.icon,
              const SizedBox(
                width: 10,
              ),
              Text(
                widget.hinttext,
                style: const TextStyle(color: GREY_DARK, fontSize: 12),
              ),
            ],
          ),
        ),
        style: const TextStyle(
          color: BLACK,
          fontSize: 14,
        ),
        value: selectedvalue,
        onChanged: (newValue) {
          setState(
            () {
              selectedvalue = newValue!;
              widget.controller!.text = selectedvalue!;
            },
          );
        },
        items: widget.list.map((value) {
          return DropdownMenuItem(
            value: value,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
              ),
              child: Text(value),
            ),
          );
        }).toList(),
      ),
    );
  }
}
