
import 'package:distance_travel_log/services/string_extensions.dart';

class DistanceTravel {
  final int? id;
  final String date;
  final int startOdometer;
  final int endOdometer;
  final int distance;

  DistanceTravel ({
    this.id,
    required this.date,
    required this.startOdometer,
    required this.endOdometer,
    required this.distance,
  });

  Map<String, dynamic> toJson() => {
    'date': date,
    'startOdometer': startOdometer,
    'endOdometer': endOdometer,
    'distance': distance,
  };


  DistanceTravel copyWith({
    int? id,
    String? date,
    int? startOdometer,
    int? endOdometer,
    int? distance,
  }) {
    return DistanceTravel(
      id: id ?? this.id,
      date: date ?? this.date,
      startOdometer: startOdometer ?? this.startOdometer,
      endOdometer: endOdometer ?? this.endOdometer,
      distance: distance ?? this.distance,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'startOdometer': startOdometer,
      'endOdometer': endOdometer,
      'distance': distance,
    };
  }

  factory DistanceTravel.fromMap(Map<String, dynamic> map) {
    return DistanceTravel(
      id: map['id'] as int,
      date: map['date'] as String,
      startOdometer: map['startOdometer'] as int,
      endOdometer: map['endOdometer'] as int,
      distance: map['distance'] as int,
    );
  }

  @override
  String toString() {
    return toMap().entries.map((e) => e.value).toList().toString();
  }

  String toStringIdsAndValues() {
    String data = "";
    for (MapEntry<String, dynamic> item in toMap().entries) {
      data = "$data ${item.key}: ${item.value}";
    }
    return data;
  }

  List toList() {
    return toMap().entries.map((e) => e.value).toList();
  }

  String checkValidity() {
    String errorText = "";

    if (!date.isValidDate()) {
      errorText = "Date format is YYYY-MM-DD\n";
    }

    if (startOdometer <= 0) {
      errorText = "${errorText}Start OD is number greater than zero.\n";
    }

    if (endOdometer <= 0) {
      errorText = "${errorText}End OD is number greater than zero.\n";
    }

    if (endOdometer < startOdometer) {
      errorText = "${errorText}End OD must be greater than Start OD.\n";
    }

    if (distance <= 0) {
      errorText = "${errorText}Distance is number greater than zero.\n";
    }

    return errorText;
  }

  ///
  /// Get data for display
  ///
  String toStringForDisplay() {
    String data = "";
    for (MapEntry<String, dynamic> item in toMap().entries) {
      switch (item.key) {
        case "date": {
          data = "$data${item.value}";
        }
        break;
        case "startOdometer": {
          data = "$data  Start:${item.value}";
        }
        break;
        case "endOdometer": {
          data = "$data  End:${item.value}";
        }
        break;
        case "distance": {
          data = "$data  Distance:${item.value}";
        }
        break;

        default:
          break;
      }
    }
    return data;
  }

  ///
  /// Get data for output (comma separated)
  /// Skips the ID field
  ///
  String toStringCommaSeparated() {
    String data = "";

    for (MapEntry<String, dynamic> item in toMap().entries) {
      if (item.key.toUpperCase() != "ID") {
        data = "$data  ${item.value}, ";
      }
    }
    return data;
  }

}
