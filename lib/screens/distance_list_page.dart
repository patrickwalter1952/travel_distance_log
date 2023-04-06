

import 'package:flutter/material.dart';

import '../models/distance_travel_model.dart';
import '../services/database_service.dart';
import '../services/utils.dart';
import '../widgets/distance_log_tile.dart';
import 'add_distance_log_page.dart';

///
/// DistanceLogPage home page
///
class DistanceListPage extends StatefulWidget {
  const DistanceListPage({super.key});


  @override
  State<DistanceListPage> createState() => _DistanceListPageState();
}

class _DistanceListPageState extends State<DistanceListPage> {

  List<DistanceTravel> _distanceTravelList = [];

  @override
  void initState() {
    super.initState();
    _getDistanceTravelList();
  }

  ///
  /// get distance traveled
  ///
  Future<void> _getDistanceTravelList() async {
    final list = await DatabaseService.instance.getAllDistanceTravel();

    if (mounted) {
      setState(() => _distanceTravelList = list);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget> [
            const Flexible(
              flex: 2,
              child: Text('Travel Distance Log'),
            ),
            Flexible(
              flex: 1,
              child: Image.asset(
                "assets/images/truck_driver.png",
                fit: BoxFit.fill,
                height: 32,
              ),
            ),
          ],
        ),
      ),

      body: Container(
        height: 500,
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(border: Border.all()),

        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          // itemCount: 1 + _distanceTravelList.length,
          itemCount: _distanceTravelList.length,

          separatorBuilder: (_, __) => const Divider(),

          itemBuilder: (BuildContext context, int index) {
            final distTravel = _distanceTravelList[index];
            return DistanceLogTile(
              updateDistanceLog: _getDistanceTravelList,
              distanceTravel: distTravel,
            );
          },
        ),
      ),

      // Floating action buttons
      floatingActionButton: Row (

        mainAxisAlignment: MainAxisAlignment.end,

        children: <Widget> [
          const SizedBox(width: 20.0),

          //Add a new travel log entry
          FloatingActionButton(
            heroTag: null,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (_) => AddDistanceLogPage(updateDistanceLog: _getDistanceTravelList),
              ),
            ),
            child: const Icon(Icons.add),
          ),

          const SizedBox(width: 20.0),

          // Email selected user the current report (comma separated)
          FloatingActionButton(
            heroTag: null,
            onPressed: () {
              Utils.getDataFormatted().then((value) async {
                TextEditingController emailController = TextEditingController();
                String result =
                    await Utils.buildShowTextFieldDialog(context,emailController);

                if (result.toUpperCase() == "OK") {
                  setState(()  {
                    Utils.sendEmail(
                        context,
                        emailController.text,
                        "Distance Travel Log",
                        value
                    );
                  });
                }
              });
            },

            child: const Icon(Icons.email_outlined),
          ),

          const SizedBox(width: 20.0),

          // Write comma separated report to file
          FloatingActionButton(
            heroTag: null,
            onPressed: () {
              Utils.getDataFormatted().then((value) {
                setState(() {
                  Utils.writeToExternalFile(value).then((value) {
                    Utils.buildShowDialog(context,
                        "Output Data File Location",
                        value,
                        false);
                  });
                });
              });
            },

            child: const Icon(Icons.table_rows_sharp),
          ),

        ],
      ),

    );
  }

}
