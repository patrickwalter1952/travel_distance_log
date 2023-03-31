

import 'package:distance_travel_log/services/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../table_calendars/calendar.dart';


class DateField extends StatefulWidget {
  const DateField({
    required this.initDateValue,
    required this.onChanged,
    required this.editingController});

  final String initDateValue;
  final ValueChanged<String> onChanged;
  final TextEditingController editingController;

  @override
  State<DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {

  String? _errorText;

  @override
  Widget build(BuildContext context) {
    DateTime myDateTime = DateTime.now();

    print("DateField: initDateValue = ${widget.initDateValue}");
    print("DateField: myDateTime = $myDateTime");

    return TextField(
      //initialValue:  dateValue,
      controller: widget.editingController,
      onChanged: (value) {
        setState(() {
          _errorText = null;
          if (value.isWhitespace()) {
            _errorText = "This is a required field";
          } else if (value.containsWhitespace()) {
            _errorText = "Date cannot contain white space";
          } else if (!value.isValidDate()) {
            _errorText = "Date format YYYY-MM-DD required";
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

      //this decoration will merge with the theme set
      decoration: InputDecoration(
        labelText: "Date field (YYYY-MM-DD)",
        // An empty helperText makes it so the filed does not
        // grow in height when an error is displayed
        helperText: "",

        errorText: _errorText,

        hintText: "Date",

        //suffixIcon is a great place to put an icon button
        suffixIcon: IconButton(
          // onPressed: () => setState(() {
          //   Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (_) =>
          //           Calendar(onChanged: (value) {
          //             widget.onChanged(value.replaceAll("-", "/"));
          //             print("date_field.dart == valueDate = $value");
          //           })));
          // }),

          onPressed: () async {
            myDateTime = (await showDatePicker(
              context: context,
              initialDate: myDateTime ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2035),
            ))!;

            setState(() {
              widget.editingController.text =
                  DateFormat('yyyy-MM-dd').format(myDateTime);
              widget.onChanged(widget.editingController.text);
            });
          },

          icon: const Icon(
            Icons.timer_outlined,
            color: Colors.blue,
          ),

        )

      ),

    );
  }
}
