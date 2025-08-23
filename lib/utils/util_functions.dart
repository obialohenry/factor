import 'package:intl/intl.dart';

class UtilFunctions {
    /// Formats a numeric amount into a string with comma separators 
   /// and two decimal places.
   static String formatAmount(double amount) {
        return NumberFormat('#,##0.00').format(amount);
      }
}