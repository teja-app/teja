import 'package:flutter/material.dart';
import 'package:teja/domain/entities/feeling.dart';
import 'package:teja/shared/common/bento_box.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:teja/domain/entities/master_feeling.dart';
import 'package:teja/domain/redux/app_state.dart';

class FeelingsListWidget extends StatelessWidget {
  final List<FeelingEntity> feelings;

  const FeelingsListWidget({
    Key? key,
    required this.feelings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return StoreConnector<AppState, List<MasterFeelingEntity>>(
      converter: (store) => store.state.masterFeelingState.masterFeelings ?? [],
      builder: (context, masterFeelings) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Feelings',
              style: TextStyle(color: Colors.grey, fontSize: 22),
            ),
            const SizedBox(height: 8),
            ...feelings.map(
              (feeling) {
                // Find the corresponding MasterFeelingEntity by slug
                var masterFeeling = masterFeelings.firstWhere(
                  (mFeeling) => mFeeling.slug == feeling.feeling,
                  orElse: () => MasterFeelingEntity(
                    slug: feeling.feeling,
                    name: "Unknown",
                    energy: 0,
                    pleasantness: 0,
                  ),
                );
                return BentoBox(
                  gridWidth: 4,
                  gridHeight: 1,
                  child: Column(
                    children: [
                      Text(
                        masterFeeling.name,
                        style: textTheme.titleLarge,
                      ),
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
