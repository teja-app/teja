// lib/pages/habits_page.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:swayam/domain/entities/habit_entity.dart';

Future<List<HabitEntity>> loadHabitsFromJson() async {
  String jsonString = await rootBundle.loadString(
    'assets/habit/habits.json',
  );
  Map<String, dynamic> jsonResponse = json.decode(jsonString);
  List<dynamic> habitsJson = jsonResponse['habits'];

  return habitsJson
      .map(
        (json) => HabitEntity(
          id: json['id'],
          title: json['title'],
          description: json['description'],
          frequency: json['frequency'],
          unit: json['unit'],
          quantity: json['quantity'],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      )
      .toList();
}

Future<List<String>> loadCategoriesFromJson() async {
  String jsonString = await rootBundle.loadString(
    'assets/habit/categories.json',
  );
  return List<String>.from(json.decode(jsonString));
}

class CategoryListItem extends StatelessWidget {
  final String category;
  final VoidCallback onTap;

  const CategoryListItem({
    Key? key,
    required this.category,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(category),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class HabitsPage extends StatefulWidget {
  const HabitsPage({Key? key}) : super(key: key);

  @override
  _HabitsPageState createState() => _HabitsPageState();
}

class _HabitsPageState extends State<HabitsPage> {
  late Future<List<HabitEntity>> _habitsFuture;
  late Future<List<String>> _categoriesFuture;
  String? _selectedCategory;
  List<HabitEntity> _allHabits = []; // Initialize as an empty list

  @override
  void initState() {
    super.initState();
    _habitsFuture = loadHabitsFromJson().then((habits) {
      _allHabits = habits;
      return habits;
    });
    _categoriesFuture = loadCategoriesFromJson();
  }

  void _onCategoryTap(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  List<HabitEntity> _getHabitsForSelectedCategory() {
    if (_selectedCategory == null) {
      return [];
    }
    return _allHabits
        .where((habit) => habit.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedCategory ?? 'Habits'),
      ),
      body: FutureBuilder<List<String>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else if (snapshot.hasData) {
            return ListView(
              children: [
                if (_selectedCategory == null)
                  ...snapshot.data!.map((category) => CategoryListItem(
                        category: category,
                        onTap: () => _onCategoryTap(category),
                      )),
                if (_selectedCategory != null)
                  ..._getHabitsForSelectedCategory().map((habit) => ListTile(
                        title: Text(habit.title),
                        subtitle: Text(habit.description),
                      )),
              ],
            );
          } else {
            return const Center(child: Text('No categories found'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          // Navigate to the habit creation page
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
