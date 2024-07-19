import 'package:dio/dio.dart';
import 'package:redux_saga/redux_saga.dart';
import 'package:teja/infrastructure/api/token_api.dart';
import 'token_actions.dart';

class TokenSaga {
  final TokenApi _tokenApi = TokenApi();

  Iterable<void> saga() sync* {
    yield TakeLatest(_fetchTokenSummary, pattern: FetchTokenSummaryAction);
  }

  Iterable<void> _fetchTokenSummary({required FetchTokenSummaryAction action}) sync* {
    final response = Result<Response>();
    yield Call(_tokenApi.fetchTokenSummary, args: [], result: response);

    if (response.value?.statusCode == 200) {
      final data = response.value?.data;
      final total = data['total'];
      final used = data['used'];
      final pending = data['pending'];
      final usedToday = data['usedToday'];
      yield Put(TokenSummaryReceivedAction(total, used, pending, usedToday));
    } else {
      yield Put(TokenSummaryFailedAction('Failed to fetch token summary.'));
    }
  }
}
