// lib/screens/order_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../data/models/order.dart';
import '../providers/order_provider.dart';
import '../theme/app_theme.dart';

class OrderDetailScreen extends StatelessWidget {
  final int orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd/MM/yyyy à HH:mm', 'fr_FR');
    final orders = context.read<OrderProvider>().orders;
    final Order? order = orders.where((o) => o.id == orderId).firstOrNull;

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Commande')),
        body: const Center(child: Text('Commande introuvable')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(order.orderNumber)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Infos commande
          _InfoSection(order: order, fmt: fmt),
          const SizedBox(height: 20),

          // Produits
          const Text('Articles commandés', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ...order.items.map((item) => _OrderItemTile(item: item)),
          const Divider(height: 32),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total payé', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
              Text(
                '${order.total.toStringAsFixed(2)} €',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.accent),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final Order order;
  final DateFormat fmt;

  const _InfoSection({required this.order, required this.fmt});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Informations', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            const SizedBox(height: 12),
            _Row(label: 'Date', value: fmt.format(order.date)),
            _Row(label: 'Nom', value: order.fullName),
            _Row(label: 'Téléphone', value: order.phone),
            _Row(label: 'Adresse', value: order.address),
            _Row(label: 'Ville', value: order.city),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;

  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

class _OrderItemTile extends StatelessWidget {
  final OrderItem item;

  const _OrderItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 52,
                height: 52,
                color: Colors.white,
                padding: const EdgeInsets.all(4),
                child: CachedNetworkImage(
                  imageUrl: item.image,
                  fit: BoxFit.contain,
                  errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text('${item.price.toStringAsFixed(2)} € × ${item.quantity}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            Text('${item.subtotal.toStringAsFixed(2)} €', style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.accent)),
          ],
        ),
      ),
    );
  }
}
