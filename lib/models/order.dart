import 'menu_item.dart';

class CartLine {
  final MenuItem item;
  int qty;
  final String? option;
  final String note;

  CartLine({
    required this.item,
    this.qty = 1,
    this.option,
    this.note = '',
  });

  String get key => '${item.id}|$option|$note';
  int get total => item.price * qty;
}

class Order {
  final String code;
  final String customerName;
  final String serviceType; // Makan di Tempat / Bawa Pulang
  final String? table;
  final String payment;
  final bool needCutlery;
  final List<CartLine> lines;
  final int subtotal;
  final int discount;
  final DateTime time;

  Order({
    required this.code,
    required this.customerName,
    required this.serviceType,
    required this.table,
    required this.payment,
    required this.needCutlery,
    required this.lines,
    required this.subtotal,
    required this.discount,
    required this.time,
  });

  int get total => subtotal - discount;
  int get estimatedMinutes {
    var m = 0;
    for (final l in lines) {
      if (l.item.prepMinutes > m) m = l.item.prepMinutes;
    }
    return m + lines.length;
  }
}
