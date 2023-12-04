import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/master_feeling.dart';
import 'package:teja/domain/redux/mood/editor/mood_editor_actions.dart';
import 'package:teja/domain/redux/mood/master_feeling/actions.dart';
import 'package:teja/shared/common/button.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/shared/common/description_button.dart';

class FeelingScreen extends StatefulWidget {
  const FeelingScreen({super.key});

  @override
  _FeelingScreenState createState() => _FeelingScreenState();
}

class _FeelingScreenState extends State<FeelingScreen> {
  late List<MasterFeelingEntity> _allFeelings;
  late List<MasterFeelingEntity> _filteredFeelings;
  final _multiSelectKey = GlobalKey<FormFieldState>();
  List<MultiSelectItem<MasterFeelingEntity>> _multiSelectItems = [];

  @override
  void initState() {
    super.initState();
    _allFeelings = [];
    _filteredFeelings = [];
    _multiSelectItems = []; // Empty list initialization
    // Dispatching the action to load feelings when the widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        StoreProvider.of<AppState>(context).dispatch(FetchMasterFeelingsActionFromCache());
      }
    });
  }

  void _initializeFeelings(List<MasterFeelingEntity> feelings, int currentMood) {
    // Initialize the comprehensive list of emotions mapped to their respective moods
    // setState(() {
    _allFeelings = feelings.cast<MasterFeelingEntity>();
    // Filter the comprehensive _feelings list based on currentMood
    _filteredFeelings = _allFeelings.where((emotion) => emotion.moodId == currentMood).toList();

    // Initialize _multiSelectItems
    _multiSelectItems = _filteredFeelings.map((e) => MultiSelectItem<MasterFeelingEntity>(e, e.name)).toList();
    // });
  }

  void settingState(List<MasterFeelingEntity> masterFeelings, int currentMood) {
    setState(() {
      _allFeelings = masterFeelings.cast<MasterFeelingEntity>();
      // Filter the comprehensive _feelings list based on currentMood
      _filteredFeelings = _allFeelings.where((emotion) => emotion.moodId == currentMood).toList();

      // Initialize _multiSelectItems
      _multiSelectItems = _filteredFeelings.map((e) => MultiSelectItem<MasterFeelingEntity>(e, e.name)).toList();
    });
  }

  // void _showAllFeelings() {
  //   showModalBottomSheet(
  //     isScrollControlled: true,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return MultiSelectBottomSheet(
  //         searchable: true,
  //         items: _allFeelings
  //             .map((e) => MultiSelectItem<MasterFeelingEntity>(e, e.name))
  //             .toList(),
  //         maxChildSize: 0.7,
  //         minChildSize: 0.3,
  //         initialChildSize: 0.5,
  //         onConfirm: (values) {
  //           setState(() {
  //             _selectedFeelings = values;

  //             for (var emotion in _selectedFeelings) {
  //               if (!_filteredFeelings.contains(emotion)) {
  //                 _filteredFeelings.add(emotion);
  //                 _multiSelectItems.add(MultiSelectItem<MasterFeelingEntity>(
  //                     emotion, emotion.name));
  //               }
  //             }
  //           });
  //         },
  //         initialValue: _selectedFeelings,
  //       );
  //     },
  //   );
  // }

  // Return 'active' if the mood is selected, otherwise 'inactive'
  String getMoodIconPath(int moodIndex) {
    return 'assets/icons/mood_${moodIndex}_active.svg';
  }

  // void _onFeelingSelectionChanged(List<MasterFeelingEntity> newSelections) {
  //   final store = StoreProvider.of<AppState>(context);
  //   List<String> selectedFeelingSlugs = newSelections.map((feeling) => feeling.slug).toSet().toList();
  //   store.dispatch(TriggerUpdateFeelingsAction(
  //     store.state.moodEditorState.currentMoodLog!.id, // or some other way to get the moodLogId
  //     selectedFeelingSlugs,
  //     newSelections,
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.fromStore(store),
        onInit: (store) => _initializeFeelings(store.state.masterFeelingState.masterFeelings ?? [],
            store.state.moodEditorState.currentMoodLog?.moodRating ?? 0),
        onDidChange: (previousViewModel, viewModel) => {
              settingState(
                viewModel.masterFeelings,
                viewModel.moodRating,
              )
            },
        builder: (context, vm) {
          String moodIconPath = getMoodIconPath(vm.moodRating);
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (moodIconPath.isNotEmpty)
                            SvgPicture.asset(
                              moodIconPath,
                              width: 32,
                              height: 32,
                            ),
                          const SizedBox(width: 8),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "What best describes this feeling?",
                        style: TextStyle(fontSize: 24),
                      ),
                      if (!vm.isLoading && _allFeelings.isNotEmpty)
                        Builder(
                          builder: (BuildContext buildContext) {
                            List<MasterFeelingEntity> selectedFeelings = vm.selectedFeelings ?? [];
                            print("selectedFeelings ${selectedFeelings}");
                            if (_multiSelectItems.isNotEmpty) {
                              return MultiSelectChipField<MasterFeelingEntity>(
                                scroll: false,
                                items: _multiSelectItems,
                                key: _multiSelectKey,
                                showHeader: false,
                                searchable: true,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: Colors.black12),
                                  ),
                                ),
                                onTap: (List<MasterFeelingEntity?>? values) {
                                  return null; // Explicitly returning null as a dynamic type.
                                },
                                chipWidth: 50,
                                itemBuilder: (MultiSelectItem<MasterFeelingEntity?> item,
                                    FormFieldState<List<MasterFeelingEntity?>> state) {
                                  bool isSelected =
                                      selectedFeelings.any((selectedFeeling) => selectedFeeling.id == item.value?.id);
                                  return DescriptionButton(
                                    title: item.value!.name,
                                    description: item.value!.description,
                                    onPressed: () {
                                      final store = StoreProvider.of<AppState>(context);
                                      bool isAlreadySelected = selectedFeelings
                                          .any((selectedFeeling) => selectedFeeling.id == item.value?.id);
                                      List<MasterFeelingEntity> updatedSelectedFeelings = List.from(selectedFeelings);

                                      if (isAlreadySelected) {
                                        updatedSelectedFeelings.removeWhere((feeling) => feeling.id == item.value!.id);
                                      } else {
                                        var feelingToAdd =
                                            _allFeelings.firstWhere((feeling) => feeling.id == item.value!.id);
                                        updatedSelectedFeelings.add(feelingToAdd);
                                      }

                                      List<String> selectedFeelingSlugs =
                                          updatedSelectedFeelings.map((feeling) => feeling.slug).toSet().toList();

                                      store.dispatch(
                                        TriggerUpdateFeelingsAction(
                                          vm.moodLogId,
                                          selectedFeelingSlugs,
                                          updatedSelectedFeelings,
                                        ),
                                      );
                                    },
                                    icon: isSelected ? AntDesign.check : null,
                                  );
                                },
                              );
                            } else {
                              // Display a CircularProgressIndicator or some placeholder
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      // Container(
                      //   margin: const EdgeInsets.all(8.0),
                      //   child: TextButton(
                      //     onPressed: _showAllFeelings,
                      //     child: Text(
                      //       "View more feelings options",
                      //       style: textTheme.labelLarge,
                      //     ),
                      //   ),
                      // ),
                      // Next Button
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
                  padding: EdgeInsets.all(10.0),
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
            ]),
          );
        });
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
      masterFeelings: store.state.masterFeelingState.masterFeelings ?? [],
      selectedFeelings: store.state.moodEditorState.selectedFeelings ?? [],
      fetchFeelings: () => store.dispatch(FetchMasterFeelingsActionFromCache()),
    );
  }
}
