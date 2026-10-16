import 'dart:math';
import 'package:flutter/material.dart';
import 'models.dart';

String rupiah(int v) {
  final s = v.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return 'Rp $buf';
}

class AppState extends ChangeNotifier {
  final List<CartLine> lines = [];
  Order? lastOrder;

  int get totalQty => lines.fold(0, (a, l) => a + l.qty);
  int get total => lines.fold(0, (a, l) => a + l.total);

  void add(MenuItem item, int qty, String note) {
    final i = lines.indexWhere((l) => l.item.id == item.id && l.note == note);
    if (i >= 0) {
      lines[i].qty += qty;
    } else {
      lines.add(CartLine(item: item, qty: qty, note: note));
    }
    notifyListeners();
  }

  void increase(CartLine l) {
    l.qty++;
    notifyListeners();
  }

  void decrease(CartLine l) {
    if (l.qty > 1) {
      l.qty--;
    } else {
      lines.remove(l);
    }
    notifyListeners();
  }

  void remove(CartLine l) {
    lines.remove(l);
    notifyListeners();
  }

  Order checkout(String name, String serviceType, String payment, bool cutlery) {
    final order = Order(
      code: 'BS-${1000 + Random().nextInt(9000)}',
      name: name,
      serviceType: serviceType,
      payment: payment,
      needCutlery: cutlery,
      lines: List.of(lines),
      total: total,
      time: DateTime.now(),
    );
    lastOrder = order;
    lines.clear();
    notifyListeners();
    return order;
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
