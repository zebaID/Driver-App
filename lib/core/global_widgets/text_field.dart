import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:id_driver/core/constants/constants.dart';
import 'package:id_driver/core/constants/size_config.dart';
import 'package:id_driver/helper/keyboard.dart';

class AppTextField extends StatelessWidget {
  TextEditingController controller;
  String labelText;
  bool? suffixIcon = false;
  double width = 0.9;
  String inputType;
  int? maxLenght = 500;
  bool? readOnly;
  Function? onTapText;
  Function? onChangeText;
  Function? onSubmittedText;
  Function? onEditingCompleted;
  bool? enableErr = false;
  TextCapitalization? textCapitalization;

  AppTextField(
      {Key? key,
      required this.width,
      required this.controller,
      required this.labelText,
      required this.inputType,
      this.maxLenght,
      this.readOnly,
      this.onTapText,
      this.onChangeText,
      this.suffixIcon,
      this.onSubmittedText,
      this.onEditingCompleted,
      this.enableErr,
      this.textCapitalization})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(fontSize: 15),
      obscureText: false,
      controller: controller,
      textCapitalization: textCapitalization ?? TextCapitalization.words,
      maxLength: maxLenght,
      onEditingComplete: () {
        if (onEditingCompleted != null) onEditingCompleted!();
      },
      onTap: () {
        if (onTapText != null) onTapText!();
      },
      onChanged: (text) {
        if (onChangeText != null) onChangeText!(text);
      },
      onSubmitted: (text) {
        KeyboardUtil.hideKeyboard(context);

        if (onSubmittedText != null) onSubmittedText!();
      },
      readOnly: readOnly ?? false,
      inputFormatters: inputType == "number"
          ? [
              FilteringTextInputFormatter.allow(
                  RegExp(r'^[+]*[(]{0,1}[0-9][+]{0,1}[0-9]*$')),
            ]
          : null,
      keyboardType:
          inputType == "text" ? TextInputType.text : TextInputType.number,
      decoration: InputDecoration(
          counterText: "",
          suffixIcon: suffixIcon != null
              ? suffixIcon == true
                  ? const Icon(Icons.keyboard_arrow_down)
                  : null
              : null,
          constraints: BoxConstraints(
              minHeight: 55.0, maxWidth: SizeConfig.screenWidth * width),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: kPrimaryColor.withOpacity(0.3)),
          ),
          border: const OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: kTextOutlineColor)),
          disabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: kTextOutlineColor),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: kTextOpacityColor),
          ),
          labelText: labelText,
          // labelStyle: TextStyle(color: kPrimaryColor),
          floatingLabelStyle: const TextStyle(color: kPrimaryColor),
          errorText: enableErr != null ? "Please enter valid input" : null),
    );
  }
}
