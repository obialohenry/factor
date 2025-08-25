import 'package:intl/intl.dart';

class UtilFunctions {
  /// Formats a numeric string [amount] into a readable string with comma 
  /// seperators.
  /// - Returns `'0'` if [amount] is `'0'`.
  /// - If [amount] contains a decimal point (`.`):
  ///   - Formats the integer part with comma separators.
  ///   - Keeps the decimal part exactly as entered (preserves trailing or empty
  ///     decimals, e.g., `'123.'` or `'123.40'`).
  /// - If [amount] does not contain a decimal point, it is parsed as an int and
  ///   formatted without decimals.
  static String formatAmount(String amount) {
    if (amount == '0') return '0';
    if (amount.contains('.')) {
      final amountAsList = amount.split('.');
      if (amountAsList[1].isNotEmpty) {
        return '${NumberFormat('#,##0').format(int.parse(amountAsList[0]))}.$amountAsList[1]';
      } else {
        return '${NumberFormat('#,##0').format(int.parse(amountAsList[0]))}.';
      }
    } else {
      final amountAsInt = int.parse(amount);
      return NumberFormat('#,##0').format(amountAsInt);
    }
  }
}
