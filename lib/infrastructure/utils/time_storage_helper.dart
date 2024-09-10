import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

class TimeStorage {
  static const boxName = 'time_box';

  Future<void> saveTimeSlot(String activity, TimeOfDay timeOfDay) async {
    final box = Hive.box(boxName);
    await box.put('${activity}_time', timeOfDay.toString());
  }

  Future<void> saveEnabledStatus(String activity, bool isEnabled) async {
    final box = Hive.box(boxName);
    await box.put('${activity}_enabled', isEnabled);
  }

  Future<Map<String, TimeOfDay>> getTimeSlots() async {
    final box = Hive.box(boxName);
    final Map<String, TimeOfDay> timeSlots = {};
    for (var key in box.keys) {
      if (key != null && key is String && key.endsWith('_time')) {
        final timeString = box.get(key);
        final cleanTimeString =
            timeString.replaceAll('TimeOfDay(', '').replaceAll(')', '');
        final timeOfDayParts = cleanTimeString.split(":");
        final hour = int.parse(timeOfDayParts[0]);
        final minute = int.parse(timeOfDayParts[1]);
        timeSlots[key.replaceFirst('_time', '')] =
            TimeOfDay(hour: hour, minute: minute);
      }
    }
    return timeSlots;
  }

  Future<Map<String, bool>> getEnabledStatuses() async {
    final box = Hive.box(boxName);
    final Map<String, bool> enabledStatuses = {};
    for (var key in box.keys) {
      if (key != null && key is String && key.endsWith('_enabled')) {
        final isEnabled = box.get(key);
        enabledStatuses[key.replaceFirst('_enabled', '')] = isEnabled ?? false;
      }
    }
    return enabledStatuses;
  }
}
