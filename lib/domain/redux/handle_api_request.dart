import 'package:dio/dio.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/redux/core_actions.dart';

Future<void> handleApiRequest<T>({
  required Future<Response> Function() apiCall,
  required Store store,
  required SuccessAction Function(Response) onSuccess,
  required FailureAction Function(String) onFailure,
}) async {
  try {
    final Response response = await apiCall();
    store.dispatch(onSuccess(response));
  } catch (e) {
    String errorMessage;
    if (e is DioException) {
      if (e.response!.statusCode! >= 400 && e.response!.statusCode! < 500) {
        var apiMessage = e.response?.data['message'];
        if (apiMessage is List<dynamic>) {
          errorMessage = apiMessage.join(' ');
        } else if (apiMessage is String) {
          errorMessage = apiMessage;
        } else {
          errorMessage = 'An error occurred';
        }
      } else if (e.response!.statusCode! >= 500) {
        errorMessage = 'Server error. Please try again later.';
      } else {
        errorMessage = 'An error occurred. Please try again later.';
      }
    } else {
      errorMessage = e.toString();
    }
    store.dispatch(onFailure(errorMessage));
  }
}
