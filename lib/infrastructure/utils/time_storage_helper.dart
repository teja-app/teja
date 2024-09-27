import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:teja/infrastructure/database/hive_collections/notification_time_slot.dart';

class TimeStorage {
  late Box<TimeSlot> _box;

  Future<Map<String, TimeOfDay>> getAllTimeSlots() async {
    final box = Hive.box(TimeSlot.boxKey);
    final timeSlots = box.values.toList();

    // Ensure only TimeSlot objects are processed
    Map<String, TimeOfDay> timeSlotMap = {
      for (var timeSlot in timeSlots)
        if (timeSlot is TimeSlot) timeSlot.activity: timeSlot.timeOfDay,
    };

    return timeSlotMap;
  }

  Future<Map<String, bool>> getEnabledStatuses() async {
    final box = Hive.box(TimeSlot.boxKey);
    final timeSlots = box.values.toList();

    // Ensure only TimeSlot objects are processed
    Map<String, bool> enabledStatuses = {
      for (var timeSlot in timeSlots)
        if (timeSlot is TimeSlot) timeSlot.activity: timeSlot.enabled,
    };

    return enabledStatuses;
  }

  Future<void> addOrUpdateTimeSlots(List<TimeSlot> timeSlots) async {
    var box = Hive.box(TimeSlot.boxKey); // Ensure the box is initialized
    for (var timeSlot in timeSlots) {
      await box.put(timeSlot.activity, timeSlot); // Use activity as the key
    }
  }

  Future<void> clearTimeSlots() async {
    await Hive.box(TimeSlot.boxKey).clear();
  }

  Future<void> saveTimeSlot(String activity, TimeOfDay timeOfDay) async {
    var box = Hive.box(TimeSlot.boxKey);
    final timeSlot = TimeSlot()
      ..activity = activity
      ..timeOfDay = timeOfDay
      ..enabled = false; // Default to enabled
    await box.put(activity, timeSlot);
  }

  Future<void> saveEnabledStatus(String activity, bool isEnabled) async {
    print('Handling toggle for $activity: $isEnabled');

    var box = Hive.box(TimeSlot.boxKey);
    var timeSlot = box.get(activity);
    if (timeSlot != null && timeSlot is TimeSlot) {
      timeSlot.enabled = isEnabled;
      await box.put(activity, timeSlot); // Update the existing time slot
    }
  }

  Future<TimeSlot?> getTimeSlot(String activity) async {
    var box = Hive.box(TimeSlot.boxKey);
    var timeSlot = box.get(activity);
    return timeSlot is TimeSlot ? timeSlot : null;
  }
}
