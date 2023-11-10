import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:redux/redux.dart';
import 'package:swayam/domain/entities/master_feeling.dart';
import 'package:swayam/domain/redux/mood/editor/mood_editor_actions.dart';
import 'package:swayam/presentation/mood/ui/feelings.dart';
import 'package:swayam/shared/common/button.dart';
import 'package:swayam/domain/redux/app_state.dart';

class FeelingScreen extends StatefulWidget {
  const FeelingScreen({super.key});

  @override
  _FeelingScreenState createState() => _FeelingScreenState();
}

class _FeelingScreenState extends State<FeelingScreen> {
  late List<MasterFeeling> _allFeelings;
  late List<MasterFeeling> _filteredFeelings;
  final _multiSelectKey = GlobalKey<FormFieldState>();
  List<MultiSelectItem<MasterFeeling>> _multiSelectItems = [];
  List<MasterFeeling> _selectedFeelings = [];

  @override
  void initState() {
    super.initState();
    _allFeelings = [];
    _filteredFeelings = [];
    _multiSelectItems = []; // Empty list initialization
    // Dispatching the action to load feelings when the widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        StoreProvider.of<AppState>(context).dispatch(FetchFeelingsAction());
      }
    });
  }

  void _initializeFeelings(List<MasterFeeling> feelings, int currentMood) {
    // Initialize the comprehensive list of emotions mapped to their respective moods
    // setState(() {
    _allFeelings = feelings.cast<MasterFeeling>();
    // Filter the comprehensive _feelings list based on currentMood
    _filteredFeelings =
        _allFeelings.where((emotion) => emotion.moodId == currentMood).toList();

    // Initialize _multiSelectItems
    _multiSelectItems = _filteredFeelings
        .map((e) => MultiSelectItem<MasterFeeling>(e, e.name))
        .toList();
    // });
  }

  void _showAllFeelings() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return MultiSelectBottomSheet(
          searchable: true,
          items: _allFeelings
              .map((e) => MultiSelectItem<MasterFeeling>(e, e.name))
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
                  _multiSelectItems.add(
                      MultiSelectItem<MasterFeeling>(emotion, emotion.name));
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
    return StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.fromStore(store),
        onInit: (store) => _initializeFeelings(
            store.state.moodEditorState.masterFeelings ?? [],
            store.state.moodEditorState.currentMoodLog?.moodRating ?? 0),
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
                              return MultiSelectChipField<MasterFeeling>(
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
                                onTap: (List<MasterFeeling?>? values) {
                                  return null; // Explicitly returning null as a dynamic type.
                                },
                                chipWidth: 50,
                                itemBuilder:
                                    (MultiSelectItem<MasterFeeling?> item,
                                        FormFieldState<List<MasterFeeling?>>
                                            state) {
                                  return Button(
                                    text: item.value!.name,
                                    onPressed: () {
                                      setState(() {
                                        _selectedFeelings.contains(item.value)
                                            ? _selectedFeelings
                                                .remove(item.value)
                                            : _selectedFeelings
                                                .add(item.value!);
                                      });
                                      state.didChange(_selectedFeelings);
                                      _multiSelectKey.currentState?.validate();
                                    },
                                    buttonType:
                                        _selectedFeelings.contains(item.value)
                                            ? ButtonType.primary
                                            : ButtonType.defaultButton,
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
                            style: TextStyle(
                              color: Colors.blueAccent
                                  .shade700, // Setting the text color to black
                            ),
                          ),
                        ),
                      ),
                      // Next Button
                      Button(
                        text: "Next",
                        width: 200,
                        onPressed: () {
                          // TODO: Handle next action
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
  final bool isLoading;
  final List<MasterFeeling> feelings;
  final Function() fetchFeelings;
  final int moodRating;

  _ViewModel({
    required this.isLoading,
    required this.feelings,
    required this.fetchFeelings,
    required this.moodRating,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      moodRating: store.state.moodEditorState.currentMoodLog?.moodRating ?? 0,
      isLoading: store.state.moodEditorState.isFetchingFeelings,
      feelings: store.state.moodEditorState.masterFeelings ?? [],
      fetchFeelings: () => store.dispatch(FetchFeelingsAction()),
    );
  }
}
