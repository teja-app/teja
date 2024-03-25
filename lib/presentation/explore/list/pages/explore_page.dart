import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/featured_journal_template_entity.dart';
import 'package:teja/domain/entities/journal_category_entity.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/presentation/journal/journal_templates/ui/journal_template_card.dart';
import 'package:teja/presentation/navigation/buildMobileNavigationBar.dart';
import 'package:teja/presentation/navigation/isDesktop.dart';
import 'package:teja/router.dart';
import 'package:teja/theme/padding.dart';
import 'package:teja/presentation/explore/widgets/clipper.dart';
import 'package:teja/presentation/explore/widgets/custom_categories_button.dart';
import 'package:teja/presentation/explore/widgets/custom_category_card.dart';
import 'package:teja/presentation/explore/widgets/custom_promotion_card.dart';
import 'package:teja/presentation/explore/widgets/custom_search_field.dart';
import 'package:teja/presentation/explore/widgets/custom_title.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class ExplorePage extends StatefulWidget {
  const ExplorePage({
    Key? key,
  }) : super(key: key);

  @override
  ExplorePageState createState() => ExplorePageState();
}

class ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      bottomNavigationBar: isDesktop(context) ? null : buildMobileNavigationBar(context),
      backgroundColor: colorScheme.background,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      body: StoreConnector<AppState, ExplorePageViewModel>(
        converter: (store) => ExplorePageViewModel.fromStore(store),
        builder: (context, viewModel) {
          return getBody(viewModel);
        },
      ),
    );
  }

  void navigateToCategoryDetail(BuildContext context, String categoryId) {
    GoRouter.of(context).pushNamed(
      RootPath.journalCategoryDetail, // Assuming you've defined this path in your router
      queryParameters: {
        "id": categoryId,
      },
    );
  }

  Widget getBody(ExplorePageViewModel viewModel) {
    var size = MediaQuery.of(context).size;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: spacer),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              ClipPath(
                clipper: BottomClipper(),
                child: Container(
                    width: size.width,
                    height: 300.0,
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: appPadding, right: appPadding),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: spacer + 24),
                    //search
                    CustomSearchField(
                      hintField: 'Try "Seneca"',
                      backgroundColor: colorScheme.background,
                    ),
                    const SizedBox(height: spacer - 30.0),
                    //categoy card
                    const CustomCategoryCard(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: smallSpacer),
          StoreConnector<AppState, ExplorePageViewModel>(
            converter: (store) => ExplorePageViewModel.fromStore(store),
            builder: (context, vm) {
              // Convert the map entries to a list for easier manipulation
              var categoriesList = vm.categoriesById.entries.toList();
              // Calculate the split index based on the total number of categories
              int splitIndex = categoriesList.length ~/ 2 + categoriesList.length % 2;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(
                  left: appPadding,
                  right: appPadding - 10.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: categoriesList.sublist(0, splitIndex).map((entry) {
                        return CustomCategoriesButton(
                          title: entry.value.name,
                          onTap: () => navigateToCategoryDetail(context, entry.key),
                        );
                      }).toList(),
                    ),
                    Row(
                      children: categoriesList.sublist(splitIndex).map((entry) {
                        return CustomCategoriesButton(
                          title: entry.value.name,
                          onTap: () => navigateToCategoryDetail(context, entry.key),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: smallSpacer),
          //promotion card
          const CustomPromotionCard(),
          const SizedBox(height: smallSpacer),
          //feature courses
          const Padding(
            padding: EdgeInsets.only(left: appPadding, right: appPadding),
            child: CustomTitle(
              title: 'Featured Journals',
              route: RootPath.journalCategory,
            ),
          ),
          const SizedBox(height: smallSpacer),
          StoreConnector<AppState, List<JournalTemplateEntity>>(
              converter: (store) => store.state.journalTemplateState.templates.take(5).toList(),
              builder: (context, templates) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(
                    left: appPadding,
                    right: appPadding - 10.0,
                  ),
                  child: Wrap(
                    children: List.generate(viewModel.featuredTemplates.length, (index) {
                      var data = viewModel.featuredTemplates[index];
                      JournalTemplateEntity? journalTemplateEntity = viewModel.templatesById[data.template];
                      return Padding(
                        padding: const EdgeInsets.only(right: 15.0, bottom: 20.0),
                        child: GestureDetector(
                          onTap: () {},
                          child: JournalTemplateCard(
                            template: journalTemplateEntity!,
                            templateType: JournalTemplateCardCardType.bento,
                          ),
                        ),
                      );
                    }),
                  ),
                );
              }),
          const SizedBox(height: spacer - 20.0),
        ],
      ),
    );
  }
}

class ExplorePageViewModel {
  final bool isLoading;
  final String? errorMessage;
  final List<FeaturedJournalTemplateEntity> featuredTemplates;
  final Map<String, JournalTemplateEntity> templatesById;
  final Map<String, JournalCategoryEntity> categoriesById;

  ExplorePageViewModel({
    required this.isLoading,
    this.errorMessage,
    required this.featuredTemplates,
    required this.templatesById,
    required this.categoriesById,
  });

  // Factory constructor to create ViewModel from the Redux store state
  factory ExplorePageViewModel.fromStore(Store<AppState> store) {
    final state = store.state.featuredJournalTemplateState;
    final journalTemplateState = store.state.journalTemplateState;
    return ExplorePageViewModel(
      isLoading: state.isLoading,
      errorMessage: state.errorMessage,
      featuredTemplates: state.templates,
      templatesById: journalTemplateState.templatesById,
      categoriesById: store.state.journalCategoryState.categoriesById,
    );
  }
}
