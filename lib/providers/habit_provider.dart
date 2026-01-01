import 'dart:math';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/habit.dart';

class HabitProvider extends ChangeNotifier {
  final List<Habit> _habits = [
    Habit(
      id: const Uuid().v4(),
      title: 'Drink Water',
      emoji: '💧',
      color: const Color(0xFF64B5F6),
      date: DateTime.now(),
      x: Random().nextDouble() * 300 + 20,
      y: Random().nextDouble() * 500 + 50,
    ),
  ];

  DateTime _lastActiveDate = DateTime.now();
  int _streak = 12;
  bool _dailyGoalAchieved = false;
  bool _wasReset = false;

  HabitProvider() {
    checkDailyReset();
  }

  List<Habit> get habits => _habits;
  bool get wasReset => _wasReset;

  void consumeResetFlag() {
    _wasReset = false;
    // No notifyListeners needed here as it's just consuming a one-time event
  }

  void checkDailyReset() {
    final now = DateTime.now();
    // Check if it's a different day
    if (now.year != _lastActiveDate.year || 
        now.month != _lastActiveDate.month || 
        now.day != _lastActiveDate.day) {
      
      // If habits weren't completed yesterday, reset streak
      if (!areAllHabitsCompleted) {
        _streak = 0;
      }
      
      // Reset all habits for the new day
      resetDaily();
      
      // Update last active date and set reset flag
      _lastActiveDate = now;
      _wasReset = true;
      notifyListeners();
    }
  }

  bool get areAllHabitsCompleted {
    // If there are NO habits at all, it's not a 'success', it's just empty.
    if (_habits.isEmpty) return false;
    // Return TRUE only if every single habit in the list is marked as completed.
    return _habits.every((habit) => habit.isCompleted == true);
  }

  int get completedTodayCount => _habits.where((h) => h.isCompleted).length;

  int get currentStreak => _streak;

  void addHabit(String title, String emoji, Color color, double screenWidth, double screenHeight) {
    final random = Random();
    // Generate random position within safe bounds (padding of 50)
    final x = random.nextDouble() * (screenWidth - 100) + 50;
    final y = random.nextDouble() * (screenHeight - 200) + 100; // Avoid top/bottom UI

    _habits.add(
      Habit(
        id: const Uuid().v4(),
        title: title,
        emoji: emoji,
        color: color,
        date: DateTime.now(),
        x: x,
        y: y,
      ),
    );
    notifyListeners();
  }

  void clearAllData() {
    _habits.clear();
    _streak = 0;
    _dailyGoalAchieved = false;
    notifyListeners();
  }

  void updateHabit(String id, String title, String emoji, Color color) {
    final index = _habits.indexWhere((habit) => habit.id == id);
    if (index != -1) {
      _habits[index] = Habit(
        id: id,
        title: title,
        emoji: emoji,
        color: color,
        isCompleted: _habits[index].isCompleted,
        date: _habits[index].date,
        x: _habits[index].x, // Preserve position
        y: _habits[index].y,
      );
      notifyListeners();
    }
  }

  void deleteHabit(String id) {
    _habits.removeWhere((habit) => habit.id == id);
    notifyListeners();
  }

  void completeHabit(String id) {
    final index = _habits.indexWhere((h) => h.id == id);
    if (index != -1) {
      _habits[index].isCompleted = true;
      notifyListeners(); // This must happen to trigger the UI update!
      // DEBUG PRINT: Check logs to see if this runs
      print('Habit $id completed. All done? $areAllHabitsCompleted');
    }
  }

  void resetDaily() {
    for (var habit in _habits) {
      habit.isCompleted = false;
    }
    _dailyGoalAchieved = false;
    notifyListeners();
  }
}
