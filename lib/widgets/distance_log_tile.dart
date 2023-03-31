

import 'package:distance_travel_log/models/distance_travel_model.dart';
import 'package:flutter/material.dart';

import '../screens/add_distance_log_page.dart';
import '../services/database_service.dart';

class DistanceLogTile extends StatelessWidget {
  final VoidCallback updateDistanceLog;
  final DistanceTravel distanceTravel;

  const DistanceLogTile({
    required this.updateDistanceLog,
    required this.distanceTravel,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key(distanceTravel.id.toString()),

      title: Text(
        distanceTravel.toStringForDisplay(),
        style: const TextStyle(
          fontSize: 16.0,
          decoration: TextDecoration.none,
        ),
      ),

      // subtitle: ,

      trailing: IconButton(
        icon: const Icon(Icons.delete),
        color: Colors.redAccent,

        onPressed: () {
          DatabaseService.instance.delete(distanceTravel.id!);
          updateDistanceLog();
          // Navigator.of(context).pop();
        },
      ),

      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => AddDistanceLogPage(
            updateDistanceLog: updateDistanceLog,
            distanceTravel: distanceTravel,
          ),
        ),
      ),

    );
  }
}
