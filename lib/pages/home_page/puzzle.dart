import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';

class Puzzle extends ConsumerWidget {
  String id;
  String puzzleName;
  String puzzleCategory;
  DateTime deadline;
  DateTime startingTime;
  int taskNum;
  int gems;
  int completedTasks;
  VoidCallback onTap;
  String rewardImagePath;

  Puzzle({
    required this.id,
    required this.puzzleName,
    required this.puzzleCategory,
    required this.deadline,
    required this.startingTime,
    required this.taskNum,
    required this.gems,
    required this.completedTasks,
    required this.onTap,
    required this.rewardImagePath,
  });

  Puzzle copyWith({
    String? id,
    String? puzzleName,
    String? puzzleCategory,
    DateTime? deadline,
    DateTime? startingTime,
    int? taskNum,
    int? gems,
    int? completedTasks,
    VoidCallback? onTap,
    String? rewardImagePath,
  }) {
    return Puzzle(
      id: id ?? this.id,
      puzzleName: puzzleName ?? this.puzzleName,
      puzzleCategory: puzzleCategory ?? this.puzzleCategory,
      deadline: deadline ?? this.deadline,
      startingTime: startingTime ?? this.startingTime,
      taskNum: taskNum ?? this.taskNum,
      gems: gems ?? this.gems,
      completedTasks: completedTasks ?? this.completedTasks,
      onTap: onTap ?? this.onTap,
      rewardImagePath: rewardImagePath ?? this.rewardImagePath,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTime = DateTime.now();
    if (deadline.isBefore(currentTime) && taskNum != completedTasks) {
      gems = 0;
    }

    double imageSize = rewardImagePath == 'assets/rewards/default_reward.png' ? 100.0 : 80.0;

    ImageProvider imageProvider;
    if (kIsWeb) {
      if (rewardImagePath.startsWith('assets/')) {
        imageProvider = AssetImage(rewardImagePath);
      } else {
        imageProvider = NetworkImage(rewardImagePath);
      }
    } else {
      if (rewardImagePath.startsWith('assets/')) {
        imageProvider = AssetImage(rewardImagePath);
      } else {
        imageProvider = FileImage(File(rewardImagePath));
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(10),
        color: const Color.fromARGB(255, 30, 30, 30),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                      width: imageSize,
                      height: imageSize,
                    ),
                    Image.asset(
                      'assets/puzzles/$taskNum/$completedTasks.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      'assets/containers/default_frame.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    Image.asset(
                      'assets/gems/7_$gems.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name: $puzzleName",
                      style: const TextStyle(color: Colors.white),
                      softWrap: true,
                    ),
                    Text(
                      "Category: $puzzleCategory",
                      style: const TextStyle(color: Colors.white),
                      softWrap: true,
                    ),
                    Text(
                      "Deadline Date: ${DateFormat.yMd().format(deadline)}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      "Deadline Time: ${DateFormat('h:mm a').format(deadline)}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      "Number of Pieces: $taskNum",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}