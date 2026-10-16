import 'package:flutter/material.dart';

import '../models/menu_item.dart';
import '../state/app_state.dart';
import '../utils/format.dart';
import '../widgets/common.dart';

class MenuDetailPage extends StatefulWidget {
  const MenuDetailPage({super.key});

  @override
  State<MenuDetailPage> createState() => _MenuDetailPageState();
}

class _MenuDetailPageState extends State<MenuDetailPage> {
  int _qty = 1;
  double _spicy = 1; // 0..3
  String _temp = 'Dingin';
  bool _extra = false;
  final TextEditingController _note = TextEditingController();

  static const _spicyLabels = ['Tidak Pedas', 'Sedang', 'Pedas', 'Extra Pedas'];
  static const _extraPrice = 3000;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  String? _optionLabel(MenuItem item) {
    if (item.isDrink) return 'Suhu: $_temp';
    if (item.isFood) return 'Level: ${_spicyLabels[_spicy.round()]}';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context)!.settings.arguments as MenuItem;
    final app = AppScope.of(context);
    final cs = Theme.of(context).colorScheme;
    final unit = item.price + (_extra ? _extraPrice : 0);

    return Scaffold(
      bottomNavigationBar: _buildBottomBar(context, item, unit),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 240,
            backgroundColor: item.color,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                onPressed: () => app.toggleFavorite(item.id),
                icon: Icon(
                  app.isFavorite(item.id)
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pushNamed(context, '/keranjang'),
                icon: Badge(
                  isLabelVisible: app.totalQty > 0,
                  label: Text('${app.totalQty}'),
                  child: const Icon(Icons.shopping_basket_rounded),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(item.name,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [item.color, item.color.withValues(alpha: 0.6)],
                  ),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 30, bottom: 30),
                child: Hero(
                  tag: 'thumb-${item.id}',
                  child: Material(
                    color: Colors.transparent,
                    child: Text(item.emoji, style: const TextStyle(fontSize: 110)),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  children: [
                    Expanded(
                      child: Text(rupiah(item.price),
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: cs.primary)),
                    ),
                    if (item.bestSeller)
                      const Chip(
                        avatar: Icon(Icons.local_fire_department_rounded,
                            color: Colors.redAccent, size: 18),
                        label: Text('Terlaris'),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    RatingChip(rating: item.rating, reviews: item.reviews),
                    Chip(
                      visualDensity: VisualDensity.compact,
                      avatar: Icon(item.category.icon, size: 16),
                      label: Text(item.category.label),
                    ),
                    Chip(
                      visualDensity: VisualDensity.compact,
                      avatar: const Icon(Icons.timer_outlined, size: 16),
                      label: Text('±${item.prepMinutes} menit'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(item.description,
                    style: const TextStyle(fontSize: 14.5, height: 1.5)),
                const SizedBox(height: 14),
                Card(
                  child: ExpansionTile(
                    shape: const Border(),
                    collapsedShape: const Border(),
                    leading: const Icon(Icons.eco_rounded),
                    title: const Text('Bahan Utama',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          for (final b in item.ingredients)
                            Chip(label: Text(b), visualDensity: VisualDensity.compact),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionTitle('Atur Pesanan'),
                        if (item.isFood) ...[
                          Row(
                            children: [
                              const Icon(Icons.whatshot_rounded, color: Colors.redAccent),
                              const SizedBox(width: 8),
                              Text('Level pedas: ${_spicyLabels[_spicy.round()]}',
                                  style: const TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                          Slider(
                            value: _spicy,
                            min: 0,
                            max: 3,
                            divisions: 3,
                            label: _spicyLabels[_spicy.round()],
                            onChanged: (v) => setState(() => _spicy = v),
                          ),
                        ],
                        if (item.isDrink) ...[
                          const Text('Suhu minuman',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          SegmentedButton<String>(
                            segments: const [
                              ButtonSegment(
                                  value: 'Dingin',
                                  icon: Icon(Icons.ac_unit_rounded),
                                  label: Text('Dingin')),
                              ButtonSegment(
                                  value: 'Hangat',
                                  icon: Icon(Icons.local_fire_department_rounded),
                                  label: Text('Hangat')),
                            ],
                            selected: {_temp},
                            onSelectionChanged: (s) => setState(() => _temp = s.first),
                          ),
                        ],
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(item.isDrink
                              ? 'Tambah topping boba / jelly'
                              : 'Tambah porsi ekstra'),
                          subtitle: Text('+ ${rupiah(_extraPrice)} per porsi'),
                          value: _extra,
                          onChanged: (v) => setState(() => _extra = v),
                        ),
                        const SizedBox(height: 4),
                        TextField(
                          controller: _note,
                          maxLines: 2,
                          maxLength: 80,
                          decoration: const InputDecoration(
                            labelText: 'Catatan untuk Bu Sari (opsional)',
                            hintText: 'Contoh: tanpa bawang goreng',
                            prefixIcon: Icon(Icons.edit_note_rounded),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 90),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, MenuItem item, int unit) {
    final app = AppScope.of(context);
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, -4)),
          ],
        ),
        child: Row(
          children: [
            QtyStepper(
              value: _qty,
              onMinus: () => setState(() {
                if (_qty > 1) _qty--;
              }),
              onPlus: () => setState(() {
                if (_qty < 20) _qty++;
              }),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                onPressed: () {
                  var option = _optionLabel(item);
                  if (_extra) option = '${option ?? 'Opsi'} + Ekstra';
                  // harga ekstra dimasukkan lewat item turunan agar total benar
                  final priced = _extra
                      ? MenuItem(
                          id: '${item.id}x',
                          name: item.name,
                          emoji: item.emoji,
                          category: item.category,
                          price: unit,
                          description: item.description,
                          rating: item.rating,
                          reviews: item.reviews,
                          prepMinutes: item.prepMinutes,
                          ingredients: item.ingredients,
                          color: item.color,
                          bestSeller: item.bestSeller,
                        )
                      : item;
                  app.add(priced, qty: _qty, option: option, note: _note.text.trim());
                  final nav = Navigator.of(context);
                  showSnack(context, '$_qty× ${item.name} masuk keranjang',
                      action: SnackBarAction(
                        label: 'LIHAT',
                        textColor: Colors.white,
                        onPressed: () => nav.pushNamed('/keranjang'),
                      ));
                  nav.pop();
                },
                icon: const Icon(Icons.add_shopping_cart_rounded),
                label: Text('Tambah • ${rupiah(unit * _qty)}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
