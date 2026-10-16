import 'dart:math';
import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../models/order.dart';

class AppState extends ChangeNotifier {
  final List<CartLine> _lines = [];
  final Set<String> _favorites = {};
  String? _voucher;
  Order? lastOrder;

  List<CartLine> get lines => List.unmodifiable(_lines);
  bool get isEmpty => _lines.isEmpty;
  String? get voucher => _voucher;

  int get totalQty => _lines.fold(0, (a, l) => a + l.qty);
  int get subtotal => _lines.fold(0, (a, l) => a + l.total);

  int get discount {
    switch (_voucher) {
      case 'SARI10':
        return (subtotal * 0.10).round();
      case 'HEMAT5K':
        return subtotal >= 20000 ? 5000 : 0;
      default:
        return 0;
    }
  }

  int get total => subtotal - discount;

  bool isFavorite(String id) => _favorites.contains(id);
  int get favoriteCount => _favorites.length;

  void toggleFavorite(String id) {
    if (!_favorites.remove(id)) _favorites.add(id);
    notifyListeners();
  }

  int qtyOf(String itemId) =>
      _lines.where((l) => l.item.id == itemId).fold(0, (a, l) => a + l.qty);

  void add(MenuItem item, {int qty = 1, String? option, String note = ''}) {
    final probe = CartLine(item: item, option: option, note: note);
    final idx = _lines.indexWhere((l) => l.key == probe.key);
    if (idx >= 0) {
      _lines[idx].qty += qty;
    } else {
      probe.qty = qty;
      _lines.add(probe);
    }
    notifyListeners();
  }

  void increase(CartLine line) {
    line.qty++;
    notifyListeners();
  }

  void decrease(CartLine line) {
    if (line.qty > 1) {
      line.qty--;
    } else {
      _lines.remove(line);
    }
    notifyListeners();
  }

  int remove(CartLine line) {
    final i = _lines.indexOf(line);
    _lines.remove(line);
    notifyListeners();
    return i;
  }

  void restore(CartLine line, int index) {
    _lines.insert(min(index, _lines.length), line);
    notifyListeners();
  }

  void clear() {
    _lines.clear();
    _voucher = null;
    notifyListeners();
  }

  /// Mengembalikan pesan error, atau null jika voucher berhasil dipakai.
  String? applyVoucher(String raw) {
    final code = raw.trim().toUpperCase();
    if (code.isEmpty) return 'Masukkan kode voucher terlebih dahulu';
    if (code == 'SARI10') {
      _voucher = code;
      notifyListeners();
      return null;
    }
    if (code == 'HEMAT5K') {
      if (subtotal < 20000) return 'HEMAT5K berlaku untuk minimal belanja Rp 20.000';
      _voucher = code;
      notifyListeners();
      return null;
    }
    return 'Kode voucher tidak valid';
  }

  void removeVoucher() {
    _voucher = null;
    notifyListeners();
  }

  Order checkout({
    required String name,
    required String serviceType,
    required String? table,
    required String payment,
    required bool needCutlery,
  }) {
    final order = Order(
      code: 'BS-${1000 + Random().nextInt(9000)}',
      customerName: name,
      serviceType: serviceType,
      table: table,
      payment: payment,
      needCutlery: needCutlery,
      lines: List.of(_lines),
      subtotal: subtotal,
      discount: discount,
      time: DateTime.now(),
    );
    lastOrder = order;
    _lines.clear();
    _voucher = null;
    notifyListeners();
    return order;
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
      : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope tidak ditemukan di widget tree');
    return scope!.notifier!;
  }
}
