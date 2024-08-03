import 'package:intl/intl.dart';

String formatCurrency(double value) {
  return NumberFormat('###,###,###.##').format(value); // Allow for more digits
}

String formatCurrencyCompact(double value) {
  return NumberFormat.compact()
      .format(value); // Compact formatting for thousands, millions, etc.
}
