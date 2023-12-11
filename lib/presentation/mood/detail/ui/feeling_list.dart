import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/feeling.dart';
import 'package:teja/domain/entities/master_factor.dart';
// import 'package:teja/shared/common/bento_box.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:teja/domain/entities/master_feeling.dart';
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
            const Text(
              'Feelings',
              style: TextStyle(color: Colors.grey, fontSize: 22),
            ),
            const SizedBox(height: 8),
            ...viewModel.feelingWithSubCategories.map(
              (feelingWithSub) {
                return FlexibleHeightBox(
                  gridWidth: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feelingWithSub.masterFeeling.name,
                        style: textTheme.titleLarge,
                      ),
                      ...feelingWithSub.subCategories.map((subCategory) => Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              subCategory.title,
                              style: textTheme.subtitle1,
                            ),
                          )),
                    ],
                  ),
                );
              },
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
      var masterFeeling = store.state.masterFeelingState.masterFeelings.firstWhere(
        (mFeeling) => mFeeling.slug == feelingEntity.feeling,
        orElse: () => MasterFeelingEntity(
          slug: feelingEntity.feeling,
          name: "Unknown",
          energy: 0,
          pleasantness: 0,
        ),
      );

      var subCategories = feelingEntity.factors?.map((slug) {
            return store.state.masterFactorState.masterFactors.expand((factor) => factor.subcategories).firstWhere(
                  (subCategory) => subCategory.slug == slug,
                  orElse: () => SubCategoryEntity(slug: slug, title: "Unknown"),
                );
          }).toList() ??
          [];

      return FeelingWithSubCategories(masterFeeling: masterFeeling, subCategories: subCategories);
    }).toList();

    return FeelingsListViewModel(
      feelingWithSubCategories: feelingWithSubCategories,
    );
  }
}

class FeelingWithSubCategories {
  final MasterFeelingEntity masterFeeling;
  final List<SubCategoryEntity> subCategories;

  FeelingWithSubCategories({
    required this.masterFeeling,
    required this.subCategories,
  });
}
