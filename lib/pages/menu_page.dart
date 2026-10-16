import 'package:flutter/material.dart';
import '../data.dart';
import '../models.dart';
import '../state.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String _category = 'Semua';
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final items = kMenu.where((m) {
      final okCat = _category == 'Semua' || m.category == _category;
      final okQuery = m.name.toLowerCase().contains(_query.toLowerCase());
      return okCat && okQuery;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kantin Bu Sari'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Badge(
                isLabelVisible: state.totalQty > 0,
                label: Text('${state.totalQty}'),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              onPressed: () => Navigator.pushNamed(context, '/keranjang'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Cari menu...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: kCategories
                  .map((c) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(c),
                          selected: _category == c,
                          onSelected: (_) => setState(() => _category = c),
                        ),
                      ))
                  .toList(),
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text('Menu tidak ditemukan'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    itemBuilder: (context, i) => _MenuCard(item: items[i]),
                  ),
          ),
        ],
      ),
      floatingActionButton: state.totalQty == 0
          ? null
          : FloatingActionButton.extended(
              onPressed: () => Navigator.pushNamed(context, '/keranjang'),
              icon: const Icon(Icons.shopping_bag),
              label: Text('Keranjang • ${rupiah(state.total)}'),
            ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final MenuItem item;
  const _MenuCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.orange.shade100,
          child: Text(item.emoji, style: const TextStyle(fontSize: 28)),
        ),
        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${item.category} • ${rupiah(item.price)}'),
        trailing: IconButton.filled(
          icon: const Icon(Icons.add),
          onPressed: () {
            state.add(item, 1, '');
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text('${item.name} ditambahkan')));
          },
        ),
        onTap: () => Navigator.pushNamed(context, '/detail', arguments: item),
      ),
    );
  }
}
