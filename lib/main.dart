
import 'package:distance_travel_log/screens/add_distance_log_page.dart';
import 'package:distance_travel_log/screens/distance_list_page.dart';
import 'package:distance_travel_log/themes/my_input_theme.dart';
import 'package:flutter/material.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

/// App Widget
class MyApp extends StatefulWidget {

  /// Initialize app
  MyApp();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// Widget
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //theme used for InputDecoration -- input_decoration_theme_widget.dart
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blueGrey,
        inputDecorationTheme: MyInputTheme().theme(),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),

      themeMode: ThemeMode.light,

      debugShowCheckedModeBanner: false,

      home: DistanceListPage(),
    );
  }
}