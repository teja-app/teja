import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/feeling.dart';
import 'package:teja/domain/entities/master_factor.dart';
// import 'package:teja/shared/common/bento_box.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:teja/domain/entities/master_feeling_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/shared/common/flexible_height_box.dart';

class FeelingsListWidget extends StatelessWidget {
  final List<FeelingEntity> feelings;

  const FeelingsListWidget({
    Key? key,
    required this.feelings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return StoreConnector<AppState, FeelingsListViewModel>(
      converter: (store) => FeelingsListViewModel.fromStore(store, feelings),
      builder: (context, viewModel) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Feelings',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            FlexibleHeightBox(
              gridWidth: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (viewModel.feelingWithSubCategories.isNotEmpty)
                    ...viewModel.feelingWithSubCategories.map(
                      (feelingWithSub) {
                        return Text(
                          feelingWithSub.masterFeeling!.name,
                          style: textTheme.titleSmall,
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class FeelingsListViewModel {
  final List<FeelingWithSubCategories> feelingWithSubCategories;

  FeelingsListViewModel({
    required this.feelingWithSubCategories,
  });

  static FeelingsListViewModel fromStore(Store<AppState> store, List<FeelingEntity> feelings) {
    List<FeelingWithSubCategories> feelingWithSubCategories = feelings.map((feelingEntity) {
      var existingFeelings = store.state.masterFeelingState.masterFeelings;

      MasterFeelingEntity? existingFeeling = existingFeelings.isNotEmpty
          ? existingFeelings.firstWhere((mFeeling) => mFeeling.slug == feelingEntity.feeling,
              orElse: () => MasterFeelingEntity(
                    name: "Unknown",
                    slug: "unknown",
                    type: "feeling",
                  ))
          : null;

      var subCategories = feelingEntity.factors?.map((slug) {
            return store.state.masterFactorState.masterFactors.expand((factor) => factor.subcategories).firstWhere(
                  (subCategory) => subCategory.slug == slug,
                  orElse: () => SubCategoryEntity(slug: slug, title: "Unknown"),
                );
          }).toList() ??
          [];

      return FeelingWithSubCategories(masterFeeling: existingFeeling, subCategories: subCategories);
    }).toList();

    return FeelingsListViewModel(
      feelingWithSubCategories: feelingWithSubCategories,
    );
  }
}

class FeelingWithSubCategories {
  final MasterFeelingEntity? masterFeeling;
  final List<SubCategoryEntity> subCategories;

  FeelingWithSubCategories({
    required this.masterFeeling,
    required this.subCategories,
  });
}
