import 'package:redux/redux.dart';
import 'token_actions.dart';
import 'token_state.dart';

Reducer<TokenState> tokenReducer = combineReducers<TokenState>([
  TypedReducer<TokenState, TokenSummaryReceivedAction>(_tokenSummaryReceived),
  TypedReducer<TokenState, TokenSummaryFailedAction>(_tokenSummaryFailed),
]);

TokenState _tokenSummaryReceived(TokenState state, TokenSummaryReceivedAction action) {
  return state.copyWith(total: action.total, used: action.used, pending: action.pending, usedToday: action.usedToday);
}

TokenState _tokenSummaryFailed(TokenState state, TokenSummaryFailedAction action) {
  return state.copyWith(errorMessage: action.error);
}
