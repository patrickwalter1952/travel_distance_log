import 'package:distance_travel_log/services/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberField extends StatefulWidget {
  NumberField({
    required this.fieldLabel,
    required this.fieldType,
    this.initialValue = 0,
    this.isEnabled = true,
    required this.onChanged,
    required this.editingController
    ,
  });

  final String fieldLabel;
  final String fieldType;
  final int initialValue;
  final bool isEnabled;
  final ValueChanged<String> onChanged;
  final TextEditingController editingController;

  @override
  State<NumberField> createState() => _NumberFieldState();
}

class _NumberFieldState extends State<NumberField> {
  String? _errorText;

  Widget build(BuildContext context) {
    return TextFormField(
      // initialValue:  widget.initialValue.toString(),
      controller: widget.editingController,
      onChanged: (value) {
        setState(() {
          if (!value.isValidIntGreaterZero()) {
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
        enabled: widget.isEnabled,
        labelText: widget.fieldLabel,
        // An empty helperText makes it so the filed does not
        // grow in height when an error is displayed
        helperText: "",

        errorText: _errorText,

        hintText: "",

        //suffix widget only appears when field is populated
        suffix: Text(widget.fieldType),
      ),
    );
  }
}
