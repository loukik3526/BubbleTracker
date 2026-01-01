import 'package:flutter/material.dart';

class Habit {
  final String id;
  final String title;
  final String emoji;
  final Color color;
  bool isCompleted;
  final DateTime date;
  final double x;
  final double y;

  Habit({
    required this.id,
    required this.title,
    required this.emoji,
    required this.color,
    this.isCompleted = false,
    required this.date,
    required this.x,
    required this.y,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'emoji': emoji,
      'color': color.value,
      'isCompleted': isCompleted,
      'date': date.toIso8601String(),
      'x': x,
      'y': y,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      title: map['title'],
      emoji: map['emoji'],
      color: Color(map['color']),
      isCompleted: map['isCompleted'],
      date: DateTime.parse(map['date']),
      x: map['x'],
      y: map['y'],
    );
  }
}
