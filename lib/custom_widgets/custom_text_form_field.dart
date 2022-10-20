import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final bool? obscureText;
  final void Function()? onTap;
  final FormFieldValidator? validator;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;

  // ignore: use_key_in_widget_constructors
  const CustomTextFormField({
    this.controller,
    this.label,
    this.onTap,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText!,
          onTap: onTap,
          validator: validator,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: prefixIcon,
            border:   const OutlineInputBorder(),
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
