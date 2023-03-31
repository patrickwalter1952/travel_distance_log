

import 'package:flutter/material.dart';
import 'package:distance_travel_log/services/string_extensions.dart';

class PasswordField extends StatefulWidget {
  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {

  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value!.isWhitespace()) {
          return "This is a required field";
        }

        if (value!.containsWhitespace()) {
          return "Password cannot contain white space";
        }

      },

      obscureText: obscurePassword,
      keyboardType: TextInputType.visiblePassword,
      //this decoration will merge with the theme set
      decoration: InputDecoration(
        labelText: "Password field",
        // An empty helperText makes it si the filed does not
        // grow in height when an error is displayed
        helperText: "",

        hintText: "Password",

        //suffixIcon is a great place to put an icon button
        suffixIcon: IconButton(
          onPressed: () => setState(() {
            obscurePassword = !obscurePassword;
          }),

          icon: Icon(
            obscurePassword ? Icons.visibility : Icons.visibility_off,
            color: Colors.blue,
          ),

        )

      ),

    );
  }
}
