import 'package:flutter/material.dart';
import '../state.dart';

class ReceiptPage extends StatelessWidget {
  const ReceiptPage({super.key});

  @override
  Widget build(BuildContext context) {
    final order = AppScope.of(context).lastOrder;

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Struk')),
        body: const Center(child: Text('Belum ada pesanan')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Struk Pesanan'), automaticallyImplyLeading: false),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Icon(Icons.check_circle, size: 72, color: Colors.green),
          const SizedBox(height: 8),
          const Text('Pesanan Berhasil!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(order.code, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Chip(label: Text(order.serviceType)),
                    ],
                  ),
                  Text('Atas nama ${order.name}'),
                  Text('Pembayaran: ${order.payment}'),
                  Text(order.needCutlery ? 'Dengan sendok & garpu' : 'Tanpa sendok & garpu'),
                  const Divider(height: 24),
                  ...order.lines.map((l) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Expanded(child: Text('${l.qty}x ${l.item.name}')),
                            Text(rupiah(l.total)),
                          ],
                        ),
                      )),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(rupiah(order.total),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
            child: const Text('Kembali ke Menu'),
          ),
        ),
      ),
    );
  }
}
