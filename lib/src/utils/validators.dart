/// A comprehensive set of regex-based validators for common inputs.
class Validators {
  Validators._();

  /// Validates an email address.
  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    final regex = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
    );
    return regex.hasMatch(email);
  }

  /// Validates a standard international phone number or generic length.
  /// Note: Phone formats vary widely, this uses a basic international format check.
  static bool isValidPhone(String phone) {
    if (phone.isEmpty) return false;
    // Allows optional +, followed by 7 to 15 digits.
    final regex = RegExp(r'^\+?[0-9]{7,15}$');
    return regex.hasMatch(phone.replaceAll(RegExp(r'[\s\-\(\)]'), ''));
  }

  /// Validates a URL structure.
  static bool isValidUrl(String url) {
    if (url.isEmpty) return false;
    final regex = RegExp(
      r'^(https?:\/\/)?' // protocol
      r'((([a-zA-Z\d]([a-zA-Z\d-]*[a-zA-Z\d])*)\.)+[a-zA-Z]{2,}|' // domain name
      r'((\d{1,3}\.){3}\d{1,3}))' // OR ip (v4) address
      r'(\:\d+)?(\/[-a-zA-Z\d%_.~+]*)*' // port and path
      r'(\?[;&a-zA-Z\d%_.~+=-]*)?' // query string
      r'(\#[-a-zA-Z\d_]*)?$', // fragment locator
    );
    return regex.hasMatch(url);
  }

  /// Validates an Indian PAN card number.
  /// Format: 5 letters, 4 digits, 1 letter.
  static bool isValidPAN(String pan) {
    if (pan.isEmpty) return false;
    final regex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    return regex.hasMatch(pan.toUpperCase());
  }

  /// Validates an Indian Aadhaar card number.
  /// Format: 12 digits, cannot start with 0 or 1.
  static bool isValidAadhaar(String aadhaar) {
    if (aadhaar.isEmpty) return false;
    final regex = RegExp(r'^[2-9]{1}[0-9]{3}\s?[0-9]{4}\s?[0-9]{4}$');
    return regex.hasMatch(aadhaar);
  }

  /// Evaluates password strength.
  /// Returns `true` if the password meets the minimum criteria:
  /// - At least [minLength] characters
  /// - Contains at least one uppercase letter (if [requireUppercase])
  /// - Contains at least one lowercase letter (if [requireLowercase])
  /// - Contains at least one number (if [requireNumber])
  /// - Contains at least one special character (if [requireSpecialChar])
  static bool isStrongPassword(
    String password, {
    int minLength = 8,
    bool requireUppercase = true,
    bool requireLowercase = true,
    bool requireNumber = true,
    bool requireSpecialChar = true,
  }) {
    if (password.length < minLength) return false;

    if (requireUppercase && !password.contains(RegExp(r'[A-Z]'))) return false;
    if (requireLowercase && !password.contains(RegExp(r'[a-z]'))) return false;
    if (requireNumber && !password.contains(RegExp(r'[0-9]'))) return false;
    if (requireSpecialChar &&
        !password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return false;
    }

    return true;
  }
}
