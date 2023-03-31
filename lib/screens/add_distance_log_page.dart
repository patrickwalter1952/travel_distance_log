
import 'package:distance_travel_log/models/distance_travel_model.dart';
import 'package:distance_travel_log/screens/text_form_fields/date_field.dart';
import 'package:distance_travel_log/screens/text_form_fields/number_field.dart';
import 'package:flutter/material.dart';

import '../services/database_service.dart';
import '../services/utils.dart';

class AddDistanceLogPage extends StatefulWidget {

  final VoidCallback updateDistanceLog;
  final DistanceTravel? distanceTravel;

  const AddDistanceLogPage({
    required this.updateDistanceLog,
    this.distanceTravel,
  });

  @override
  _AddDistanceLogPageImpl createState() => _AddDistanceLogPageImpl();
}

class _AddDistanceLogPageImpl extends State<AddDistanceLogPage> {
  final _formKey = GlobalKey<FormState>();

  late DistanceTravel _distanceTravel;
  bool get _isEditing => widget.distanceTravel != null;

  int valueOdStart = 0;
  int valueOdEnd = 0;
  int valueOdDelta = 0;

  late TextEditingController editDateController;
  late TextEditingController editOdStartController;
  late TextEditingController editOdEndController;
  late TextEditingController deltaOdTextController;

  @override
  void initState() {
    super.initState();

    editDateController = TextEditingController(text: "");
    editOdStartController = TextEditingController(text: "");
    editOdEndController = TextEditingController(text: "");
    deltaOdTextController = TextEditingController(text: "");

    //init DistanceTravel
    if (_isEditing) {
      _distanceTravel = widget.distanceTravel!;

      editDateController.text = _distanceTravel.date;
      editOdStartController.text = _distanceTravel.startOdometer.toString();
      editOdEndController.text = _distanceTravel.endOdometer.toString();
      deltaOdTextController.text = _distanceTravel.distance.toString();
      valueOdStart = int.parse(editOdStartController.text);
      valueOdEnd = int.parse(editOdEndController.text);
      valueOdDelta = int.parse(deltaOdTextController.text);
    } else {
      _distanceTravel = DistanceTravel(
        date: DateTime.now().toString().substring(0, 10),
        startOdometer: 0,
        endOdometer: 0,
        distance: 0,
      );
      editDateController.text = _distanceTravel.date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          !_isEditing ? "Add Distance Travel" : "Update Distance Travel",
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(34, 24, 34, 36),

          children: [
            DateField(
              //init date with only yyyy-mm-dd
              initDateValue: DateTime.now().toString().substring(0, 10),
              onChanged: (value) {
                editDateController.text = value;
                print("HOME PAGE == valueDate = [$value]");
              },
              editingController: editDateController,
            ),

            NumberField(
                fieldLabel: "Start Odometer Mileage",
                fieldType: "Miles",
                onChanged: (value) {
                  setState(() {
                    valueOdStart = int.parse(value);
                    valueOdDelta = valueOdEnd - valueOdStart;
                    deltaOdTextController.text = valueOdDelta.toString();
                  });
                },
              editingController: editOdStartController,
            ),

            NumberField(
              fieldLabel: "End Odometer Mileage",
              fieldType: "Miles",
              onChanged: (value) {
                setState(() {
                  valueOdEnd = int.parse(value);
                  valueOdDelta = valueOdEnd - valueOdStart;
                  deltaOdTextController.text = valueOdDelta.toString();
                });
                // print("valueOdEnd = $valueOdEnd");
                // print("valueInitOdDelta = $valueInitOdDelta");
              },
              editingController: editOdEndController,
            ),

            NumberField(
              fieldLabel: "Distance",
              fieldType: "Miles",
              isEnabled: false,
              onChanged: (value) {
                setState(() {
                  valueOdDelta = int.parse(value);
                  deltaOdTextController.text = value;
                });
              },
              editingController: deltaOdTextController,
            ),


            SizedBox(
              child: ElevatedButton(
                onPressed: _submit,

                style: ElevatedButton.styleFrom(
                  backgroundColor: !_isEditing ? Colors.green : Colors.blue,
                  minimumSize: const Size.fromHeight(40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),

                child: Text(
                    !_isEditing ? "ADD Log Changes" : "UPDATE Log Changes"),
              ),
            )
          ]
              .map((child) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.0),
                    child: child,
                  ))
              .toList(),
        ),
      ),
    );
  }

  ///
  /// Submit the request to the database to add or update
  ///
  Future<void> _submit() async {
    _distanceTravel = _distanceTravel.copyWith(date: editDateController.text);
    _distanceTravel = _distanceTravel.copyWith(
        startOdometer: editOdStartController.text.isEmpty ? -1 :
        int.parse(editOdStartController.text));
    _distanceTravel = _distanceTravel.copyWith(
        endOdometer: editOdEndController.text.isEmpty ? -1 :
        int.parse(editOdEndController.text));
    _distanceTravel = _distanceTravel.copyWith(
        distance: deltaOdTextController.text.isEmpty ? -1 :
        int.parse(deltaOdTextController.text));

    print("_distanceTravel === ${_distanceTravel.toString()}");

    //TODO - validate that start < end and dist > 0
    String errorText = _distanceTravel.checkValidity();
    if (errorText.isNotEmpty) {
      var result = await Utils.buildShowDialog(context, "Invalid Data", errorText, true);
      return;
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (!_isEditing) {
        DatabaseService.instance.insert(_distanceTravel);
      } else {
        DatabaseService.instance.update(_distanceTravel);
      }

      widget.updateDistanceLog();

      Navigator.of(context).pop();
    }
  }
}
