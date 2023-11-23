import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:redux/redux.dart';
import 'package:swayam/domain/entities/master_feeling.dart';
import 'package:swayam/domain/redux/mood/editor/mood_editor_actions.dart';
import 'package:swayam/domain/redux/mood/master_feeling/actions.dart';
import 'package:swayam/presentation/mood/editor/ui/feelings.dart';
import 'package:swayam/shared/common/button.dart';
import 'package:swayam/domain/redux/app_state.dart';
import 'package:swayam/shared/common/description_button.dart';

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
  List<MasterFeelingEntity> _selectedFeelings = [];

  @override
  void initState() {
    super.initState();
    _allFeelings = [];
    _filteredFeelings = [];
    _multiSelectItems = []; // Empty list initialization
    // Dispatching the action to load feelings when the widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        StoreProvider.of<AppState>(context)
            .dispatch(FetchMasterFeelingsActionFromCache());
      }
    });
  }

  void _initializeFeelings(
      List<MasterFeelingEntity> feelings, int currentMood) {
    // Initialize the comprehensive list of emotions mapped to their respective moods
    // setState(() {
    _allFeelings = feelings.cast<MasterFeelingEntity>();
    // Filter the comprehensive _feelings list based on currentMood
    _filteredFeelings =
        _allFeelings.where((emotion) => emotion.moodId == currentMood).toList();

    // Initialize _multiSelectItems
    _multiSelectItems = _filteredFeelings
        .map((e) => MultiSelectItem<MasterFeelingEntity>(e, e.name))
        .toList();
    // });
  }

  void settingState(List<MasterFeelingEntity> feelings, int currentMood) {
    setState(() {
      _allFeelings = feelings.cast<MasterFeelingEntity>();
      // Filter the comprehensive _feelings list based on currentMood
      _filteredFeelings = _allFeelings
          .where((emotion) => emotion.moodId == currentMood)
          .toList();

      // Initialize _multiSelectItems
      _multiSelectItems = _filteredFeelings
          .map((e) => MultiSelectItem<MasterFeelingEntity>(e, e.name))
          .toList();
    });
  }

  void _showAllFeelings() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return MultiSelectBottomSheet(
          searchable: true,
          items: _allFeelings
              .map((e) => MultiSelectItem<MasterFeelingEntity>(e, e.name))
              .toList(),
          maxChildSize: 0.7,
          minChildSize: 0.3,
          initialChildSize: 0.5,
          onConfirm: (values) {
            setState(() {
              _selectedFeelings = values;

              for (var emotion in _selectedFeelings) {
                if (!_filteredFeelings.contains(emotion)) {
                  _filteredFeelings.add(emotion);
                  _multiSelectItems.add(MultiSelectItem<MasterFeelingEntity>(
                      emotion, emotion.name));
                }
              }
            });
          },
          initialValue: _selectedFeelings,
        );
      },
    );
  }

  // Return 'active' if the mood is selected, otherwise 'inactive'
  String getMoodIconPath(int moodIndex) {
    return 'assets/icons/mood_${moodIndex}_active.svg';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.fromStore(store),
        onInit: (store) => _initializeFeelings(
            store.state.masterFeelingState.masterFeelings ?? [],
            store.state.moodEditorState.currentMoodLog?.moodRating ?? 0),
        onDidChange: (previousViewModel, viewModel) => {
              settingState(
                viewModel.feelings,
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
                          Expanded(
                            child: Text(
                              emotionTitle[vm.moodRating] ?? 'Default Title',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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
                                itemBuilder:
                                    (MultiSelectItem<MasterFeelingEntity?> item,
                                        FormFieldState<
                                                List<MasterFeelingEntity?>>
                                            state) {
                                  return DescriptionButton(
                                    title: item.value!.name,
                                    description: item.value!.description,
                                    onPressed: () {
                                      setState(() {
                                        bool isAlreadySelected =
                                            _selectedFeelings
                                                .contains(item.value);
                                        if (isAlreadySelected) {
                                          _selectedFeelings.remove(item.value);
                                        } else {
                                          _selectedFeelings.add(item.value!);
                                        }
                                      });

                                      // Convert selected feelings to slugs, ensuring uniqueness
                                      List<String> selectedFeelingSlugs =
                                          _selectedFeelings
                                              .map((feeling) => feeling.slug)
                                              .toSet() // Remove duplicates by converting to a Set
                                              .toList(); // Convert back to List for dispatching

                                      // Dispatch an action to update feelings in the Redux store
                                      StoreProvider.of<AppState>(context)
                                          .dispatch(
                                        TriggerUpdateFeelingsAction(
                                          vm.moodLogId,
                                          selectedFeelingSlugs,
                                        ),
                                      );
                                    },
                                    icon: _selectedFeelings.contains(item.value)
                                        ? AntDesign.check
                                        : null,
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
                      Container(
                        margin: const EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: _showAllFeelings,
                          child: Text(
                            "View more feelings options",
                            style: textTheme.labelLarge,
                          ),
                        ),
                      ),
                      // Next Button
                      Button(
                        text: "Next",
                        width: 200,
                        onPressed: () {
                          final store = StoreProvider.of<AppState>(context);
                          store.dispatch(const ChangePageAction(2));
                        },
                        buttonType: ButtonType.primary,
                      ),
                    ],
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
  final List<MasterFeelingEntity> feelings;
  final Function() fetchFeelings;
  final int moodRating;

  _ViewModel({
    required this.moodLogId,
    required this.isLoading,
    required this.feelings,
    required this.fetchFeelings,
    required this.moodRating,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      moodLogId: store.state.moodEditorState.currentMoodLog!.id,
      moodRating: store.state.moodEditorState.currentMoodLog?.moodRating ?? 0,
      isLoading: store.state.masterFeelingState.isLoading,
      feelings: store.state.masterFeelingState.masterFeelings ?? [],
      fetchFeelings: () => store.dispatch(FetchMasterFeelingsActionFromCache()),
    );
  }
}
