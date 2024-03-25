import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/presentation/explore/widgets/custom_search_field.dart';
import 'package:teja/presentation/journal/ui/journal_template_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              setState(() {}); // Refresh the page to apply the clear filter
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              decoration: const InputDecoration(
                labelText: "Search",
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          Expanded(
            child: StoreConnector<AppState, _SearchPageModel>(
              converter: (store) => _SearchPageModel.fromStore(store),
              builder: (context, vm) {
                final filteredTemplates = vm.templates.where((template) {
                  final query = _searchController.text.toLowerCase();
                  return template.title.toLowerCase().contains(query) ||
                      template.description.toLowerCase().contains(query);
                }).toList();

                return ListView.builder(
                  itemCount: filteredTemplates.length,
                  itemBuilder: (context, index) {
                    return JournalTemplateCard(template: filteredTemplates[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchPageModel {
  final List<JournalTemplateEntity> templates;
  final bool isLoading;
  final String? errorMessage;

  _SearchPageModel({
    required this.templates,
    required this.isLoading,
    this.errorMessage,
  });

  static _SearchPageModel fromStore(Store<AppState> store) {
    final state = store.state.journalTemplateState;
    return _SearchPageModel(
      templates: state.templates,
      isLoading: state.isLoading,
      errorMessage: state.errorMessage,
    );
  }
}
