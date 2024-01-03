import 'package:flutter/material.dart';
import 'package:teja/domain/entities/journal_template_entity.dart';
import 'package:teja/infrastructure/api/journal_template_api.dart';
import 'package:teja/presentation/journal_templates/ui/journal_template_card.dart';

class JournalTemplateListScreen extends StatefulWidget {
  @override
  JournalTemplateListScreenState createState() => JournalTemplateListScreenState();
}

class JournalTemplateListScreenState extends State<JournalTemplateListScreen> {
  List<JournalTemplateEntity> templates = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTemplates();
  }

  Future<void> _fetchTemplates() async {
    print("_fetchTemplates");
    try {
      var journalTemplateApi = JournalTemplateApi(); // Assuming this is how you instantiate it
      templates = await journalTemplateApi.getJournalTemplates(null); // Replace 'null' with actual auth token if needed
      print("templates ${templates}");
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        // Handle the error or show an error message
      });
      print("Error fetching templates: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Journal Templates"),
      ),
      body: ListView.builder(
        itemCount: templates.length,
        itemBuilder: (context, index) {
          return JournalTemplateCard(template: templates[index]);
        },
      ),
    );
  }
}
