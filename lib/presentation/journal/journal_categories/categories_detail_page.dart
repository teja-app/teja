import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/entities/journal_category_entity.dart';

class CategoryDetailPage extends StatelessWidget {
  final String categoryId;

  const CategoryDetailPage({Key? key, required this.categoryId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, JournalCategoryEntity?>(
      converter: (store) => store.state.journalCategoryState.categoriesById[categoryId],
      builder: (context, category) {
        if (category == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('Category not found')),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(category.name),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (category.featureImage != null)
                    Center(
                      child: Image.network(
                        'https://f000.backblazeb2.com/file/swayam-dev-master/${category.featureImage?.sizes.card?.filename}',
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 24),
                  Text(
                    category.name,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    category.description,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
