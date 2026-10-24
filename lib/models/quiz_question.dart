class QuizQuestion {
  const QuizQuestion({
    required this.instruction,
    required this.prompt,
    required this.options,
    required this.correctIndex,
    this.speakText,
  });

  final String instruction;
  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String? speakText;
}