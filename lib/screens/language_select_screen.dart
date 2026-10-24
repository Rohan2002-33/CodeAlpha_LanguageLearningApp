import 'package:flutter/material.dart';
import 'package:lingo_learn/core/app_theme.dart';
import 'package:lingo_learn/data/content_repository.dart';
import 'package:lingo_learn/providers/progress_provider.dart';
import 'package:provider/provider.dart';

class LanguageSelectScreen extends StatefulWidget {
  const LanguageSelectScreen({super.key, this.isOnboarding = true});

  final bool isOnboarding;

  @override
  State<LanguageSelectScreen> createState() => _LanguageSelectScreenState();
}

class _LanguageSelectScreenState extends State<LanguageSelectScreen> {
  String? _selected;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final code = context.read<ProgressProvider>().profile?.languageCode;
    if (code != null && code.isNotEmpty) _selected = code;
  }

  Future<void> _continue() async {
    final code = _selected;
    if (code == null) return;
    setState(() => _saving = true);
    await context.read<ProgressProvider>().selectLanguage(code);
    if (!mounted) return;
    setState(() => _saving = false);
    if (!widget.isOnboarding) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: widget.isOnboarding
          ? null
          : AppBar(title: const Text('Learning language')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.isOnboarding) const SizedBox(height: 24),
              Text(
                widget.isOnboarding
                    ? 'What do you want\nto learn?'
                    : 'Choose a language',
                style: textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'You can change this anytime in your profile.',
                style: textTheme.bodyMedium
                    ?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: ContentRepository.languages.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final language = ContentRepository.languages[index];
                    final selected = language.code == _selected;
                    return Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => setState(() => _selected = language.code),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: selected
                                  ? AppColors.primary
                                  : AppColors.border,
                              width: selected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(language.flag,
                                  style: const TextStyle(fontSize: 38)),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      language.name,
                                      style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      language.nativeName,
                                      style: textTheme.bodyMedium?.copyWith(
                                          color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                selected
                                    ? Icons.check_circle_rounded
                                    : Icons.circle_outlined,
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.border,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _selected == null || _saving ? null : _continue,
                child: _saving
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}