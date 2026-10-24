class Validators {
  Validators._();

  static String? name(String? value) {
    if (value == null || value.trim().length < 2) return 'Enter your name';
    return null;
  }

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    final valid = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text);
    return valid ? null : 'Enter a valid email address';
  }

  static String? password(String? value) {
    if (value == null || value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}