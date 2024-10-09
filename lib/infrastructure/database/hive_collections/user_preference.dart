import 'package:hive/hive.dart';
import 'package:teja/infrastructure/database/hive_collections/constants.dart';

part 'user_preference.g.dart'; // Run build_runner to generate this file

@HiveType(typeId: userPreferenceTypeId)
class UserPreference {
  static const String boxKey = 'user_preferences';

  @HiveField(0)
  late String theme; // 'light', 'dark', or 'system'

  @HiveField(1)
  late String selectedImageUrl; // URL of the selected image

  @HiveField(2)
  late double selectedImageUrlopacity; // Opacity value
}
