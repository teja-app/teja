import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';
import 'package:teja/domain/redux/app_state.dart';
import 'package:teja/domain/redux/journal/journal_template/actions.dart';
import 'package:teja/presentation/journal/journal_templates/ui/journal_template_card.dart';

class JournalTemplateListScreen extends StatelessWidget {
  const JournalTemplateListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Journal Templates"),
      ),
      body: StoreConnector<AppState, _JournalTemplateListViewModel>(
        onInit: (store) => store.dispatch(FetchJournalTemplatesActionFromCache()),
        converter: (store) => _JournalTemplateListViewModel.fromStore(store),
        builder: (context, vm) {
          print("vm.templates.length ${vm.templates.length}");
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (vm.errorMessage != null) {
            return Center(child: Text('Error: ${vm.errorMessage}'));
          } else {
            return ListView.builder(
              itemCount: vm.templates.length,
              itemBuilder: (context, index) {
                return JournalTemplateCard(template: vm.templates[index]);
              },
            );
          }
        },
      ),
    );
  }
}

class _JournalTemplateListViewModel {
  final List<JournalTemplateEntity> templates;
  final bool isLoading;
  final String? errorMessage;

  _JournalTemplateListViewModel({
    required this.templates,
    required this.isLoading,
    required this.errorMessage,
  });

  static _JournalTemplateListViewModel fromStore(Store<AppState> store) {
    final state = store.state.journalTemplateState;
    return _JournalTemplateListViewModel(
      templates: state.templates,
      isLoading: state.isLoading,
      errorMessage: state.errorMessage,
    );
  }
}
