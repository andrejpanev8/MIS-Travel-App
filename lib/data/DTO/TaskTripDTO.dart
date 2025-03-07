// ignore_for_file: file_names

import '../../service/interface/HasFilterProperties.dart';
import '../models/task_trip.dart';
import '../models/trip.dart';

class TaskTripDTO implements HasFilterProperties {
  late TaskTrip? taskTrip;
  late Trip? trip;

  TaskTripDTO({this.taskTrip, this.trip});

  factory TaskTripDTO.fromJson(Map<String, dynamic> json) {
    return TaskTripDTO(
      taskTrip:
          json['taskTrip'] != null ? TaskTrip.fromJson(json['taskTrip']) : null,
      trip: json['trip'] != null ? Trip.fromJson(json['trip']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (taskTrip != null) {
      data['taskTrip'] = taskTrip!.toJson();
    }
    if (trip != null) {
      data['trip'] = trip!.toJson();
    }
    return data;
  }

  @override
  DateTime get startTime => trip!.startTime;

  @override
  String get endCity => trip!.endCity;

  @override
  String get startCity => trip!.startCity;
}
