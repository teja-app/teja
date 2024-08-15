import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/journal_category_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/journal_category/actions.dart';
import 'package:teja/router.dart';
import 'package:teja/theme/padding.dart';

class JournalCategoriesPage extends StatelessWidget {
  const JournalCategoriesPage({Key? key}) : super(key: key);

  void navigateToCategoryDetail(BuildContext context, String categoryId) {
    GoRouter.of(context).pushNamed(
      RootPath.journalCategoryDetail,
      queryParameters: {"id": categoryId},
    );
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Journal"),
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
                const SizedBox(height: spacer),
                Text("Unlock Your Journey", style: textTheme.titleLarge),
                const SizedBox(height: smallSpacer),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "Imagine a space where every tool is tailored just for you, helping to illuminate paths you've yet to explore.",
                    style: textTheme.labelSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: spacer),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: vm.categories.length,
                  itemBuilder: (context, index) {
                    final category = vm.categories[index];
                    return GestureDetector(
                      onTap: () => navigateToCategoryDetail(context, category.id),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: category.featureImage != null
                                  ? Image.network(
                                      'https://f000.backblazeb2.com/file/swayam-dev-master/${category.featureImage?.sizes.thumbnail?.filename}',
                                      fit: BoxFit.cover,
                                    )
                                  : Container(color: Colors.grey[300]),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                category.name,
                                style: textTheme.titleSmall,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
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

  _ViewModel({required this.categories});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(categories: store.state.journalCategoryState.categories);
  }
}
