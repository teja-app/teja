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
                GridView.builder(
                  // You might not need these if using Expanded, but they are here if you choose shrinkWrap
                  // shrinkWrap: true,
                  // physics: NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Adjust based on your design needs
                    childAspectRatio: 1.0, // Adjust based on your design needs
                  ),
                  physics: const NeverScrollableScrollPhysics(), // Disable scrolling inside GridView
                  shrinkWrap: true,
                  itemCount: vm.categories.length,
                  itemBuilder: (context, index) {
                    final category = vm.categories[index];
                    return GestureDetector(
                      onTap: () => navigateToCategoryDetail(context, category.id),
                      child: BentoBox(
                        gridWidth: 1,
                        gridHeight: 2,
                        margin: 16,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (category.featureImage != null)
                              Image.network(
                                'https://f000.backblazeb2.com/file/swayam-dev-master/${category.featureImage?.sizes.thumbnail?.filename}',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            const SizedBox(height: smallSpacer),
                            Text(
                              maxLines: 3,
                              category.name,
                              style: textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
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
