import 'package:flutter/material.dart';
import 'package:lingo_learn/core/app_theme.dart';
import 'package:lingo_learn/core/constants.dart';
import 'package:lingo_learn/data/content_repository.dart';
import 'package:lingo_learn/models/language.dart';
import 'package:lingo_learn/models/lesson.dart';
import 'package:lingo_learn/models/quiz_question.dart';
import 'package:lingo_learn/providers/progress_provider.dart';
import 'package:lingo_learn/screens/quiz_result_screen.dart';
import 'package:lingo_learn/services/quiz_generator.dart';
import 'package:lingo_learn/services/tts_service.dart';
import 'package:provider/provider.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, required this.lesson});

  final Lesson lesson;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final List<QuizQuestion> _questions;
  late final AppLanguage _language;
  int _index = 0;
  int _score = 0;
  int? _selected;

  @override
  void initState() {
    super.initState();
    _language = ContentRepository.languageByCode(widget.lesson.languageCode);
    _questions = QuizGenerator.generate(
      widget.lesson,
      ContentRepository.allItems(widget.lesson.languageCode),
    );
  }

  QuizQuestion get _question => _questions[_index];
  bool get _answered => _selected != null;
  bool get _isLast => _index == _questions.length - 1;

  void _select(int option) {
    if (_answered) return;
    setState(() {
      _selected = option;
      if (option == _question.correctIndex) _score++;
    });
  }

  void _next() {
    if (!_isLast) {
      setState(() {
        _index++;
        _selected = null;
      });
      return;
    }
    _finish();
  }

  void _finish() {
    final total = _questions.length;
    final passed = _score / total >= AppConstants.passRatio;
    context.read<ProgressProvider>().recordSession(
          xp: _score * AppConstants.xpPerCorrectAnswer,
          lessonId: widget.lesson.id,
          lessonTitle: widget.lesson.title,
          score: _score,
          total: total,
          completed: passed,
        );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => QuizResultScreen(
          lesson: widget.lesson,
          score: _score,
          total: total,
        ),
      ),
    );
  }

  Future<void> _confirmExit() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Quit quiz?'),
        content: const Text('Your progress in this quiz will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep going'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Quit'),
          ),
        ],
      ),
    );
    if (leave == true && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final question = _question;

    return PopScope(
      canPop: _index == 0 && !_answered,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmExit();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Quiz · ${widget.lesson.title}'),
          titleTextStyle: Theme.of(context)
              .appBarTheme
              .titleTextStyle
              ?.copyWith(fontSize: 17),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      '${_index + 1}/${_questions.length}',
                      style: textTheme.bodySmall
                          ?.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: (_index + (_answered ? 1 : 0)) /
                              _questions.length,
                          minHeight: 8,
                          backgroundColor: AppColors.border,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Text(
                                    question.instruction,
                                    style: textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  Text(
                                    question.prompt,
                                    textAlign: TextAlign.center,
                                    style: textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  if (question.speakText != null) ...[
                                    const SizedBox(height: 12),
                                    IconButton.filledTonal(
                                      onPressed: () => context
                                          .read<TtsService>()
                                          .speak(question.speakText!,
                                              _language.ttsLocale),
                                      icon: const Icon(Icons.volume_up_rounded),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        for (var i = 0; i < question.options.length; i++)
                          _option(i, question),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _answered ? _next : null,
                  child: Text(_isLast ? 'See results' : 'Continue'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _option(int i, QuizQuestion question) {
    final isCorrect = i == question.correctIndex;
    final isSelected = i == _selected;

    var border = AppColors.border;
    var background = Colors.white;
    IconData? icon;
    Color? iconColor;

    if (_answered) {
      if (isCorrect) {
        border = AppColors.success;
        background = AppColors.success.withValues(alpha: 0.08);
        icon = Icons.check_circle_rounded;
        iconColor = AppColors.success;
      } else if (isSelected) {
        border = AppColors.error;
        background = AppColors.error.withValues(alpha: 0.08);
        icon = Icons.cancel_rounded;
        iconColor = AppColors.error;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _select(i),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: border, width: 1.5),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    question.options[i],
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                if (icon != null) Icon(icon, color: iconColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}