import 'package:redux/redux.dart';
import 'package:teja/domain/redux/visions/vision_action.dart';
import 'package:teja/domain/redux/visions/vision_state.dart';

Reducer<VisionState> visionReducer = combineReducers<VisionState>([
  TypedReducer<VisionState, VisionUpdateInProgressAction>(_visionUpdateInProgress),
  TypedReducer<VisionState, VisionUpdateSuccessAction>(_visionUpdateSuccess),
  TypedReducer<VisionState, VisionUpdateFailedAction>(_visionUpdateFailed),
]);

VisionState _visionUpdateInProgress(VisionState state, VisionUpdateInProgressAction action) {
  return state.copyWith(isLoading: true, errorMessage: null);
}

VisionState _visionUpdateSuccess(VisionState state, VisionUpdateSuccessAction action) {
  return state.copyWith(
    visions: action.visions,
    isLoading: false,
    errorMessage: null,
  );
}

VisionState _visionUpdateFailed(VisionState state, VisionUpdateFailedAction action) {
  return state.copyWith(
    isLoading: false,
    errorMessage: action.error,
  );
}
