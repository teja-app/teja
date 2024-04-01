import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:redux/redux.dart';
import 'package:rive/rive.dart';
import 'package:teja/domain/entities/journal_category_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/journal_category/actions.dart';
import 'package:teja/router.dart';
import 'package:teja/shared/common/bento_box.dart';
import 'package:teja/shared/common/button.dart';
import 'package:teja/theme/padding.dart'; // Import BentoBox

class JournalCategoriesPage extends StatelessWidget {
  const JournalCategoriesPage({super.key});

  void navigateToCategoryDetail(BuildContext context, String categoryId) {
    GoRouter.of(context).pushNamed(
      RootPath.journalCategoryDetail, // Assuming you've defined this in your router's path
      queryParameters: {
        "id": categoryId,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("Journal"),
      ),
      body: StoreConnector<AppState, _ViewModel>(
        converter: _ViewModel.fromStore,
        onInit: (store) {
          store.dispatch(FetchJournalCategoriesActionFromApi());
        },
        builder: (context, vm) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: spacer,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 150,
                      child: RiveAnimation.asset('assets/journal/girl_and_dog.riv'),
                    ),
                    const SizedBox(height: smallSpacer),
                    Text(
                      "Unlock Your Journey",
                      style: textTheme.titleLarge,
                    ),
                    const SizedBox(height: smallSpacer),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20),
                      child: Text(
                        "Imagine a space where every tool is tailored just for you, helping to illuminate paths you've yet to explore.",
                        style: textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: spacer,
                ),
                Wrap(
                  spacing: 8.0, // Space between the boxes horizontally
                  runSpacing: 16.0, // Space between the boxes vertically
                  children: List<Widget>.generate(vm.categories.length, (index) {
                    final category = vm.categories[index];
                    return GestureDetector(
                      onTap: () => navigateToCategoryDetail(context, category.id),
                      child: BentoBox(
                          gridWidth: 2,
                          gridHeight: 3,
                          margin: 16,
                          padding: 4,
                          child: Stack(
                            children: [
                              // If featureImage is not null, display the image covering the stack
                              if (category.featureImage != null)
                                Positioned.fill(
                                  child: Image.network(
                                    'https://f000.backblazeb2.com/file/swayam-dev-master/${category.featureImage?.sizes.thumbnail?.filename}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              // Positioned text at the bottom of the stack
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(extraSmallSpacer), // Use your defined smallSpacer for padding
                                  color: colorScheme.background.withOpacity(1),
                                  child: Text(
                                    category.name,
                                    maxLines: 3,
                                    textAlign: TextAlign.center, // Center the text (optional)
                                    style: textTheme.titleSmall, // Your predefined text theme
                                  ),
                                ),
                              ),
                            ],
                          )),
                    );
                  }),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ViewModel {
  final List<JournalCategoryEntity> categories;

  _ViewModel({
    required this.categories,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      categories: store.state.journalCategoryState.categories,
    );
  }
}
