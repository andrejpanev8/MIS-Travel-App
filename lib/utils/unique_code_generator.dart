import 'dart:math';

class UniqueCodeGenerator {
  static String generateUniqueCode() {
    final random = Random.secure();
    final code = List.generate(6, (_) {
      final asciiValue = random.nextInt(26) + (random.nextBool() ? 65 : 97);
      return String.fromCharCode(asciiValue);
    }).join();
    return code;
  }
}
