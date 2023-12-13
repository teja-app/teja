import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/master_feeling.dart';
import 'package:teja/domain/redux/mood/editor/mood_editor_actions.dart';
import 'package:teja/domain/redux/mood/master_feeling/actions.dart';
import 'package:teja/presentation/mood/ui/feeling_button.dart';
import 'package:teja/shared/common/button.dart';
import 'package:teja/domain/redux/app_state.dart';

class FeelingScreen extends StatefulWidget {
  const FeelingScreen({super.key});

  @override
  FeelingScreenState createState() => FeelingScreenState();
}

class FeelingScreenState extends State<FeelingScreen> {
  late List<MasterFeelingEntity> _allFeelings;
  Map<int, List<MasterFeelingEntity>> _groupedFeelings = {};

  Map<int, GlobalKey> _moodKeys = {};
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _allFeelings = [];
    _groupedFeelings = {}; // Initialize as an empty map
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

  void _initializeFeelings(List<MasterFeelingEntity> feelings, int currentMood) {
    _allFeelings = feelings.cast<MasterFeelingEntity>();
    _groupAndSortFeelings();
    _groupedFeelings.forEach((mood, _) {
      _moodKeys[mood] = GlobalKey();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToCurrentMood(currentMood));
  }

  void settingState(List<MasterFeelingEntity> masterFeelings, int currentMood) {
    setState(() {
      _allFeelings = masterFeelings.cast<MasterFeelingEntity>();
      _groupAndSortFeelings();
    });
  }

  void _groupAndSortFeelings() {
    _groupedFeelings.clear();
    for (var feeling in _allFeelings) {
      int moodGroup = _mapPleasantnessToMood(feeling.pleasantness);
      _groupedFeelings.putIfAbsent(moodGroup, () => []).add(feeling);
    }

    // Sort each group by the absolute value of energy level
    _groupedFeelings.forEach((key, value) {
      value.sort((a, b) => a.energy.abs().compareTo(b.energy.abs()));
    });
  }

  int _mapPleasantnessToMood(int pleasantness) {
    if (pleasantness == -4 || pleasantness == -5) {
      return 1; // Mood 1
    } else if (pleasantness == -2 || pleasantness == -3) {
      return 2; // Mood 2
    } else if (pleasantness == -1 || pleasantness == 1) {
      return 3; // Mood 3
    } else if (pleasantness == 2 || pleasantness == 3) {
      return 4; // Mood 4
    } else if (pleasantness == 4 || pleasantness == 5) {
      return 5; // Mood 5
    } else {
      return 3; // Default to Mood 3 for any unexpected values
    }
  }

  // Return 'active' if the mood is selected, otherwise 'inactive'
  String getMoodIconPath(int moodIndex) {
    return 'assets/icons/mood_${moodIndex}_active.svg';
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

  // Add this method to handle the scrolling
  void _scrollToCurrentMood(int moodRating) {
    if (_moodKeys.containsKey(moodRating)) {
      final keyContext = _moodKeys[moodRating]!.currentContext;
      if (keyContext != null) {
        // Scroll to the desired mood group
        final RenderBox box = keyContext.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero).dy - 200;
        _scrollController.animateTo(
          position,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.fromStore(store),
      onInit: (store) => _initializeFeelings(store.state.masterFeelingState.masterFeelings ?? [],
          store.state.moodEditorState.currentMoodLog?.moodRating ?? 0),
      onDidChange: (previousViewModel, viewModel) {
        settingState(
          viewModel.masterFeelings,
          viewModel.moodRating,
        );
      },
      builder: (context, vm) {
        String moodIconPath = getMoodIconPath(vm.moodRating);

        return SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!vm.isLoading)
                        ..._groupedFeelings.entries.map((entry) {
                          // Create a list of widget rows with margins between the buttons
                          List<Widget> feelingRows = [];
                          for (int i = 0; i < entry.value.length; i += 2) {
                            feelingRows.add(
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0), // Add padding around each button
                                      child: FeelingButton(
                                        feeling: entry.value[i],
                                        isSelected: vm.selectedFeelings?.contains(entry.value[i]) ?? false,
                                        onSelect: (selectedFeeling) => _handleFeelingSelection(selectedFeeling, vm),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: i + 1 < entry.value.length
                                        ? Padding(
                                            padding: const EdgeInsets.all(4.0), // Add padding around each button
                                            child: FeelingButton(
                                              feeling: entry.value[i + 1],
                                              isSelected: vm.selectedFeelings?.contains(entry.value[i + 1]) ?? false,
                                              onSelect: (selectedFeeling) =>
                                                  _handleFeelingSelection(selectedFeeling, vm),
                                            ),
                                          )
                                        : Container(), // Empty container to balance the row
                                  ),
                                ],
                              ),
                            );
                          }
                          return Column(
                            key: _moodKeys[entry.key], // Assign the GlobalKey here
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 40,
                              ),
                              Center(
                                child: SvgPicture.asset(
                                  getMoodIconPath(entry.key), // Assume entry.key is the mood rating
                                  width: 32,
                                  height: 32,
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              ...feelingRows, // Add the list of row widgets here
                            ],
                          );
                        }).toList(),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: colorScheme.background,
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      if (moodIconPath.isNotEmpty) SvgPicture.asset(moodIconPath, width: 32, height: 32),
                      const SizedBox(width: 10), // Spacing between icon and title
                      Expanded(
                        child: Text(
                          "What best describes this feeling?",
                          style: textTheme.titleLarge,
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
