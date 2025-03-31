import 'dart:math';

class CodeGenerator {
  static String generateUniqueCode() {
    final now = DateTime.now();
    final datePart =
        "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}";
    final unixTime = now.millisecondsSinceEpoch;

    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    final randomPart =
        List.generate(16, (index) => chars[random.nextInt(chars.length)])
            .join();

    return "$datePart-$unixTime-$randomPart";
  }
}
