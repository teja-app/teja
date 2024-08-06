import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/entities/journal_category_entity.dart';
import 'package:teja/presentation/journal/ui/journal_template_card.dart';
import 'package:teja/presentation/navigation/isDesktop.dart';
import 'package:teja/theme/padding.dart';

class CategoryDetailPage extends StatelessWidget {
  final String categoryId;

  const CategoryDetailPage({Key? key, required this.categoryId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _CategoryDetailViewModel>(
      converter: (store) =>
          _CategoryDetailViewModel.fromStore(store, categoryId),
      builder: (context, vm) {
        if (vm.category == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('Category not found')),
          );
        }

        bool tablet = isDesktop(context);

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: SingleChildScrollView(
            padding: tablet
                ? const EdgeInsets.symmetric(horizontal: 32.0)
                : const EdgeInsets.all(0.0),
            child: tablet
                ? _buildTabletLayout(context, vm)
                : _buildMobileLayout(context, vm),
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context, _CategoryDetailViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://f000.backblazeb2.com/file/swayam-dev-master/${vm.category!.featureImage?.sizes.card?.filename}',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Theme.of(context).scaffoldBackgroundColor,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16.0,
              bottom: 16.0,
              child: Text(
                vm.category!.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                vm.category!.description,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: smallSpacer),
              Text(
                "Journal",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: miniSpacer),
              Wrap(
                children: List.generate(vm.templates.length, (index) {
                  var data = vm.templates[index];
                  JournalTemplateEntity? journalTemplateEntity = data;
                  return GestureDetector(
                    onTap: () {},
                    child: JournalTemplateCard(
                      template: journalTemplateEntity!,
                      templateType: JournalTemplateCardCardType.flexible,
                      gridWidth: 4,
                    ),
                  );
                }),
              ),
              const SizedBox(height: spacer),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context, _CategoryDetailViewModel vm) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double maxWidth = screenWidth > 630 ? 630 : screenWidth * 0.75;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          16.0, 80.0, 16.0, 16.0), // Added top padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: maxWidth,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: AspectRatio(
                    aspectRatio: 1, // This will make the container square
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            'https://f000.backblazeb2.com/file/swayam-dev-master/${vm.category!.featureImage?.sizes.card?.filename}',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        vm.category!.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        vm.category!.description,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32.0),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Journal",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: miniSpacer),
                Wrap(
                  children: List.generate(vm.templates.length, (index) {
                    var data = vm.templates[index];
                    JournalTemplateEntity? journalTemplateEntity = data;
                    return GestureDetector(
                      onTap: () {},
                      child: JournalTemplateCard(
                        template: journalTemplateEntity!,
                        templateType: JournalTemplateCardCardType.flexible,
                        gridWidth: 2,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryDetailViewModel {
  final JournalCategoryEntity? category;
  final List<JournalTemplateEntity> templates;

  _CategoryDetailViewModel({this.category, required this.templates});

  static _CategoryDetailViewModel fromStore(
      Store<AppState> store, String categoryId) {
    // Fetch the category by its ID
    final category =
        store.state.journalCategoryState.categoriesById[categoryId];
    // Fetch templates for the category
    final templates =
        store.state.journalTemplateState.templatesByCategory[categoryId] ?? [];

    return _CategoryDetailViewModel(
      category: category,
      templates: templates,
    );
  }
}
