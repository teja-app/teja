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
