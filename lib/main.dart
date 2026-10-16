import 'package:flutter/material.dart';
import 'pages/cart_page.dart';
import 'pages/detail_page.dart';
import 'pages/menu_page.dart';
import 'pages/order_page.dart';
import 'pages/receipt_page.dart';
import 'state.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppState _state = AppState();

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: _state,
      child: MaterialApp(
        title: 'Kantin Bu Sari',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.deepOrange,
            foregroundColor: Colors.white,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (_) => const MenuPage(),
          '/detail': (_) => const DetailPage(),
          '/keranjang': (_) => const CartPage(),
          '/pesan': (_) => const OrderPage(),
          '/struk': (_) => const ReceiptPage(),
        },
      ),
    );
  }
}
