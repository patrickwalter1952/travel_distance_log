

import 'package:flutter/material.dart';

class DisabledField extends StatefulWidget {
  const DisabledField({Key? key}) : super(key: key);

  @override
  State<DisabledField> createState() => _DisabledFieldState();
}

class _DisabledFieldState extends State<DisabledField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      //this decoration will merge with the theme set
      decoration: const InputDecoration(
        enabled: false,
        labelText: "Disabled field",
        helperText: "",
        hintText: "Disabled",
      ),

    );
  }

}
