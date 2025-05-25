abstract class Action {}

class SuccessAction implements Action {
  final String message;
  SuccessAction(this.message);
}

class FailureAction implements Action {
  final String error;
  FailureAction(this.error);
}
