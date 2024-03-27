import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:teja/shared/common/button.dart';

void showProBottomSheet(BuildContext context, {bool showProPrompt = false}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return showProPrompt
          ? const ProVersionStreakChallengeSheet()
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(AntDesign.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Expanded(
                  child: ProVersionStreakChallengeSheet(),
                ),
              ],
            );
    },
  );
}

class ProVersionStreakChallengeSheet extends StatelessWidget {
  const ProVersionStreakChallengeSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '23-Day Streak Challenge',
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Text(
              'Embark on a 23-day journey with Teja to deepen your journaling and mood tracking habit. Complete daily tasks to unlock Pro features for free!',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            // Bullet Points for Tasks
            Text(
              'Your Daily Tasks:',
              style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '• Track your mood at least once a day.\n• Create a journal entry every day.\nThat’s it! Simple, right?',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Image.asset(
              'assets/background/streak_challenge.webp',
              fit: BoxFit.cover,
              height: 300,
            ),
            const SizedBox(height: 20),
            Text(
              'Ready to transform your self-care routine and unlock the full potential of Teja? Start your streak today and witness the growth in your journaling journey!',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Button(
              text: "Start Challenge",
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Challenge started! Check your daily task."),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
              buttonType: ButtonType.primary,
            ),
            const Button(
              text: "Skip the Challenge, Buy Pro Now(Coming Soon)",
              icon: AntDesign.shoppingcart,
              buttonType: ButtonType.secondary,
              // This is commented out to indicate the button is not active yet
              // onPressed: () {},
            ),
            // Other widgets remain unchanged
          ],
        ),
      ),
    );
  }
}
