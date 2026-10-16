import 'package:flutter/material.dart';
import '../state.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  String _service = 'Makan di Tempat';
  String _payment = 'Tunai';
  bool _cutlery = true;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Data Pemesan')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'Nama pemesan',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
            ),
            const SizedBox(height: 20),
            const Text('Jenis layanan', style: TextStyle(fontWeight: FontWeight.bold)),
            RadioListTile<String>(
              title: const Text('Makan di Tempat'),
              value: 'Makan di Tempat',
              groupValue: _service,
              onChanged: (v) => setState(() => _service = v!),
            ),
            RadioListTile<String>(
              title: const Text('Bawa Pulang'),
              value: 'Bawa Pulang',
              groupValue: _service,
              onChanged: (v) => setState(() => _service = v!),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _payment,
              decoration: const InputDecoration(
                labelText: 'Metode pembayaran',
                prefixIcon: Icon(Icons.payments),
                border: OutlineInputBorder(),
              ),
              items: const ['Tunai', 'QRIS', 'Transfer']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _payment = v!),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Perlu sendok & garpu'),
              value: _cutlery,
              onChanged: (v) => setState(() => _cutlery = v),
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Total bayar'),
              trailing: Text(rupiah(state.total),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: () {
              if (!_formKey.currentState!.validate()) return;
              state.checkout(_name.text.trim(), _service, _payment, _cutlery);
              Navigator.pushNamedAndRemoveUntil(context, '/struk', (r) => r.settings.name == '/');
            },
            child: const Text('Pesan Sekarang'),
          ),
        ),
      ),
    );
  }
}
