class NumberManipulation {
  static double? numberToDouble(dynamic number) {
    if (number is int) {
      return number.toDouble();
    } else if (number is double) {
      return number;
    } else if (number is String) {
      return double.tryParse(number);
    } else {
      return null;
    }
  }

  static int? numberToInt(dynamic number) {
    if (number is int) {
      return number;
    } else if (number is double) {
      return number.toInt();
    } else if (number is String) {
      return int.tryParse(number);
    } else {
      return null;
    }
  }
}
