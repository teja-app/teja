import 'dart:math';
import 'package:teja/infrastructure/constants/notification_types.dart';

class NotificationMessages {
  static final Random _random = Random();

  static Map<String, String> getRandomMessage(String key) {
    final messages = _notificationMessages[key];
    if (messages != null && messages.isNotEmpty) {
      return messages[_random.nextInt(messages.length)];
    }
    return {'title': 'Reminder', 'body': 'It\'s time!'};
  }

  static final Map<String, List<Map<String, String>>> _notificationMessages = {
    NotificationType.MORNING_KICKSTART: [
      {
        'title': '🌅 Rise and Shine!',
        'body': 'Start your day with intention and positivity.'
      },
      {
        'title': '🌟 Good Morning, Achiever!',
        'body': 'What\'s your top priority for today?'
      },
      {
        'title': '🧘 Morning Reflection Time',
        'body': 'Take a moment to set your intentions for the day ahead.'
      },
      {
        'title': '🚀 Seize the Day!',
        'body': 'Every morning is a fresh start. Make it count!'
      },
      {
        'title': '💪 Morning Motivation',
        'body': 'You\'ve got this! What small win will you achieve today?'
      },
      {
        'title': '🔋 Energize Your Morning',
        'body': 'Take a deep breath and visualize a successful day.'
      },
      {
        'title': '🌠 Dawn of Possibilities',
        'body': 'What exciting opportunities await you today?'
      },
      {
        'title': '🧠 Morning Mindfulness',
        'body': 'Start with a moment of gratitude. What are you thankful for?'
      },
      {
        'title': '🏁 Kickstart Your Day',
        'body': 'Time to fuel your body and mind for success!'
      },
      {
        'title': '☀️ Hello, Sunshine!',
        'body': 'What positive affirmation will guide your day?'
      },
      {
        'title': '🌱 Fresh Start',
        'body': 'Today is full of potential. How will you make the most of it?'
      },
      {
        'title': '⚡ Morning Power-Up',
        'body': 'Charge into your day with enthusiasm and purpose!'
      },
      {
        'title': '📝 Day Designer',
        'body': 'Sketch out your ideal day. What does success look like today?'
      },
    ],
    NotificationType.EVENING_WIND_DOWN: [
      {
        'title': '🌙 Day\'s Wrap-up',
        'body': 'Reflect on your accomplishments and plan for tomorrow.'
      },
      {
        'title': '🌆 Evening Check-in',
        'body': 'How did your day go? Time to unwind and reflect.'
      },
      {
        'title': '✨ Nightly Reflection',
        'body': 'What are you grateful for today?'
      },
      {
        'title': '🛋️ Winding Down',
        'body': 'Time to shift gears and prepare for a restful evening.'
      },
      {
        'title': '📊 Day in Review',
        'body': 'What were your biggest wins today? Celebrate your progress!'
      },
      {
        'title': '🧘‍♀️ Evening Mindfulness',
        'body': 'Take a few deep breaths and let go of the day\'s stress.'
      },
      {
        'title': '🎨 Tomorrow\'s Canvas',
        'body': 'Visualize a successful day ahead as you wind down.'
      },
      {
        'title': '🙏 Gratitude Check',
        'body': 'Name three things that brought you joy or satisfaction today.'
      },
      {
        'title': '🔄 Evening Reset',
        'body':
            'Clear your mind and set positive intentions for the night ahead.'
      },
      {
        'title': '📚 Day\'s Lessons',
        'body': 'What did you learn today that you can apply tomorrow?'
      },
      {
        'title': '🍵 Calm Evening',
        'body': 'It\'s time to transition from work mode to relaxation mode.'
      },
      {
        'title': '🛀 Self-Care Reminder',
        'body': 'How can you nurture yourself this evening?'
      },
      {
        'title': '😊 Positive Reflection',
        'body': 'Recall a moment that made you smile today.'
      },
    ],
    NotificationType.FOCUS_REMINDER: [
      {
        'title': '🎯 Stay on Track',
        'body': 'Remember your morning goals. How are you progressing?'
      },
      {
        'title': '⏰ Midday Check-in',
        'body': 'Take a moment to refocus on your priorities.'
      },
      {
        'title': '🚀 Productivity Boost',
        'body': 'What\'s the most important task you can tackle right now?'
      },
      {
        'title': '🔍 Refocus Time',
        'body': 'Step back, breathe, and realign with your objectives.'
      },
      {
        'title': '🧠 Concentration Station',
        'body': 'Time to eliminate distractions and dive deep into your work.'
      },
      {
        'title': '🚦 Focus Checkpoint',
        'body': 'Are you where you want to be at this point in your day?'
      },
      {
        'title': '🧘 Mindful Moment',
        'body':
            'Pause and assess: Are your current actions aligned with your goals?'
      },
      {
        'title': '⚡ Productivity Pulse',
        'body': 'How\'s your energy? Take a quick break or push through?'
      },
      {
        'title': '📊 Task Prioritization',
        'body': 'Review your to-do list. What deserves your attention now?'
      },
      {
        'title': '🔬 Focus Finder',
        'body': 'Identify and eliminate any obstacles to your concentration.'
      },
      {
        'title': '📈 Progress Check',
        'body':
            'Reflect on your accomplishments so far and plan your next move.'
      },
      {
        'title': '🔄 Attention Reset',
        'body': 'Clear your mind and recommit to your most crucial tasks.'
      },
      {
        'title': '🏗️ Momentum Builder',
        'body': 'What small win can you achieve in the next 30 minutes?'
      },
    ],
    NotificationType.JOURNALING_CUE: [
      {
        'title': '📝 Time to Journal',
        'body': 'Capture your thoughts and feelings. What\'s on your mind?'
      },
      {
        'title': '🤔 Reflection Moment',
        'body': 'Take a few minutes to write about your day so far.'
      },
      {
        'title': '✍️ Write it Out',
        'body': 'Your journal is waiting. What story will you tell today?'
      },
      {
        'title': '🖋️ Pen to Paper',
        'body':
            'Express yourself freely. What insights are waiting to be discovered?'
      },
      {
        'title': '📔 Journal Check-In',
        'body':
            'How are you feeling right now? Let your journal be your confidant.'
      },
      {
        'title': '🧘‍♀️ Mindful Writing',
        'body': 'Take a deep breath and let your thoughts flow onto the page.'
      },
      {
        'title': '📸 Capture the Moment',
        'body':
            'What\'s the most significant thing that happened today? Write about it.'
      },
      {
        'title': '🔍 Self-Discovery Time',
        'body': 'What have you learned about yourself recently? Jot it down.'
      },
      {
        'title': '🙏 Gratitude Journaling',
        'body':
            'List three things you\'re grateful for and why they matter to you.'
      },
      {
        'title': '🔮 Future Self',
        'body':
            'Write a letter to your future self. What do you want to remember?'
      },
      {
        'title': '💡 Creative Writing Prompt',
        'body':
            'Describe your ideal day from start to finish. Let your imagination soar!'
      },
      {
        'title': '❤️ Emotional Check-In',
        'body': 'How\'s your heart today? Write about your emotional landscape.'
      },
      {
        'title': '🎯 Goal Reflection',
        'body': 'Review your recent goals. What progress have you made?'
      },
    ],
  };
}
