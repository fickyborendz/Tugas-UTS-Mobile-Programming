class Item {
  final String name;
  final int qty;
  final int price;

  Item({
    required this.name,
    required this.qty,
    required this.price,
  });

  int get subtotal => qty * price;

  // 🔹 Konversi ke Map (berguna kalau nanti mau disimpan ke SharedPreferences)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'qty': qty,
      'price': price,
    };
  }

  // 🔹 Konversi dari Map ke Object Item
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      name: map['name'],
      qty: map['qty'],
      price: map['price'],
    );
  }
}
