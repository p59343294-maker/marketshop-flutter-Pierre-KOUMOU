// lib/screens/checkout_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/models/order.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../theme/app_theme.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  bool _processing = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _processing = true);

    final cart = context.read<CartProvider>();
    final orderProvider = context.read<OrderProvider>();

    final order = Order(
      orderNumber: 'CMD-${DateTime.now().millisecondsSinceEpoch}',
      date: DateTime.now(),
      fullName: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      city: _cityCtrl.text.trim(),
      items: cart.items
          .map((c) => OrderItem(
                productId: c.productId,
                title: c.title,
                price: c.price,
                image: c.image,
                quantity: c.quantity,
              ))
          .toList(),
      total: cart.total,
    );

    await orderProvider.placeOrder(order);
    await cart.clear();

    if (mounted) {
      context.go('/history');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Passer commande')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Formulaire
            const Text('Informations de livraison', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            _buildField(
              controller: _nameCtrl,
              label: 'Nom complet',
              icon: Icons.person_outline,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Champ obligatoire' : null,
            ),
            const SizedBox(height: 12),
            _buildField(
              controller: _phoneCtrl,
              label: 'Téléphone',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Champ obligatoire';
                if (!RegExp(r'^\d+$').hasMatch(v.trim())) return 'Numérique uniquement';
                return null;
              },
            ),
            const SizedBox(height: 12),
            _buildField(
              controller: _addressCtrl,
              label: 'Adresse',
              icon: Icons.home_outlined,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Champ obligatoire' : null,
            ),
            const SizedBox(height: 12),
            _buildField(
              controller: _cityCtrl,
              label: 'Ville',
              icon: Icons.location_city_outlined,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Champ obligatoire' : null,
            ),
            const SizedBox(height: 28),

            // Récapitulatif
            const Text('Récapitulatif', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            ...cart.items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${item.title} × ${item.quantity}',
                          style: const TextStyle(fontSize: 13),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '${item.subtotal.toStringAsFixed(2)} €',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                )),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                Text(
                  '${cart.total.toStringAsFixed(2)} €',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.accent),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _processing ? null : _confirm,
                icon: _processing
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.check_circle_outline),
                label: Text(_processing ? 'Confirmation...' : 'Confirmer la commande'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
      ),
    );
  }
}
