// lib/domain/redux/mood/master_feeling/actions.dart

// Action to initiate the process of fetching master feelings
import 'package:flutter/material.dart';
import 'package:swayam/domain/entities/master_feeling.dart';

@immutable
class FetchMasterFeelingsAction {}

// Action to indicate that the fetch process is in progress
@immutable
class FetchMasterFeelingsInProgressAction {}

@immutable
class MasterFeelingsFetchedFromCacheAction {
  final List<MasterFeelingEntity> feelings;

  const MasterFeelingsFetchedFromCacheAction(this.feelings);
}

// Action to handle the successful fetch of master feelings
@immutable
class MasterFeelingsFetchedSuccessAction {
  final List<MasterFeelingEntity> feelings;
  final DateTime lastUpdatedAt;

  const MasterFeelingsFetchedSuccessAction(this.feelings, this.lastUpdatedAt);
}

// Action to handle the scenario when fetching master feelings fails
@immutable
class MasterFeelingsFetchFailedAction {
  final String error;

  const MasterFeelingsFetchFailedAction(this.error);
}
