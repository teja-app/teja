import 'package:dio/dio.dart';
import 'package:swayam/infrastruture/api_helper.dart';

class Feeling {
  final String feelingId;
  final String comment;
  final List<String> factors;

  Feeling({
    required this.feelingId,
    required this.comment,
    required this.factors,
  });

  Map<String, dynamic> toJson() => {
        'feeling_id': feelingId,
        'comment': comment,
        'factors': factors,
      };
}

class MoodLog {
  final String? id;
  final DateTime? timestamp;
  final int? moodRating;
  final String? comment;
  final List<Feeling>? moodLogFeelings;

  MoodLog({
    this.id,
    this.timestamp,
    this.moodRating,
    this.comment,
    this.moodLogFeelings,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp!.toIso8601String(),
        'mood_rating': moodRating,
        'comment': comment,
        'mood_log_feelings':
            moodLogFeelings!.map((feeling) => feeling.toJson()).toList(),
      };

  copyWith({required int moodRating}) {}
}

class MoodApi {
  final ApiHelper _apiHelper = ApiHelper();

  Future<Response> postMoodLog(MoodLog moodLog, String? authToken) async {
    const String url = '/mood';
    return _apiHelper.post(url, data: moodLog.toJson(), authToken: authToken);
  }

  void dispose() {
    _apiHelper.dispose();
  }
}
