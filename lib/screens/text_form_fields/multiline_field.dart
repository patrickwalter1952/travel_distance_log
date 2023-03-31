

import 'package:flutter/material.dart';


class MultilineField extends StatefulWidget {
  const MultilineField({Key? key}) : super(key: key);

  @override
  State<MultilineField> createState() => _MultilineFieldState();
}

class _MultilineFieldState extends State<MultilineField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Enter a value";
        }
      },

      //max lines visible
      maxLines: 4,

      //this decoration will merge with the theme set
      decoration: InputDecoration(
        // An empty helperText makes it si the filed does not
        // grow in height when an error is displayed
        helperText: "",

        hintText: "Multiline",

        label: Row(
          //make sure this is min so it does not cut off the top border completely
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.info_outline),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text("Labels can be a widget"),
            ),

          ],
        ),

      ),

    );
  }

}
