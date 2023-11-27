import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:redux/redux.dart';
import 'package:swayam/domain/entities/feeling.dart';
import 'package:swayam/domain/entities/master_factor.dart';
import 'package:swayam/domain/redux/app_state.dart';
import 'package:swayam/domain/redux/mood/master_factor/actions.dart';

class FactorsScreen extends StatefulWidget {
  const FactorsScreen({super.key});

  @override
  _FactorsScreenState createState() => _FactorsScreenState();
}

class _FactorsScreenState extends State<FactorsScreen> {
  late List<MasterFactorEntity> _allFactors;
  late List<MasterFactorEntity> _filteredFactors;
  List<MultiSelectItem<MasterFactorEntity>> _multiSelectItems = [];
  @override
  void initState() {
    super.initState();
    _allFactors = [];
    _filteredFactors = [];
    _multiSelectItems = []; // Empty list initialization
    // Dispatching the action to load feelings when the widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        StoreProvider.of<AppState>(context)
            .dispatch(FetchMasterFactorsActionFromCache());
      }
    });
  }

  void _initializeFeelings(List<MasterFactorEntity> factors, int currentMood) {
    // Initialize the comprehensive list of emotions mapped to their respective moods
    // setState(() {
    _allFactors = factors.cast<MasterFactorEntity>();
    print("_allFactors ${_allFactors}");
    // // Filter the comprehensive _feelings list based on currentMood
    // _filteredFactors =
    //     _allFactors.where((emotion) => emotion.moodId == currentMood).toList();

    // // Initialize _multiSelectItems
    // _multiSelectItems = _filteredFeelings
    //     .map((e) => MultiSelectItem<MasterFactorEntity>(e, e.name))
    //     .toList();
    // // });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, FactorsViewModel>(
      converter: (store) => FactorsViewModel.fromStore(store),
      builder: (context, viewModel) {
        return ListView.builder(
          itemCount: viewModel.selectedFeelings?.length ?? 0,
          itemBuilder: (context, index) {
            var feeling = viewModel.selectedFeelings![index];
            return ListTile(
              title: Text(feeling.feeling),
              // Additional UI components as needed
            );
          },
        );
      },
    );
  }
}

// FactorsViewModel remains mostly the same

class FactorsViewModel {
  final String moodLogId;
  final bool isLoading;
  final List<MasterFactorEntity> factors;
  final List<FeelingEntity>? selectedFeelings;
  final Function() fetchFactors;
  final int moodRating;

  FactorsViewModel({
    required this.moodLogId,
    required this.isLoading,
    required this.factors,
    required this.fetchFactors,
    required this.moodRating,
    this.selectedFeelings,
  });

  static FactorsViewModel fromStore(Store<AppState> store) {
    return FactorsViewModel(
      moodLogId: store.state.moodEditorState.currentMoodLog!.id,
      moodRating: store.state.moodEditorState.currentMoodLog?.moodRating ?? 0,
      isLoading: store.state.masterFactorState.isLoading,
      factors: store.state.masterFactorState.masterFactors ?? [],
      fetchFactors: () => store.dispatch(FetchMasterFactorsActionFromCache()),
      selectedFeelings:
          store.state.moodEditorState.currentMoodLog?.feelings ?? [],
    );
  }
}
