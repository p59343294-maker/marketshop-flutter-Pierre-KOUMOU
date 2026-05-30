// lib/widgets/cart_line.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../data/models/cart_item.dart';
import '../theme/app_theme.dart';

class CartLine extends StatelessWidget {
  final CartItem item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onDelete;

  const CartLine({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 64,
                height: 64,
                color: Colors.white,
                padding: const EdgeInsets.all(6),
                child: CachedNetworkImage(
                  imageUrl: item.image,
                  fit: BoxFit.contain,
                  errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.price.toStringAsFixed(2)} € / unité',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Quantité
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            _QuantityButton(
                              icon: Icons.remove,
                              onTap: () => onQuantityChanged(item.quantity - 1),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                '${item.quantity}',
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                              ),
                            ),
                            _QuantityButton(
                              icon: Icons.add,
                              onTap: () => onQuantityChanged(item.quantity + 1),
                            ),
                          ],
                        ),
                      ),
                      // Sous-total + suppression
                      Row(
                        children: [
                          Text(
                            '${item.subtotal.toStringAsFixed(2)} €',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.accent,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: onDelete,
                            child: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 16),
      ),
    );
  }
}
