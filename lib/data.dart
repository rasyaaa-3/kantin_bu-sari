import 'models.dart';

const List<String> kCategories = ['Semua', 'Makanan', 'Minuman', 'Camilan'];

const List<MenuItem> kMenu = [
  MenuItem(
    id: 'm1',
    name: 'Nasi Goreng Spesial',
    emoji: '🍛',
    category: 'Makanan',
    price: 18000,
    description: 'Nasi goreng bumbu rempah dengan telur mata sapi, ayam suwir, dan kerupuk.',
  ),
  MenuItem(
    id: 'm2',
    name: 'Mie Ayam Bakso',
    emoji: '🍜',
    category: 'Makanan',
    price: 16000,
    description: 'Mie kenyal dengan ayam kecap dan dua butir bakso dalam kuah kaldu hangat.',
  ),
  MenuItem(
    id: 'm3',
    name: 'Ayam Geprek',
    emoji: '🍗',
    category: 'Makanan',
    price: 20000,
    description: 'Ayam goreng tepung digeprek dengan sambal bawang pedas dan nasi hangat.',
  ),
  MenuItem(
    id: 'm4',
    name: 'Es Teh Manis',
    emoji: '🧋',
    category: 'Minuman',
    price: 5000,
    description: 'Teh seduh segar dengan gula dan es batu, cocok untuk menemani makan siang.',
  ),
  MenuItem(
    id: 'm5',
    name: 'Es Jeruk Peras',
    emoji: '🍊',
    category: 'Minuman',
    price: 8000,
    description: 'Perasan jeruk asli yang segar dengan sedikit gula dan es batu.',
  ),
  MenuItem(
    id: 'm6',
    name: 'Pisang Goreng',
    emoji: '🍌',
    category: 'Camilan',
    price: 10000,
    description: 'Pisang kepok goreng berbalut tepung renyah, disajikan hangat.',
  ),
  MenuItem(
    id: 'm7',
    name: 'Tahu Crispy',
    emoji: '🥟',
    category: 'Camilan',
    price: 8000,
    description: 'Tahu goreng tepung garing dengan bumbu tabur gurih dan sambal.',
  ),
];
