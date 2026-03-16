class MatrixTextHelper {
  MatrixTextHelper._();

  static const String matrixDomain = 'matrix.dropslab.com';
  static String normalizeUsername(String input) {
    var value = input.trim();

    value = value.replaceAll(' ', '');

    if (value.startsWith('@')) {
      value = value.substring(1);
    }

    final suffix = ':$matrixDomain';
    if (value.endsWith(suffix)) {
      value = value.substring(0, value.length - suffix.length);
    }

    final colonIndex = value.indexOf(':');
    if (colonIndex != -1) {
      value = value.substring(0, colonIndex);
    }

    return value.trim();
  }
  static String buildMatrixId(String usernameOrId) {
    final username = normalizeUsername(usernameOrId);
    return '@$username:$matrixDomain';
  }
  static bool isValidUsername(String? input) {
    if (input == null) return false;

    final username = normalizeUsername(input);
    if (username.isEmpty) return false;

    final regex = RegExp(r'^[a-z0-9._=\/-]+$', caseSensitive: false);
    return regex.hasMatch(username);
  }
  static bool isValidMatrixId(String? input) {
    if (input == null) return false;

    final fullId = buildMatrixId(input);
    final regex =
    RegExp(r'^@[a-z0-9._=\/-]+:matrix\.dropslab\.com$', caseSensitive: false);

    return regex.hasMatch(fullId);
  }

  static (String username, String password)? handleQR(String qr) {
    if (qr.startsWith("LOGIN:")) {
      final data = qr.replaceAll("LOGIN:", "");
      final parts = data.split(";");

      String username = parts[0].split(":")[1];
      String password = parts[1].split(":")[1];

     return (username, password);
    }
    return null;
  }
}