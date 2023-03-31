

import 'package:flutter/material.dart';

class TextFieldRow extends StatefulWidget {
  @override
  State<TextFieldRow> createState() => _TextFieldRowState();
}

class _TextFieldRowState extends State<TextFieldRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Flexible(
          child: TextFormField(
            decoration: const InputDecoration(
              helperText: "",
              hintText: "Row",
              labelText: "#1 ",
            ),
          ),
        ),

        Flexible(
          flex: 2,
          child: TextFormField(
            decoration: const InputDecoration(
              helperText: "",
              hintText: "Row",
              labelText: "#2 - 2X size",
            ),
          ),
        ),

        Flexible(
            flex: 3,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  helperText: "",
                  hintText: "Row1/Col11",
                  labelText: "#3A ",
                ),
              ),

              TextFormField(
                decoration: const InputDecoration(
                  helperText: "",
                  hintText: "Row1/Col12",
                  labelText: "#3B ",
                ),
              ),
            ],


        )
        ),
      ],


    );
  }
}
