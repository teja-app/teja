import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/feeling.dart';
import 'package:teja/domain/entities/master_factor.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/mood/editor/mood_editor_actions.dart';
import 'package:teja/domain/redux/mood/master_factor/actions.dart';
import 'package:teja/shared/common/button.dart';
import 'package:teja/shared/common/flexible_height_box.dart';

class FactorsScreen extends StatefulWidget {
  const FactorsScreen({super.key});

  @override
  _FactorsScreenState createState() => _FactorsScreenState();
}

class _FactorsScreenState extends State<FactorsScreen> {
  late Map<int, List<MasterFactorEntity>> _factorsForFeelings = {};
  late Map<int, List<MasterFactorEntity>> _selectedFactorsForFeelings = {};
  late Map<int, List<MultiSelectItem<MasterFactorEntity>>> _multiSelectItemsForFeelings = {};

  @override
  void initState() {
    super.initState();
    _factorsForFeelings = {};
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        StoreProvider.of<AppState>(context).dispatch(FetchMasterFactorsActionFromCache());
      }
    });
  }

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final store = StoreProvider.of<AppState>(context);
      final factors = store.state.masterFactorState.masterFactors;
      final feelingFactorLink = store.state.moodEditorState.feelingFactorLink;

      if (factors.isNotEmpty) {
        _initializeFactors(factors, feelingFactorLink);
      }

      _isInitialized = true;
    }
  }

  void _initializeFactors(List<MasterFactorEntity> factors, Map<int, List<int>>? feelingFactorLink) {
    setState(() {
      final feelingKeys = feelingFactorLink?.keys.toList();
      for (var feeling in feelingKeys ?? []) {
        var relevantFactorIds = feelingFactorLink?[feeling] ?? []; // Handle null by providing an empty list
        var relevantFactors = factors.where((factor) => relevantFactorIds.contains(factor.id)).toList();

        // print("feeling ${feeling.id}");
        _factorsForFeelings[feeling] = relevantFactors;
        _multiSelectItemsForFeelings[feeling] =
            relevantFactors.map((factor) => MultiSelectItem<MasterFactorEntity>(factor, factor.name)).toList();
        _selectedFactorsForFeelings[feeling] = []; // Initialize with empty list
      }
    });
  }

  void _updateFactorsAction(String moodLogId, int feelingId, List<MasterFactorEntity> selectedFactors) {
    Store<AppState> store = StoreProvider.of<AppState>(context);
    store.dispatch(
      UpdateFactorsAction(
        moodLogId: moodLogId,
        feelingId: feelingId,
        factors: selectedFactors,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return StoreConnector<AppState, FactorsViewModel>(
      converter: (store) => FactorsViewModel.fromStore(store),
      builder: (context, viewModel) {
        if (_factorsForFeelings.isEmpty && viewModel.factors.isNotEmpty) {
          _initializeFactors(viewModel.factors, viewModel.feelingFactorLink);
        }
        return ListView.builder(
          itemCount: viewModel.selectedFeelings?.length ?? 0,
          itemBuilder: (context, index) {
            var feeling = viewModel.selectedFeelings![index];
            var items = _multiSelectItemsForFeelings[feeling.id] ?? [];
            var selectedFactors = _selectedFactorsForFeelings[feeling.id] ?? [];
            return FlexibleHeightBox(
              gridWidth: 4,
              margin: 32,
              child: Column(
                children: [
                  Text(
                    'Why are you ${feeling.feeling}?',
                    style: textTheme.titleMedium,
                  ),
                  Builder(
                    builder: (BuildContext buildContext) {
                      if (items.isNotEmpty) {
                        return MultiSelectChipField<MasterFactorEntity>(
                          scroll: false,
                          items: items,
                          initialValue: selectedFactors,
                          showHeader: false,
                          searchable: true,
                          chipWidth: 50,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Colors.transparent),
                            ),
                          ),
                          itemBuilder: (MultiSelectItem<MasterFactorEntity?> item,
                              FormFieldState<List<MasterFactorEntity?>> state) {
                            return Button(
                              text: item.value!.name,
                              onPressed: () {
                                setState(() {
                                  bool isAlreadySelected = selectedFactors.contains(item.value);
                                  if (isAlreadySelected) {
                                    selectedFactors.remove(item.value);
                                  } else {
                                    selectedFactors.add(item.value!);
                                  }
                                });
                                _updateFactorsAction(viewModel.moodLogId, feeling.id!, selectedFactors);
                              },
                              icon: selectedFactors.contains(item.value) ? AntDesign.check : null,
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
                ],
              ),
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
  final Map<int, List<int>>? feelingFactorLink;
  final Function() fetchFactors;
  final int moodRating;

  FactorsViewModel({
    required this.moodLogId,
    required this.isLoading,
    required this.factors,
    required this.fetchFactors,
    required this.moodRating,
    this.feelingFactorLink,
    this.selectedFeelings,
  });

  static FactorsViewModel fromStore(Store<AppState> store) {
    return FactorsViewModel(
      moodLogId: store.state.moodEditorState.currentMoodLog!.id,
      moodRating: store.state.moodEditorState.currentMoodLog?.moodRating ?? 0,
      feelingFactorLink: store.state.moodEditorState.feelingFactorLink,
      isLoading: store.state.masterFactorState.isLoading,
      factors: store.state.masterFactorState.masterFactors ?? [],
      fetchFactors: () => store.dispatch(FetchMasterFactorsActionFromCache()),
      selectedFeelings: store.state.moodEditorState.currentMoodLog?.feelings ?? [],
    );
  }
}
