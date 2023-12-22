import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/master_feeling_entity.dart';
import 'package:teja/domain/redux/mood/editor/mood_editor_actions.dart';
import 'package:teja/domain/redux/mood/master_feeling/actions.dart';
import 'package:teja/shared/common/button.dart';
import 'package:teja/domain/redux/app_state.dart';

import 'package:collection/collection.dart'; // Import collection package

class FeelingScreen extends StatefulWidget {
  const FeelingScreen({super.key});

  @override
  FeelingScreenState createState() => FeelingScreenState();
}

class FeelingScreenState extends State<FeelingScreen> {
  late List<MasterFeelingEntity> _allFeelings;

  List<String> selectedBroadFeelings = [];
  List<String> selectedSecondaryFeelings = [];
  List<String> selectedDetailedFeelings = [];

  @override
  void initState() {
    super.initState();
    _allFeelings = [];
    // Dispatching the action to load feelings when the widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        StoreProvider.of<AppState>(context).dispatch(FetchMasterFeelingsActionFromCache());
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final vm = StoreProvider.of<AppState>(context, listen: false).state.moodEditorState;
    _initializeSelectedFeelings(vm.selectedFeelings ?? []);
  }

  void _initializeSelectedFeelings(List<MasterFeelingEntity> selectedFeelings) {
    selectedBroadFeelings =
        selectedFeelings.where((feeling) => feeling.type == 'category').map((feeling) => feeling.slug).toList();
    selectedSecondaryFeelings =
        selectedFeelings.where((feeling) => feeling.type == 'subcategory').map((feeling) => feeling.slug).toList();
    selectedDetailedFeelings =
        selectedFeelings.where((feeling) => feeling.type == 'feeling').map((feeling) => feeling.slug).toList();
    setState(() {}); // Trigger a rebuild if necessary
  }

  void _initializeFeelings(List<MasterFeelingEntity> feelings) {
    _allFeelings = feelings.cast<MasterFeelingEntity>();
  }

  void settingState(List<MasterFeelingEntity> masterFeelings) {
    setState(() {
      _allFeelings = masterFeelings.cast<MasterFeelingEntity>();
    });
  }

  void _handleFeelingSelection(MasterFeelingEntity feeling, _ViewModel vm) {
    if (feeling.type == 'category') {
      _updateFeelingSelection(feeling, selectedBroadFeelings);
      selectedSecondaryFeelings.clear();
      selectedDetailedFeelings.clear();
    } else if (feeling.type == 'subcategory') {
      _updateFeelingSelection(feeling, selectedSecondaryFeelings);
      selectedDetailedFeelings.clear();
    } else if (feeling.type == 'feeling') {
      _updateFeelingSelection(feeling, selectedDetailedFeelings);
    }

    setState(() {
      _dispatchUpdateAction(vm);
    });
  }

  void _updateFeelingSelection(MasterFeelingEntity feeling, List<String> selectedFeelings) {
    bool isSelected = selectedFeelings.contains(feeling.slug);
    if (isSelected) {
      selectedFeelings.remove(feeling.slug);
    } else {
      selectedFeelings.add(feeling.slug);
    }
  }

  void _dispatchUpdateAction(_ViewModel vm) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ignore: prefer_collection_literals
      List<String> selectedFeelingSlugs = [
        ...selectedBroadFeelings,
        ...selectedSecondaryFeelings,
        ...selectedDetailedFeelings,
      ].toSet().toList();

      StoreProvider.of<AppState>(context).dispatch(
        TriggerUpdateFeelingsAction(
          vm.moodLogId,
          selectedFeelingSlugs,
          _getSelectedFeelingEntities(),
        ),
      );
    });
  }

  List<MasterFeelingEntity> _getSelectedFeelingEntities() {
    Set<MasterFeelingEntity> selectedEntities = {};

    for (var slug in selectedBroadFeelings) {
      var feeling = _allFeelings.firstWhereOrNull((f) => f.slug == slug);
      if (feeling != null) {
        selectedEntities.add(feeling);
      }
    }

    for (var slug in selectedSecondaryFeelings) {
      var feeling = _allFeelings.firstWhereOrNull((f) => f.slug == slug);
      if (feeling != null) {
        selectedEntities.add(feeling);
      }
    }

    for (var slug in selectedDetailedFeelings) {
      var feeling = _allFeelings.firstWhereOrNull((f) => f.slug == slug);
      if (feeling != null) {
        selectedEntities.add(feeling);
      }
    }

    return selectedEntities.toList();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.fromStore(store),
      onInit: (store) => _initializeFeelings(store.state.masterFeelingState.masterFeelings ?? []),
      onDidChange: (previousViewModel, viewModel) {
        settingState(viewModel.masterFeelings);
      },
      builder: (context, vm) {
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text('Broader Feelings', style: textTheme.titleLarge),
                      ),
                      buildLevel1Feelings(context, vm),
                      if (selectedBroadFeelings.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('Secondary Feelings', style: textTheme.titleLarge),
                        ),
                        buildLevel2Feelings(context, vm),
                      ],
                      if (selectedSecondaryFeelings.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('Detailed Feelings', style: textTheme.titleLarge),
                        ),
                        buildLevel3Feelings(context, vm),
                      ],
                      const SizedBox(
                        height: 200,
                      ),
                      const Text(
                        "Remember, it's common to have multiple feelings, and it's okay not to verbalize them all. Selecting something close is better than nothing.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: colorScheme.background,
                  padding: const EdgeInsets.all(10.0),
                  child: Button(
                    text: "Next",
                    onPressed: () {
                      final store = StoreProvider.of<AppState>(context);
                      store.dispatch(const ChangePageAction(2));
                    },
                    buttonType: ButtonType.primary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildLevel1Feelings(BuildContext context, _ViewModel vm) {
    List<MasterFeelingEntity> broaderFeelings = _allFeelings.where((feeling) => feeling.type == 'category').toList();

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: broaderFeelings.map((feeling) {
        bool isSelected = selectedBroadFeelings.contains(feeling.slug);
        return Button(
          text: feeling.name,
          onPressed: () {
            _handleFeelingSelection(feeling, vm);
          },
          buttonType: isSelected ? ButtonType.primary : ButtonType.defaultButton,
        );
      }).toList(),
    );
  }

  Widget buildLevel2Feelings(BuildContext context, _ViewModel vm) {
    List<MasterFeelingEntity> secondaryFeelings = _allFeelings.where((feeling) {
      return feeling.type == 'subcategory' && selectedBroadFeelings.contains(feeling.parentSlug);
    }).toList();

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: secondaryFeelings.map((feeling) {
        bool isSelected = selectedSecondaryFeelings.contains(feeling.slug);
        return Button(
          text: feeling.name,
          onPressed: () {
            _handleFeelingSelection(feeling, vm);
          },
          buttonType: isSelected ? ButtonType.primary : ButtonType.defaultButton,
        );
      }).toList(),
    );
  }

  Widget buildLevel3Feelings(BuildContext context, _ViewModel vm) {
    List<MasterFeelingEntity> detailedFeelings = _allFeelings.where((feeling) {
      return feeling.type == 'feeling' && selectedSecondaryFeelings.contains(feeling.parentSlug);
    }).toList();

    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: detailedFeelings.map((feeling) {
        bool isSelected = selectedDetailedFeelings.contains(feeling.slug);
        return Button(
          text: feeling.name,
          onPressed: () {
            _handleFeelingSelection(feeling, vm);
          },
          buttonType: isSelected ? ButtonType.primary : ButtonType.defaultButton,
        );
      }).toList(),
    );
  }
}

class _ViewModel {
  final String moodLogId;
  final bool isLoading;
  final List<MasterFeelingEntity> masterFeelings;
  final List<MasterFeelingEntity>? selectedFeelings; // Add this line
  final Function() fetchFeelings;
  final int moodRating;

  _ViewModel({
    required this.moodLogId,
    required this.isLoading,
    required this.masterFeelings,
    this.selectedFeelings, // Initialize this in constructor
    required this.fetchFeelings,
    required this.moodRating,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      moodLogId: store.state.moodEditorState.currentMoodLog!.id,
      moodRating: store.state.moodEditorState.currentMoodLog?.moodRating ?? 0,
      isLoading: store.state.masterFeelingState.isLoading,
      masterFeelings: store.state.masterFeelingState.masterFeelings,
      selectedFeelings: store.state.moodEditorState.selectedFeelings ?? [],
      fetchFeelings: () => store.dispatch(FetchMasterFeelingsActionFromCache()),
    );
  }
}
