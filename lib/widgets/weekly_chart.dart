import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lingo_learn/core/app_theme.dart';
import 'package:lingo_learn/core/constants.dart';
import 'package:lingo_learn/core/date_utils.dart';

class WeeklyChart extends StatelessWidget {
  const WeeklyChart({super.key, required this.data});

  /// Map of "yyyy-MM-dd" -> XP earned that day.
  final Map<String, int> data;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final days = List.generate(
      7,
      (i) => DateTime(now.year, now.month, now.day - (6 - i)),
    );
    final values = days.map((d) => data[dayKey(d)] ?? 0).toList();
    final maxValue = values.fold<int>(AppConstants.dailyGoalXp, max);
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 180,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < days.length; i++)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${values[i]}',
                    style: textTheme.labelSmall
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutCubic,
                    width: 22,
                    height: 6 + 110 * (values[i] / maxValue),
                    decoration: BoxDecoration(
                      color: i == days.length - 1
                          ? AppColors.primary
                          : AppColors.primary.withValues(alpha: 0.28),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat('E').format(days[i]),
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: i == days.length - 1
                          ? FontWeight.w700
                          : FontWeight.w400,
                      color: i == days.length - 1
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}