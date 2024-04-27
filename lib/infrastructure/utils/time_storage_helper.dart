import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

class TimeStorage {
  static const _boxName = 'time_box';

  Future<void> saveTimeSlot(String activity, TimeOfDay timeOfDay) async {
    final box = await Hive.openBox(_boxName);
    await box.put(activity, timeOfDay.toString());
  }

  Future<Map<String, TimeOfDay>> getTimeSlots() async {
    try {
      final box = await Hive.openBox(_boxName);
      final Map<String, TimeOfDay> timeSlots = {};
      for (var key in box.keys) {
        if (key != null && key is String) {
          final timeString = box.get(key);

          if (timeString != null) {
            final cleanTimeString =
                timeString.replaceAll('TimeOfDay(', '').replaceAll(')', '');
            final timeOfDayParts = cleanTimeString.split(":");
            final hour = int.parse(timeOfDayParts[0]);
            final minute = int.parse(timeOfDayParts[1]);
            timeSlots[key] = TimeOfDay(hour: hour, minute: minute);
          }
        }
      }
      return timeSlots;
    } catch (e) {
      print('Error getting time slots: $e');
      rethrow;
    }
  }
}
