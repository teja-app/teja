import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:teja/infrastructure/database/hive_collections/constants.dart';

part 'notification_time_slot.g.dart'; // Make sure to generate this file using build_runner

@HiveType(typeId: timeSlotTypeId) // Give a unique ID to this Hive model
class TimeSlot {
  static const String boxKey = 'time_box';

  @HiveField(0)
  late String activity;

  @HiveField(1)
  late String time; // Store as String to keep consistency with Hive

  @HiveField(2)
  late bool enabled = true; // Default to true

  TimeOfDay get timeOfDay {
    final parts = time.split(":");
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  set timeOfDay(TimeOfDay tod) {
    time = '${tod.hour}:${tod.minute}';
  }
}
