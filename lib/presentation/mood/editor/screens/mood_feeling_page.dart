import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/master_feeling_entity.dart';
import 'package:teja/domain/redux/mood/editor/mood_editor_actions.dart';
import 'package:teja/domain/redux/mood/master_feeling/actions.dart';
import 'package:teja/shared/common/button.dart';
import 'package:teja/domain/redux/app_state.dart';

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
    final store = StoreProvider.of<AppState>(context);
    bool isAlreadySelected = vm.selectedFeelings?.contains(feeling) ?? false; // Null-aware check
    List<MasterFeelingEntity> updatedSelectedFeelings = List.from(vm.selectedFeelings ?? []); // Null-aware

    if (isAlreadySelected) {
      updatedSelectedFeelings.removeWhere((selectedFeeling) => selectedFeeling.id == feeling.id);
    } else {
      updatedSelectedFeelings.add(feeling);
    }

    List<String> selectedFeelingSlugs = updatedSelectedFeelings.map((feeling) => feeling.slug).toSet().toList();

    store.dispatch(
      TriggerUpdateFeelingsAction(
        vm.moodLogId,
        selectedFeelingSlugs,
        updatedSelectedFeelings,
      ),
    );
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
                      buildLevel1Feelings(context),
                      if (selectedBroadFeelings.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('Secondary Feelings', style: textTheme.titleLarge),
                        ),
                        buildLevel2Feelings(context),
                      ],
                      if (selectedSecondaryFeelings.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('Detailed Feelings', style: textTheme.titleLarge),
                        ),
                        buildLevel3Feelings(context),
                      ],
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

  Widget buildLevel1Feelings(BuildContext context) {
    List<MasterFeelingEntity> broaderFeelings = _allFeelings.where((feeling) => feeling.type == 'category').toList();
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: broaderFeelings.map((feeling) {
        bool isSelected = selectedBroadFeelings.contains(feeling.slug);
        return Button(
          text: feeling.name,
          onPressed: () {
            setState(() {
              if (isSelected) {
                selectedBroadFeelings.remove(feeling.slug);
                selectedSecondaryFeelings = []; // Reset secondary feelings if their parent is deselected
              } else {
                selectedBroadFeelings.add(feeling.slug);
              }
              selectedDetailedFeelings = []; // Reset detailed feelings on any change
            });
          },
          buttonType: isSelected ? ButtonType.primary : ButtonType.defaultButton,
        );
      }).toList(),
    );
  }

  Widget buildLevel2Feelings(BuildContext context) {
    // We now need to get the union of all secondary feelings for the selected broad feelings
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
            setState(() {
              if (isSelected) {
                selectedSecondaryFeelings.remove(feeling.slug);
              } else {
                selectedSecondaryFeelings.add(feeling.slug);
              }
              selectedDetailedFeelings = []; // Reset detailed feelings on any change
            });
          },
          buttonType: isSelected ? ButtonType.primary : ButtonType.defaultButton,
        );
      }).toList(),
    );
  }

  Widget buildLevel3Feelings(BuildContext context) {
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
            setState(() {
              if (isSelected) {
                selectedDetailedFeelings.remove(feeling.slug);
              } else {
                selectedDetailedFeelings.add(feeling.slug);
              }
            });
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
