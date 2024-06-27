import 'package:flutter/foundation.dart';

@immutable
class ExportJSONAction {
  const ExportJSONAction();
}

@immutable
class ExportJSONActionFailed {
  const ExportJSONActionFailed(String string);
}

@immutable
class ImportJSONAction {
  const ImportJSONAction();
}

@immutable
class ImportJSONActionFailed {
  const ImportJSONActionFailed(String string);
}

@immutable
class DeleteAccountAction {
  const DeleteAccountAction();
}

@immutable
class DeleteAccountActionSuccess {
  const DeleteAccountActionSuccess();
}

@immutable
class DeleteAccountActionFailed {
  final String error;
  const DeleteAccountActionFailed(this.error);
}
