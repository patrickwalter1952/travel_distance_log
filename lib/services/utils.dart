
import 'dart:io';

import 'package:distance_travel_log/services/string_extensions.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:path_provider/path_provider.dart';

import '../models/distance_travel_model.dart';
import 'database_service.dart';

class Utils {
  static final GlobalKey<ScaffoldMessengerState>  messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBarError(String? text) {
    if (text == null) return;

    final snackBar = SnackBar(content: Text(text), backgroundColor: Colors.red);

    messengerKey.currentState?.removeCurrentSnackBar();
    messengerKey.currentState?.showSnackBar(snackBar);
  }

  static showSnackBarInfo(String? text) {
    if (text == null) return;

    final snackBar = SnackBar(content: Text(text), backgroundColor: Colors.green);

    messengerKey.currentState?.removeCurrentSnackBar();
    messengerKey.currentState?.showSnackBar(snackBar);
  }

  ///
  /// Password must contain one digit from 1 to 9,
  /// one lowercase letter, one uppercase letter,
  /// one special character (~`@#\$%^&*()-_+=), no space,
  /// and it must be at least 8 characters long.
  ///
  static bool isPasswordValid(String? password) {
    const String pwdRegEx = "(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[~@#%^&_+])";
    // final int minPwLength = 6;
    if (password == null || password.isEmpty || password.contains(' ')) {
      return false;
    }
    RegExp regex = RegExp(pwdRegEx);
    return regex.hasMatch(password);
    // return password.length < minPwLength;
  }

  ///
  /// Build and Show Dialog
  ///
  static Future<dynamic> buildShowDialog(
      BuildContext context,
      String title,
      String showText,
      bool isError) {

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        backgroundColor: isError ? Colors.redAccent : Colors.blueGrey,
        content: Text(
          showText,
        ),

        actions: [
          TextButton(
            child: const Text(
              'OK',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            onPressed: () => Navigator.pop(context, 'OK'),
          ),
        ],
      ),
    );
  }

  ///
  /// Build and Show Text Field Dialog
  ///
  static Future<dynamic> buildShowTextFieldDialog(
      BuildContext context,
      TextEditingController textFieldController) async {

    String email = "";

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(

        title: const Text("Enter Email Address"),

        content: TextField(
          controller: textFieldController,
        ),

        actions: <Widget> [
          TextButton(
            child: const Text(
              'OK',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            onPressed: () {
              //textFieldController has the value
              if (textFieldController.text.isValidEmail()) {
                Navigator.pop(context, 'OK');
                return;
              }
              var result = buildShowDialog(
                  context, "Invalid Email", "The email: ${textFieldController.text} is invalid", true);

            }
          ),
          TextButton(
              child: const Text(
                'CANCEL',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),

              onPressed: () {
               Navigator.pop(context, 'CANCEL');
              },
          ),
        ],
      ),
    );
  }

  ///
  /// send data as an email
  ///
  static sendEmail(
      BuildContext context,
      String emailTo,
      String emailSubject,
      String emailBody
      // String emailCc,
      // String attachments
      )  async {

    final Email email = Email(
      subject: emailSubject,
      recipients: [emailTo],
      body: emailBody,
      // cc: [emailCc],
      // attachmentPaths: [attachments],
    );

    await FlutterEmailSender.send(email);
  }

  ///
  /// write to external data file
  ///
  static Future<String> writeToExternalFile(String data) async {
    final file = await _getFile();
    print(">>>>> WRITING TO PATH: ${file.toString()}");

    file.writeAsString(data);

    return file.toString();
  }

  static Future<String> getDataFormatted() async {

    final list = await DatabaseService.instance.getAllDistanceTravel();

    String data = _getTitleCommaSeparated();
    for(DistanceTravel item in list) {
      data = "$data${item.toStringCommaSeparated()}\n";
    }

    return data;
  }

  static Future<File> _getFile() async {
    final dirPath = await _getPath();
    final filePath = "$dirPath/DistanceTravelLog.txt";
    return File(filePath);
  }

  static Future<String> _getPath() async {
    Directory? directory = Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationSupportDirectory(); //FOR iOS

    //Check if external storage not available. If not available use
    //internal applications directory
    directory ??= await getApplicationDocumentsDirectory();

    return directory.path;
  }

  ///
  /// Get title comma separated
  ///
  static String _getTitleCommaSeparated() {
    String data = "Date, Start Odometer, End Odometer, Distance\n";
    return data;
  }


}