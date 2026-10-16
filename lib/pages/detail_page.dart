import 'package:flutter/material.dart';
import '../models.dart';
import '../state.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _qty = 1;
  final _note = TextEditingController();

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context)!.settings.arguments as MenuItem;
    final state = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(item.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 180,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(item.emoji, style: const TextStyle(fontSize: 90)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(item.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              ),
              Chip(label: Text(item.category)),
            ],
          ),
          Text(rupiah(item.price),
              style: const TextStyle(fontSize: 20, color: Colors.deepOrange, fontWeight: FontWeight.bold)),
          const Divider(height: 32),
          Text(item.description),
          const SizedBox(height: 20),
          TextField(
            controller: _note,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Catatan (opsional)',
              hintText: 'Contoh: tidak pedas',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.outlined(
                icon: const Icon(Icons.remove),
                onPressed: _qty > 1 ? () => setState(() => _qty--) : null,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text('$_qty', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              IconButton.outlined(
                icon: const Icon(Icons.add),
                onPressed: () => setState(() => _qty++),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            icon: const Icon(Icons.add_shopping_cart),
            label: Text('Tambah • ${rupiah(item.price * _qty)}'),
            onPressed: () {
              state.add(item, _qty, _note.text.trim());
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
