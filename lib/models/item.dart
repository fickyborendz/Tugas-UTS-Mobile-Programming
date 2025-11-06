class Item {
  final String name;
  final int qty;
  final int price;

  Item({required this.name, required this.qty, required this.price});

  int get subtotal => qty * price;
}
