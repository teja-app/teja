import 'package:flutter/material.dart';
import 'package:teja/shared/common/button.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Default',
  type: Button,
)
Widget buildDefaultButtonUseCase(BuildContext context) {
  return const Button(
    text: "Help",
  );
}

@widgetbook.UseCase(
  name: 'Primary',
  type: Button,
)
Widget buildPrimaryButtonUseCase(BuildContext context) {
  return const Button(
    text: "Submit",
    buttonType: ButtonType.primary,
  );
}

@widgetbook.UseCase(
  name: 'Secondary',
  type: Button,
)
Widget buildSecondaryButtonUseCase(BuildContext context) {
  return const Button(
    text: "Cancel",
    buttonType: ButtonType.secondary,
  );
}

@widgetbook.UseCase(
  name: 'Disabled',
  type: Button,
)
Widget buildDisabledButtonUseCase(BuildContext context) {
  return const Button(
    text: "Disabled",
    buttonType: ButtonType.disabled,
    onPressed: null,
  );
}
