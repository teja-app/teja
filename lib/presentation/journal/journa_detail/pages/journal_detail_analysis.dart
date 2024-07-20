import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JournalDetailAnalysis extends StatelessWidget {
  final Map<String, dynamic> journalData;

  const JournalDetailAnalysis({Key? key, required this.journalData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Parse the date string from the journalData
    DateTime entryDate = DateTime.now();
    String formattedDate = DateFormat('EEEE, MMMM d @ h:mm a').format(entryDate);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              journalData['summary']['emoticon'],
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                formattedDate,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Implement share functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Implement more options functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    journalData['summary']['title'],
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildTabs(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildReflectionCard(),
                  const SizedBox(height: 16),
                  _buildKeyInsightCard(),
                  const SizedBox(height: 16),
                  _buildEmotionsSection(),
                  const SizedBox(height: 16),
                  _buildPeopleSection(),
                  const SizedBox(height: 16),
                  _buildTopicsSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return const Row(
      children: [
        Expanded(
          child: Text(
            'Analysis',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(
            'Entry',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildReflectionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ENTRY REFLECTION',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Icon(Icons.share, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 8),
            Text(journalData['summary']['content']),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyInsightCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '💡 KEY INSIGHT',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Icon(Icons.share, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 8),
            Text(journalData['keyInsight']),
          ],
        ),
      ),
    );
  }

  Widget _buildEmotionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('FEELINGS', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: journalData['emotions'].map<Widget>((emotion) {
            return Chip(
              label: Text('${emotion['emoticon']} ${emotion['title']}'),
              onDeleted: () {
                // Implement delete functionality
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPeopleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('PEOPLE', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Add'),
          onPressed: () {
            // Implement add person functionality
          },
        ),
      ],
    );
  }

  Widget _buildTopicsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('TOPICS', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            ...journalData['topics'].map<Widget>((topic) {
              return Chip(
                label: Text('${topic['emoticon']} ${topic['title']}'),
                onDeleted: () {
                  // Implement delete functionality
                },
              );
            }).toList(),
            OutlinedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add'),
              onPressed: () {
                // Implement add topic functionality
              },
            ),
          ],
        ),
      ],
    );
  }
}
