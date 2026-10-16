class MenuItem {
  final String id;
  final String name;
  final String emoji;
  final String category; // Makanan / Minuman / Camilan
  final int price;
  final String description;

  const MenuItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.category,
    required this.price,
    required this.description,
  });
}

class CartLine {
  final MenuItem item;
  int qty;
  final String note;

  CartLine({required this.item, this.qty = 1, this.note = ''});

  int get total => item.price * qty;
}

class Order {
  final String code;
  final String name;
  final String serviceType;
  final String payment;
  final bool needCutlery;
  final List<CartLine> lines;
  final int total;
  final DateTime time;

  Order({
    required this.code,
    required this.name,
    required this.serviceType,
    required this.payment,
    required this.needCutlery,
    required this.lines,
    required this.total,
    required this.time,
  });
}
