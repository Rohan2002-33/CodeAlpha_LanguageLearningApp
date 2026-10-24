import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lingo_learn/core/app_theme.dart';
import 'package:lingo_learn/core/constants.dart';
import 'package:lingo_learn/data/content_repository.dart';
import 'package:lingo_learn/models/language.dart';
import 'package:lingo_learn/models/lesson.dart';
import 'package:lingo_learn/providers/progress_provider.dart';
import 'package:lingo_learn/services/tts_service.dart';
import 'package:provider/provider.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key, required this.lesson});

  final Lesson lesson;

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  int _index = 0;
  bool _showBack = false;

  late final AppLanguage _language =
      ContentRepository.languageByCode(widget.lesson.languageCode);

  StudyItem get _item => widget.lesson.items[_index];
  bool get _isLast => _index == widget.lesson.items.length - 1;

  void _flip() => setState(() => _showBack = !_showBack);

  void _previous() {
    if (_index == 0) return;
    setState(() {
      _index--;
      _showBack = false;
    });
  }

  void _next() {
    if (_isLast) {
      _finish();
      return;
    }
    setState(() {
      _index++;
      _showBack = false;
    });
  }

  void _finish() {
    context.read<ProgressProvider>().recordSession(
          xp: AppConstants.xpPerFlashcardSession,
          lessonTitle: widget.lesson.title,
        );
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Great job! +${AppConstants.xpPerFlashcardSession} XP earned'),
      ),
    );
  }

  void _speak(String text) {
    context.read<TtsService>().speak(text, _language.ttsLocale);
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.lesson.items.length;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(widget.lesson.title)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Card ${_index + 1} of $total',
                    style: textTheme.bodySmall
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: (_index + 1) / total,
                        minHeight: 8,
                        backgroundColor: AppColors.border,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GestureDetector(
                  onTap: _flip,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: _showBack ? 1 : 0),
                    duration: const Duration(milliseconds: 420),
                    curve: Curves.easeInOut,
                    builder: (context, value, _) {
                      final isBack = value >= 0.5;
                      return Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(value * pi),
                        child: isBack
                            ? Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()..rotateY(pi),
                                child: _back(textTheme),
                              )
                            : _front(textTheme),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _flip,
                child: Text(_showBack ? 'Hide Answer' : 'Show Answer'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _index == 0 ? null : _previous,
                      child: const Text('Previous'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _next,
                      child: Text(_isLast ? 'Finish' : 'Next'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _front(TextTheme textTheme) {
    return _CardFace(
      color: Colors.white,
      borderColor: AppColors.border,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.lesson.category.label.toUpperCase(),
            style: textTheme.labelSmall?.copyWith(
              letterSpacing: 1.4,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 28),
          Text(
            _item.term,
            textAlign: TextAlign.center,
            style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Text(
            _item.pronunciation,
            style: textTheme.bodyLarge?.copyWith(
              fontStyle: FontStyle.italic,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          IconButton.filledTonal(
            iconSize: 28,
            onPressed: () => _speak(_item.term),
            icon: const Icon(Icons.volume_up_rounded),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.touch_app_rounded,
                  size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                'Tap card to flip',
                style: textTheme.bodySmall
                    ?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _back(TextTheme textTheme) {
    return _CardFace(
      gradient: AppColors.brandGradient,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _item.translation,
                textAlign: TextAlign.center,
                style: textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _item.pronunciation,
                  style: textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(height: 24),
              Divider(color: Colors.white.withValues(alpha: 0.3)),
              const SizedBox(height: 16),
              Text(
                _item.example,
                textAlign: TextAlign.center,
                style: textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _item.exampleTranslation,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(height: 16),
              IconButton(
                onPressed: () => _speak(_item.example),
                icon: const Icon(Icons.volume_up_rounded, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardFace extends StatelessWidget {
  const _CardFace({
    required this.child,
    this.color,
    this.gradient,
    this.borderColor,
  });

  final Widget child;
  final Color? color;
  final Gradient? gradient;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color,
        gradient: gradient,
        borderRadius: BorderRadius.circular(28),
        border: borderColor == null ? null : Border.all(color: borderColor!),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.10),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}