import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/vision_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/visions/vision_action.dart';
import 'package:teja/presentation/goal_editor/ui/vision_card.dart';
import 'package:teja/shared/common/button.dart';

class VisionPickerPage extends StatefulWidget {
  const VisionPickerPage({super.key});

  @override
  _VisionPickerPageState createState() => _VisionPickerPageState();
}

class _VisionPickerPageState extends State<VisionPickerPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final store = StoreProvider.of<AppState>(context);
      store.dispatch(LoadVisionsAction());
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.fromStore(store),
      builder: (context, viewModel) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Your visions/aspiration'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Which areas of your life are you most excited to enhance? Let's prioritize your journey. Don't worry you can edit this any time.",
                  style: textTheme.titleSmall,
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.allVisions.length,
                    itemBuilder: (context, index) {
                      final vision = viewModel.allVisions[index];
                      final isSelected = viewModel.isSelected(vision.slug);

                      return VisionCard(
                        vision: vision.copyWith(isSelected: isSelected),
                        onTap: () => viewModel.onVisionTap(vision.slug),
                      );
                    },
                  ),
                ),
                Button(
                  text: "Save Vision",
                  buttonType: ButtonType.primary,
                  width: 200,
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    // Handle save action
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ViewModel {
  final Store<AppState> store;
  final List<Vision> allVisions;

  _ViewModel({required this.store})
      : allVisions = [
          Vision(
            iconData: Icons.work,
            title: 'Career Growth',
            description: 'Enhance your professional skills and career advancement.',
            slug: 'career-growth',
          ),
          Vision(
            iconData: Icons.health_and_safety,
            title: 'Wellness',
            description: 'Focus on physical health, mental well-being, and a balanced lifestyle.',
            slug: 'wellness',
          ),
          Vision(
            iconData: Icons.lightbulb,
            title: 'Self-Improvement',
            description: 'Work on personal growth and learn new skills.',
            slug: 'self-improvement',
          ),
          Vision(
            iconData: Icons.group,
            title: 'Social Life',
            description: 'Strengthen relationships and engage in community activities.',
            slug: 'social-life',
          ),
          Vision(
            iconData: Icons.account_balance_wallet,
            title: 'Financial Health',
            description: 'Work towards financial security and effective wealth management.',
            slug: 'financial-health',
          ),
          Vision(
            iconData: Icons.airplanemode_active,
            title: 'Adventures',
            description: 'Seek new experiences and explore for adventure and discovery.',
            slug: 'adventures',
          ),
          Vision(
            iconData: Icons.volunteer_activism,
            title: 'Social Impact',
            description: 'Contribute to society and make a positive impact in your community.',
            slug: 'social-impact',
          ),
        ];
  List<VisionEntity> get visions => store.state.visionState.visions;

  bool isSelected(String slug) => visions.any((v) => v.slug == slug);

  void onVisionTap(String slug) {
    store.dispatch(VisionToggleAction(slug));
  }

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(store: store);
  }
}
