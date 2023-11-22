import 'package:flutter/material.dart';
import 'package:swayam/domain/entities/master_factor.dart';

@immutable
class FetchMasterFactorsActionFromApi {}

@immutable
class FetchMasterFactorsActionFromCache {}

@immutable
class FetchMasterFactorsInProgressAction {}

@immutable
class MasterFactorsFetchedFromCacheAction {
  final List<MasterFactorEntity> factors;

  const MasterFactorsFetchedFromCacheAction(this.factors);
}

@immutable
class MasterFactorsFetchedSuccessAction {
  final List<MasterFactorEntity> factors;
  final DateTime lastUpdatedAt;

  const MasterFactorsFetchedSuccessAction(this.factors, this.lastUpdatedAt);
}

@immutable
class MasterFactorsFetchFailedAction {
  final String error;

  const MasterFactorsFetchFailedAction(this.error);
}
