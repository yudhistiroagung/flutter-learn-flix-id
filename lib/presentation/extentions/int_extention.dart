import 'package:intl/intl.dart';

extension IntExtention on int {
  String toIDRCurrency() =>
      NumberFormat.currency(locale: 'id_ID', symbol: 'IDR', decimalDigits: 0)
          .format(this);
}
