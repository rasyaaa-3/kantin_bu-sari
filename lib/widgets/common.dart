import 'package:flutter/material.dart';
import '../models/menu_item.dart';

/// Kotak gradient berisi emoji sebagai pengganti foto menu.
class MenuThumb extends StatelessWidget {
  final MenuItem item;
  final double size;
  final double radius;

  const MenuThumb({super.key, required this.item, this.size = 84, this.radius = 18});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'thumb-${item.id}',
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              item.color.withValues(alpha: 0.35),
              item.color.withValues(alpha: 0.85),
            ],
          ),
        ),
        child: Text(item.emoji, style: TextStyle(fontSize: size * 0.5)),
      ),
    );
  }
}

class RatingChip extends StatelessWidget {
  final double rating;
  final int reviews;
  const RatingChip({super.key, required this.rating, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, size: 16, color: Color(0xFFFFB300)),
        const SizedBox(width: 2),
        Text(rating.toString(),
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
        const SizedBox(width: 3),
        Text('($reviews)',
            style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  final Widget? trailing;
  const SectionTitle(this.text, {super.key, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(text,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w800)),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class QtyStepper extends StatelessWidget {
  final int value;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  const QtyStepper({super.key, required this.value, required this.onMinus, required this.onPlus});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.remove_rounded),
            onPressed: onMinus,
          ),
          SizedBox(
            width: 28,
            child: Text('$value',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(Icons.add_rounded, color: cs.primary),
            onPressed: onPlus,
          ),
        ],
      ),
    );
  }
}

void showSnack(BuildContext context, String msg,
    {SnackBarAction? action, IconData icon = Icons.check_circle_rounded}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        action: action,
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(msg)),
          ],
        ),
      ),
    );
}
