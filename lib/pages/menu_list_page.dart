import 'package:flutter/material.dart';

import '../data/menu_data.dart';
import '../models/menu_item.dart';
import '../state/app_state.dart';
import '../utils/format.dart';
import '../widgets/common.dart';

class MenuListPage extends StatefulWidget {
  const MenuListPage({super.key});

  @override
  State<MenuListPage> createState() => _MenuListPageState();
}

class _MenuListPageState extends State<MenuListPage> {
  final TextEditingController _search = TextEditingController();
  MenuCategory? _category; // null = semua
  bool _onlyFavorite = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<MenuItem> _filtered(AppState app) {
    final q = _search.text.trim().toLowerCase();
    return kMenuItems.where((m) {
      if (_category != null && m.category != _category) return false;
      if (_onlyFavorite && !app.isFavorite(m.id)) return false;
      if (q.isNotEmpty &&
          !m.name.toLowerCase().contains(q) &&
          !m.description.toLowerCase().contains(q)) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final items = _filtered(app);

    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        title: const Text('Kantin Bu Sari',
            style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              tooltip: 'Keranjang',
              onPressed: () => Navigator.pushNamed(context, '/keranjang'),
              icon: Badge(
                isLabelVisible: app.totalQty > 0,
                label: Text('${app.totalQty}'),
                child: const Icon(Icons.shopping_basket_rounded),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: app.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () => Navigator.pushNamed(context, '/keranjang'),
              icon: const Icon(Icons.shopping_cart_checkout_rounded),
              label: Text('${app.totalQty} item • ${rupiah(app.subtotal)}'),
            ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(context)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TextField(
                controller: _search,
                onChanged: (_) => setState(() {}),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Cari menu favoritmu…',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _search.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => setState(_search.clear),
                        ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: _buildFilters(app)),
          if (items.isEmpty)
            SliverFillRemaining(hasScrollBody: false, child: _buildEmpty())
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
              sliver: SliverList.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) => _MenuCard(item: items[i]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Halo, Sahabat Kantin! 👋',
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 6),
                const Text('Mau makan\napa hari ini?',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        height: 1.15,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.local_offer_rounded, color: Colors.white, size: 16),
                      SizedBox(width: 6),
                      Text('Pakai kode SARI10 • diskon 10%',
                          style: TextStyle(color: Colors.white, fontSize: 12.5)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Text('👩‍🍳', style: TextStyle(fontSize: 70)),
        ],
      ),
    );
  }

  Widget _buildFilters(AppState app) {
    return SizedBox(
      height: 58,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        children: [
          ChoiceChip(
            label: const Text('Semua'),
            selected: _category == null,
            onSelected: (_) => setState(() => _category = null),
          ),
          for (final c in MenuCategory.values) ...[
            const SizedBox(width: 8),
            ChoiceChip(
              avatar: Icon(c.icon, size: 18),
              label: Text(c.label),
              selected: _category == c,
              onSelected: (_) => setState(() => _category = c),
            ),
          ],
          const SizedBox(width: 8),
          FilterChip(
            avatar: Icon(
              _onlyFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              size: 18,
              color: Colors.redAccent,
            ),
            label: Text('Favorit (${app.favoriteCount})'),
            selected: _onlyFavorite,
            onSelected: (v) => setState(() => _onlyFavorite = v),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔍', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 12),
          const Text('Menu tidak ditemukan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text('Coba kata kunci atau kategori lain.',
              style: TextStyle(color: Theme.of(context).hintColor)),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => setState(() {
              _search.clear();
              _category = null;
              _onlyFavorite = false;
            }),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Reset filter'),
          ),
        ],
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [

DrawerHeader(
  decoration: BoxDecoration(color: cs.primary),
  child: const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.end,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('🍲', style: TextStyle(fontSize: 32)),
      SizedBox(height: 4),
      Text(
        'Kantin Bu Sari',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      SizedBox(height: 2),
      Text(
        'Masakan rumahan, harga mahasiswa',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 12,
        ),
      ),
    ],
  ),
),
          const ListTile(
            leading: Icon(Icons.access_time_filled_rounded),
            title: Text('Jam Operasional'),
            subtitle: Text('Senin – Sabtu, 07.00 – 16.00'),
          ),
          const ListTile(
            leading: Icon(Icons.place_rounded),
            title: Text('Lokasi'),
            subtitle: Text('Kantin lantai 1, Gedung Utama Kampus'),
          ),
          const ListTile(
            leading: Icon(Icons.local_offer_rounded),
            title: Text('Voucher Aktif'),
            subtitle: Text('SARI10 (10%) • HEMAT5K (min. Rp 20.000)'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.receipt_long_rounded),
            title: const Text('Struk Terakhir'),
            onTap: () {
              Navigator.pop(context);
              if (AppScope.of(context).lastOrder == null) {
                showSnack(context, 'Belum ada pesanan sebelumnya',
                    icon: Icons.info_rounded);
              } else {
                Navigator.pushNamed(context, '/struk');
              }
            },
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final MenuItem item;
  const _MenuCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final cs = Theme.of(context).colorScheme;
    final inCart = app.qtyOf(item.id);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/detail', arguments: item),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Stack(
                children: [
                  MenuThumb(item: item),
                  if (item.bestSeller)
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(18),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: const Text('Terlaris',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(item.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12.5, color: Theme.of(context).hintColor, height: 1.3)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        RatingChip(rating: item.rating, reviews: item.reviews),
                        const SizedBox(width: 10),
                        Icon(Icons.timer_outlined, size: 14, color: Theme.of(context).hintColor),
                        const SizedBox(width: 2),
                        Text('${item.prepMinutes} mnt',
                            style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(rupiah(item.price),
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                  color: cs.primary)),
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          tooltip: 'Favorit',
                          onPressed: () => app.toggleFavorite(item.id),
                          icon: Icon(
                            app.isFavorite(item.id)
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: Colors.redAccent,
                          ),
                        ),
                        Badge(
                          isLabelVisible: inCart > 0,
                          label: Text('$inCart'),
                          child: FilledButton.tonal(
                            style: FilledButton.styleFrom(
                              minimumSize: const Size(44, 38),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              app.add(item);
                              showSnack(context, '${item.name} ditambahkan ke keranjang');
                            },
                            child: const Icon(Icons.add_shopping_cart_rounded, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
