

import 'package:flutter/material.dart';
import 'package:distance_travel_log/services/string_extensions.dart';

class EmailField extends StatefulWidget {
  const EmailField({Key? key}) : super(key: key);

  @override
  State<EmailField> createState() => _EmailFieldState();
}

class _EmailFieldState extends State<EmailField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(

      keyboardType: TextInputType.emailAddress,

      validator: (value) {
        if (!value!.isValidEmail()) {
          return "Enter a valid Email";
        }
      },

      //this decoration will merge with the theme set
      decoration: const InputDecoration(
        labelText: "Email field",
        helperText: "",
        hintText: "email@test.com",
      ),

    );
  }

}
