import 'item.dart';

class Nota {
  final String buyerName;
  final DateTime date;
  final List<Item> items;

  Nota({required this.buyerName, required this.date, required this.items});

  int get total => items.fold(0, (sum, i) => sum + i.subtotal);
  int get totalQty => items.fold(0, (sum, i) => sum + i.qty);
}
