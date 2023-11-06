import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:swayam/presentation/mood/ui/feelings.dart';
import 'package:swayam/shared/common/button.dart';
import 'package:swayam/domain/redux/app_state.dart';

class FeelingScreen extends StatefulWidget {
  const FeelingScreen({super.key});

  @override
  _FeelingScreenState createState() => _FeelingScreenState();
}

class _FeelingScreenState extends State<FeelingScreen> {
  late List<Emotion> _allFeelings;
  late List<Emotion> _filteredFeelings;
  final _multiSelectKey = GlobalKey<FormFieldState>();
  List<MultiSelectItem<Emotion>> _multiSelectItems = [];
  List<Emotion> _selectedFeelings = [];

  @override
  void initState() {
    super.initState();
    _multiSelectItems = []; // Empty list initialization
  }

  void _initializeFeelings(int currentMood) {
    // Initialize the comprehensive list of emotions mapped to their respective moods
    loadEmotionList().then(
      (list) {
        setState(() {
          _allFeelings = list.cast<Emotion>();
          // Filter the comprehensive _feelings list based on currentMood
          _filteredFeelings = _allFeelings
              .where((emotion) => emotion.mood == currentMood)
              .toList();

          // Initialize _multiSelectItems
          _multiSelectItems = _filteredFeelings
              .map((e) => MultiSelectItem<Emotion>(e, e.name))
              .toList();
        });
      },
    );
  }

  void _showAllFeelings() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return MultiSelectBottomSheet(
          searchable: true,
          items: _allFeelings
              .map((e) => MultiSelectItem<Emotion>(e, e.name))
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
                  _multiSelectItems
                      .add(MultiSelectItem<Emotion>(emotion, emotion.name));
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
    return StoreConnector<AppState, int>(
        converter: (store) =>
            store.state.moodEditorState.currentMoodLog?.moodRating ?? 0,
        onInit: (store) => _initializeFeelings(
            store.state.moodEditorState.currentMoodLog?.moodRating ?? 0),
        builder: (context, currentMood) {
          String moodIconPath = getMoodIconPath(currentMood);
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
                              emotionTitle[currentMood] ?? 'Default Title',
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
                      // MultiSelectChipFie
                      Builder(
                        builder: (BuildContext context) {
                          if (_multiSelectItems.isNotEmpty) {
                            return MultiSelectChipField<Emotion>(
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
                              onTap: (List<Emotion?>? values) {
                                return null; // Explicitly returning null as a dynamic type.
                              },
                              chipWidth: 50,
                              itemBuilder: (MultiSelectItem<Emotion?> item,
                                  FormFieldState<List<Emotion?>> state) {
                                return Button(
                                  text: item.value!.name,
                                  onPressed: () {
                                    setState(() {
                                      _selectedFeelings.contains(item.value)
                                          ? _selectedFeelings.remove(item.value)
                                          : _selectedFeelings.add(item.value!);
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
