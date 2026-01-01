import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../utils/audio_manager.dart';
import '../providers/habit_provider.dart';
import '../screens/success_screen.dart';
import 'add_habit_sheet.dart';

class HabitBubble extends StatefulWidget {
  final Habit habit;

  const HabitBubble({super.key, required this.habit});

  @override
  State<HabitBubble> createState() => _HabitBubbleState();
}

class _HabitBubbleState extends State<HabitBubble> {
  bool _isPopped = false;



  void _showMenu(BuildContext context) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox bubble = context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        bubble.localToGlobal(Offset.zero, ancestor: overlay),
        bubble.localToGlobal(bubble.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      color: const Color(0xFF1E1B4B).withOpacity(0.9), // Dark Blue/Violet
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.white.withOpacity(0.2)),
      ),
      items: [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: const [
              Icon(Icons.edit, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Text('Edit Details', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'reset',
          child: Row(
            children: const [
              Icon(Icons.refresh, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Text('Reset Streak', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: const [
              Icon(Icons.delete, color: Colors.redAccent, size: 20),
              SizedBox(width: 12),
              Text('Burst/Delete', style: TextStyle(color: Colors.redAccent)),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == 'edit') {
        _showEditSheet();
      } else if (value == 'reset') {
        if (widget.habit.isCompleted) {
           context.read<HabitProvider>().completeHabit(widget.habit.id);
        }
      } else if (value == 'delete') {
        _burstAndRemove();
      }
    });
  }

  void _showEditSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => AddHabitSheet(habit: widget.habit),
    );
  }

  bool _isDeleting = false;

  void _burstAndRemove() {
    setState(() {
      _isPopped = true;
      _isDeleting = true;
    });
    AudioManager.instance.playPop();
    // Wait for animation then delete
    Future.delayed(300.ms, () {
      if (mounted) {
        context.read<HabitProvider>().deleteHabit(widget.habit.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. The Glassmorphism Bubble
    Widget bubble = ClipRRect(
      borderRadius: BorderRadius.circular(100), // Circular shape
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 100, // Fixed size for now, or could be dynamic
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: widget.habit.color.withOpacity(0.5),
              width: 1.5,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.habit.color.withOpacity(0.1),
                Colors.white.withOpacity(0.05),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: widget.habit.color.withOpacity(0.2),
                blurRadius: 15,
                spreadRadius: -5,
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.habit.emoji,
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    widget.habit.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // 2. Floating Animation
    Widget floatingBubble = bubble
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .moveY(
          begin: -5,
          end: 5,
          curve: Curves.easeInOutSine,
          duration: 3.seconds,
        );

    // 3. Pop Animation & Interaction
    Widget interactiveBubble = GestureDetector(
      onTap: () async {
        if (_isPopped) return;
        
        // 1. Play the pop animation
        AudioManager.instance.playPop();
        setState(() {
          _isPopped = true;
        });

        // 2. Wait for animation to finish
        await Future.delayed(const Duration(milliseconds: 300));

        if (!mounted) return;

        // 3. Mark as complete
        final provider = Provider.of<HabitProvider>(context, listen: false);
        provider.completeHabit(widget.habit.id);

        // 4. FORCE CHECK: Did we just finish the last one?
        if (provider.areAllHabitsCompleted) {
          print('Victory! Navigating to Success Screen...');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => SuccessScreen(
                completedCount: provider.habits.length,
                streak: provider.currentStreak, // Using provider streak
                estimatedTime: '2h',
              ),
            ),
          );
        }
      },
      onLongPress: () {
        HapticFeedback.mediumImpact();
        _showMenu(context);
      },
      child: _isPopped
          ? floatingBubble
              .animate()
              .scale(
                end: const Offset(0, 0),
                duration: 300.ms,
                curve: Curves.easeInBack,
              )
          : floatingBubble,
    );

    return interactiveBubble;
  }
}
