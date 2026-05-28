class Validators {
  Validators._();

  static bool isEmail(String value) {
    final emailRegex = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+");
    return emailRegex.hasMatch(value);
  }

  static bool isPasswordValid(String value) {
    return value.length >= 8;
  }

  static bool isNotEmpty(String value) {
    return value.trim().isNotEmpty;
  }
}
