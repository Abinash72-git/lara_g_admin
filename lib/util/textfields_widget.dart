import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors_const.dart';
import 'styles.dart';

class CustomTextFormField extends StatelessWidget {
  final String? labelText;
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final IconButton? suffixIcon;
  final Icon? preffixIcon;
  final VoidCallback? onPressedIcon;
  final String? Function(String?)? validator;
  final String Function(String)? onchanged;
  final void Function()? oncomplete;
  final TextEditingController controller;
  final bool read;
  final int? maxlines;
  final int? maxlength;
  final List<TextInputFormatter>? inputformat;
  final Color fillColor;
  final double borderRadius;
  final double border;

  CustomTextFormField({
    Key? key,
    required this.hintText,
    this.labelText,
    required this.obscureText,
    this.validator,
    this.onchanged,
    required this.controller,
    this.suffixIcon,
    this.onPressedIcon,
    required this.read,
    this.preffixIcon,
    this.oncomplete,
    this.keyboardType,
    this.maxlines,
    this.maxlength,
    this.inputformat,
    this.fillColor = AppColor.textfieldColor,
    this.borderRadius = 20,
    this.border = 2,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        validator: validator,
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputformat,
        obscureText: obscureText,
        maxLength: maxlength,
        maxLines: maxlines,
        onChanged: onchanged,
        readOnly: read,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(color: AppColor.mainColor, width: 0.5),
          ),
          filled: true,
          fillColor: fillColor,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: AppColor.mainColor, width: 0.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(color: AppColor.mainColor, width: 0.5),
          ),
          prefix: preffixIcon,
          suffix: suffixIcon,
          disabledBorder: InputBorder.none,
          hintText: hintText,
          hintStyle: Styles.textStyleMedium(color: AppColor.hintTextColor),
          contentPadding: const EdgeInsets.all(10),
        ),
        style: Styles.textStyleMedium(),
      ),
    );
  }
}



// TextFormField(
//         validator: validator,
//         maxLength: maxlength,
//         controller: controller,
//         keyboardType: keyboardType,
//         inputFormatters: inputformat,
//         onSaved: onSaved,
//         onEditingComplete: oncomplete,
//         maxLines: maxlines,
//         obscureText: obscureText!,
//         readOnly: read,
//         decoration: InputDecoration(
//           hintText: hintText,
//           hintStyle: Styles.textStyleMedium(color: AppColor.hintTextColor),
//           labelText: labelText,
//           suffixIcon: suffixIcon,
//           prefixIcon: preffixIcon,
//           isDense: true,
//           errorText: errorText,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide.none,
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide.none,
//           ),
//         ),
//       ),