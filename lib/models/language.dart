class AppLanguage {
  const AppLanguage({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
    required this.ttsLocale,
  });

  final String code;
  final String name;
  final String nativeName;
  final String flag;
  final String ttsLocale;
}