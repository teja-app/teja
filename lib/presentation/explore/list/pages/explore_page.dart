import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/featured_journal_template_entity.dart';
import 'package:teja/domain/entities/journal_category_entity.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/presentation/explore/widgets/custom_category_card.dart';
import 'package:teja/presentation/explore/widgets/custom_search_field.dart';
import 'package:teja/presentation/explore/widgets/custom_title.dart';
import 'package:teja/presentation/journal/ui/journal_template_card.dart';
import 'package:teja/presentation/navigation/buildDesktopDrawer.dart';
import 'package:teja/presentation/navigation/isDesktop.dart';
import 'package:teja/presentation/navigation/mobile_navigation_bar.dart';
import 'package:teja/router.dart';
import 'package:teja/theme/padding.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  ExplorePageState createState() => ExplorePageState();
}

class ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    final mainBody = StoreConnector<AppState, ExplorePageViewModel>(
      converter: (store) => ExplorePageViewModel.fromStore(store),
      builder: (context, viewModel) {
        return getBody(viewModel);
      },
    );

    return Scaffold(
      bottomNavigationBar: isDesktop(context) ? null : MobileNavigationBar(),
      body: isDesktop(context)
          ? Row(
              children: [
                buildDesktopNavigationBar(context),
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: mainBody,
                  ),
                ),
              ],
            )
          : mainBody,
    );
  }

  Widget getBody(ExplorePageViewModel viewModel) {
    var size = MediaQuery.of(context).size;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: appPadding, right: appPadding),
            child: Column(
              children: <Widget>[
                const SizedBox(height: spacer + 24),
                //search
                CustomSearchField(
                  hintField: 'Try "Focus"',
                  backgroundColor: colorScheme.surface,
                ),
              ],
            ),
          ),
          const SizedBox(height: spacer),
          _buildFeaturedCategories(viewModel),
          const SizedBox(height: spacer),
          _buildFeaturedTemplates(viewModel),
          const SizedBox(height: spacer),
          const CustomCategoryCard(),
        ],
      ),
    );
  }

  Widget _buildFeaturedCategories(ExplorePageViewModel viewModel) {
    List<JournalCategoryEntity> featuredCategories = viewModel
        .categoriesById.values
        .where((category) => category.isFeatured)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: appPadding),
          child: CustomTitle(
            title: 'Topics',
            route: RootPath.journalCategory,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: appPadding, right: appPadding),
        ),
        const SizedBox(height: smallSpacer),
        SizedBox(
          height: 200, // Adjust this value as needed
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: featuredCategories.length,
            itemBuilder: (context, index) {
              final category = featuredCategories[index];
              return Padding(
                padding: const EdgeInsets.only(left: appPadding, right: 8),
                child: GestureDetector(
                  onTap: () => navigateToCategoryDetail(context, category.id),
                  child: SizedBox(
                    width: 150, // Adjust this value as needed
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
                                ? CachedNetworkImage(
                                    imageUrl:
                                        '${category.featureImage?.sizes.thumbnail?.url}',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        Container(color: Colors.grey[300]),
                                    errorWidget: (context, url, error) =>
                                        Container(color: Colors.grey[300]),
                                  )
                                : Container(color: Colors.grey[300]),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              category.name,
                              style: Theme.of(context).textTheme.titleSmall,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedTemplates(ExplorePageViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: appPadding),
          child: Text("Featured Templates",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: smallSpacer),
        SizedBox(
          height: 200, // Adjust this value as needed
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: viewModel.featuredTemplates.length,
            itemBuilder: (context, index) {
              final template = viewModel.featuredTemplates[index];
              final journalTemplateEntity =
                  viewModel.templatesById[template.template];
              return Padding(
                padding: const EdgeInsets.only(left: appPadding, right: 8),
                child: JournalTemplateCard(
                  template: journalTemplateEntity!,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void navigateToCategoryDetail(BuildContext context, String categoryId) {
    GoRouter.of(context).pushNamed(
      RootPath.journalCategoryDetail,
      queryParameters: {"id": categoryId},
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
