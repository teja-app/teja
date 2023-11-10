// lib/domain/redux/mood/master_feeling/actions.dart

// Action to initiate the process of fetching master feelings
import 'package:swayam/domain/entities/master_feeling.dart';

class FetchMasterFeelingsAction {}

// Action to indicate that the fetch process is in progress
class FetchMasterFeelingsInProgressAction {}

// Action to handle the successful fetch of master feelings
class MasterFeelingsFetchedAction {
  final List<MasterFeeling> feelings;

  MasterFeelingsFetchedAction(this.feelings);
}

// Action to handle the scenario when fetching master feelings fails
class MasterFeelingsFetchFailedAction {
  final String error;

  MasterFeelingsFetchFailedAction(this.error);
}
