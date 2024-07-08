// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:widgetbook/widgetbook.dart' as _i1;
import 'package:widgetbook_workspace/core/button.dart' as _i4;
import 'package:widgetbook_workspace/core/coutdown.dart' as _i2;
import 'package:widgetbook_workspace/profile/ui/mood_gauge_chart.dart' as _i3;

final directories = <_i1.WidgetbookNode>[
  _i1.WidgetbookFolder(
    name: 'presentation',
    children: [
      _i1.WidgetbookFolder(
        name: 'home',
        children: [
          _i1.WidgetbookFolder(
            name: 'ui',
            children: [
              _i1.WidgetbookLeafComponent(
                name: 'CountdownTimer',
                useCase: _i1.WidgetbookUseCase(
                  name: 'Countdown Timer Starting from 1 Hour',
                  builder: _i2.buildCountdownTimer1HourUseCase,
                ),
              )
            ],
          )
        ],
      ),
      _i1.WidgetbookFolder(
        name: 'profile',
        children: [
          _i1.WidgetbookFolder(
            name: 'ui',
            children: [
              _i1.WidgetbookComponent(
                name: 'MoodGaugeChart',
                useCases: [
                  _i1.WidgetbookUseCase(
                    name: 'All Mood Counts Zero',
                    builder: _i3.buildAllMoodsZeroUseCase,
                  ),
                  _i1.WidgetbookUseCase(
                    name: 'Average Mood 1.5',
                    builder: _i3.buildAverageMood15UseCase,
                  ),
                  _i1.WidgetbookUseCase(
                    name: 'Average Mood 3.0',
                    builder: _i3.buildAverageMood3UseCase,
                  ),
                  _i1.WidgetbookUseCase(
                    name: 'Average Mood 4.5',
                    builder: _i3.buildAverageMood45UseCase,
                  ),
                ],
              )
            ],
          )
        ],
      ),
    ],
  ),
  _i1.WidgetbookFolder(
    name: 'shared',
    children: [
      _i1.WidgetbookFolder(
        name: 'common',
        children: [
          _i1.WidgetbookComponent(
            name: 'Button',
            useCases: [
              _i1.WidgetbookUseCase(
                name: 'Default',
                builder: _i4.buildDefaultButtonUseCase,
              ),
              _i1.WidgetbookUseCase(
                name: 'Disabled',
                builder: _i4.buildDisabledButtonUseCase,
              ),
              _i1.WidgetbookUseCase(
                name: 'Primary',
                builder: _i4.buildPrimaryButtonUseCase,
              ),
              _i1.WidgetbookUseCase(
                name: 'Secondary',
                builder: _i4.buildSecondaryButtonUseCase,
              ),
            ],
          )
        ],
      )
    ],
  ),
];
