import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/habit_provider.dart';
import '../models/habit.dart';

class AddHabitSheet extends StatefulWidget {
  final Habit? habit;

  const AddHabitSheet({super.key, this.habit});

  @override
  State<AddHabitSheet> createState() => _AddHabitSheetState();
}

class _AddHabitSheetState extends State<AddHabitSheet> {
  late TextEditingController _controller;
  late String _selectedEmoji;
  late Color _selectedColor;

  final List<String> _emojis = ['🧘', '💧', '📖', '🏃', '💤', '💻', '🎨', '🎵'];
  final List<Color> _colors = [
    Colors.blueAccent,
    Colors.purpleAccent,
    Colors.pinkAccent,
    Colors.greenAccent,
    Colors.orangeAccent,
  ];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.habit?.title ?? '');
    _selectedEmoji = widget.habit?.emoji ?? '🧘';
    _selectedColor = widget.habit?.color ?? Colors.blueAccent;
  }

  void _saveHabit() {
    final title = _controller.text.trim();
    if (title.isNotEmpty) {
      if (widget.habit != null) {
        context.read<HabitProvider>().updateHabit(
              widget.habit!.id,
              title,
              _selectedEmoji,
              _selectedColor,
            );
      } else {
        final size = MediaQuery.of(context).size;
        context.read<HabitProvider>().addHabit(
              title,
              _selectedEmoji,
              _selectedColor,
              size.width,
              size.height,
            );
      }
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Handling keyboard overlap
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      color: Colors.transparent, // Sheet itself is transparent
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(
            left: 24, 
            right: 24, 
            bottom: bottomPadding > 0 ? bottomPadding : 0
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.habit != null ? "Edit Habit" : "Create New Habit",
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    
                    // Name Input
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Habit Name",
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        autofocus: true,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Icon Selector
                    SizedBox(
                      height: 60,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _emojis.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final emoji = _emojis[index];
                          final isSelected = _selectedEmoji == emoji;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedEmoji = emoji),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected 
                                    ? Colors.white.withOpacity(0.2) 
                                    : Colors.transparent,
                                border: isSelected 
                                    ? Border.all(color: Colors.white, width: 2) 
                                    : null,
                              ),
                              child: Text(
                                emoji,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white.withOpacity(isSelected ? 1.0 : 0.5),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Color Selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: _colors.map((color) {
                        final isSelected = _selectedColor == color;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedColor = color),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color,
                              border: isSelected 
                                  ? Border.all(color: Colors.white, width: 3) 
                                  : null,
                              boxShadow: isSelected 
                                  ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 8)] 
                                  : null,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),

                    // Action Button
                    GestureDetector(
                      onTap: _saveHabit,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: Text(
                              widget.habit != null ? "Update Bubble" : "Inflate Bubble",
                              style: const TextStyle(
                                fontSize: 16, 
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
