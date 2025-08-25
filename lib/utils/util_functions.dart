import 'package:intl/intl.dart';

class UtilFunctions {
  /// Formats a numeric string [amount] into a human-readable string with comma 
  /// separators. 
  /// - Returns `'0'` if [amount] is `'0'`. 
  /// - If [amount] contains a decimal point (`.`), it is parsed as a double and 
  ///   formatted with up to two decimal places (without trailing zeros). 
  /// - If [amount] does not contain a decimal point, it is parsed as an int and 
  ///   formatted without decimals.
  static String formatAmount(String amount) {
    if (amount == '0') return '0';
    if (amount.contains('.')) {
      final amountAsDouble = double.parse(amount);
      return NumberFormat('#,##0.##').format(amountAsDouble);
    } else {
      final amountAsInt = int.parse(amount);
      return NumberFormat('#,##0').format(amountAsInt);
    }
  }
}
