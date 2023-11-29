import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:redux/redux.dart';
import 'package:swayam/domain/entities/feeling.dart';
import 'package:swayam/domain/entities/master_factor.dart';
import 'package:swayam/domain/redux/app_state.dart';
import 'package:swayam/domain/redux/mood/master_factor/actions.dart';
import 'package:swayam/shared/common/bento_box.dart';
import 'package:swayam/shared/common/button.dart';

class FactorsScreen extends StatefulWidget {
  const FactorsScreen({super.key});

  @override
  _FactorsScreenState createState() => _FactorsScreenState();
}

class _FactorsScreenState extends State<FactorsScreen> {
  late Map<int, List<MasterFactorEntity>> _factorsForFeelings = {};
  late Map<int, List<MasterFactorEntity>> _selectedFactorsForFeelings = {};
  late Map<int, List<MultiSelectItem<MasterFactorEntity>>>
      _multiSelectItemsForFeelings = {};

  @override
  void initState() {
    super.initState();
    _factorsForFeelings = {};
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        StoreProvider.of<AppState>(context)
            .dispatch(FetchMasterFactorsActionFromCache());
      }
    });
  }

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    print("didChangeDependencies");
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

  void _initializeFactors(List<MasterFactorEntity> factors,
      Map<int, List<int>>? feelingFactorLink) {
    setState(() {
      final feelingKeys = feelingFactorLink?.keys.toList();
      for (var feeling in feelingKeys ?? []) {
        var relevantFactorIds = feelingFactorLink?[feeling] ??
            []; // Handle null by providing an empty list
        var relevantFactors = factors
            .where((factor) => relevantFactorIds.contains(factor.id))
            .toList();

        // print("feeling ${feeling.id}");
        _factorsForFeelings[feeling] = relevantFactors;
        _multiSelectItemsForFeelings[feeling] = relevantFactors
            .map((factor) =>
                MultiSelectItem<MasterFactorEntity>(factor, factor.name))
            .toList();
        _selectedFactorsForFeelings[feeling] = []; // Initialize with empty list
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
            return BentoBox(
              gridWidth: 4,
              gridHeight: 3,
              child: Column(
                children: [
                  Text('Why are you ${feeling.feeling}?'),
                  Builder(
                    builder: (BuildContext buildContext) {
                      if (items.isNotEmpty) {
                        return MultiSelectChipField<MasterFactorEntity>(
                          items: items,
                          initialValue: selectedFactors,
                          showHeader: false,
                          searchable: true,
                          chipWidth: 50,
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Colors.black12),
                            ),
                          ),
                          itemBuilder: (MultiSelectItem<MasterFactorEntity?>
                                  item,
                              FormFieldState<List<MasterFactorEntity?>> state) {
                            return Button(
                              text: item.value!.name,
                              onPressed: () {
                                setState(() {
                                  bool isAlreadySelected =
                                      selectedFactors.contains(item.value);
                                  if (isAlreadySelected) {
                                    selectedFactors.remove(item.value);
                                  } else {
                                    selectedFactors.add(item.value!);
                                  }
                                });
                              },
                              icon: selectedFactors.contains(item.value)
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
      selectedFeelings:
          store.state.moodEditorState.currentMoodLog?.feelings ?? [],
    );
  }
}
