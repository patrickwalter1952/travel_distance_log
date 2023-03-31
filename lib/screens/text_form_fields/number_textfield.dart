
import 'package:distance_travel_log/services/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberTextField extends StatefulWidget {
  NumberTextField({
  required this.fieldLabel,
  required this.fieldType,
  required this.onChanged,
  required this.editingController});

  final String fieldLabel;
  final String fieldType;
  final ValueChanged<String> onChanged;
  final TextEditingController editingController;

  @override
  State<NumberTextField> createState() => _NumberTextFieldState();
}

class _NumberTextFieldState extends State<NumberTextField> {

  String? _errorText;

  Widget build(BuildContext context) {

    return TextField(
      controller: widget.editingController,
      enabled: false,
      onChanged: (value) {
        setState(() {
          if (!value.isValidInt()) {
            _errorText = "Enter a valid number";
          } else if (!value.isValidPositiveInt()) {
            _errorText = "Enter a valid positive number";
          } else {
            _errorText = null;
            widget.onChanged(value);
          }
        });
      },

      keyboardType: const TextInputType.numberWithOptions(
        decimal: false,
        signed: false,
      ),

      maxLength: 10,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,

      //this decoration will merge with the theme set
      decoration: InputDecoration(
          labelText: widget.fieldLabel,
          // An empty helperText makes it so the filed does not
          // grow in height when an error is displayed
          helperText: "",

          errorText: _errorText,

          hintText: "Distance Traveled",

          //suffix widget only appears when field is populated
          suffix: Text(widget.fieldType),

      ),

    );
  }

}
