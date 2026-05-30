// lib/screens/catalogue_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/catalogue_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import '../theme/app_theme.dart';

class CatalogueScreen extends StatefulWidget {
  const CatalogueScreen({super.key});

  @override
  State<CatalogueScreen> createState() => _CatalogueScreenState();
}

class _CatalogueScreenState extends State<CatalogueScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<CatalogueProvider>();
      if (provider.status == CatalogueStatus.idle) {
        provider.loadProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogue'),
        actions: [
          Consumer<CartProvider>(
            builder: (_, cart, __) => Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () {},
                ),
                if (cart.itemCount > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${cart.itemCount}',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: Consumer<CatalogueProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              // Filtres catégories
              if (provider.categories.isNotEmpty)
                _CategoryFilter(
                  categories: provider.categories,
                  selected: provider.selectedCategory,
                  onSelected: (cat) => provider.filterByCategory(cat),
                ),

              // Corps principal
              Expanded(
                child: switch (provider.status) {
                  CatalogueStatus.loading => const Center(child: CircularProgressIndicator()),
                  CatalogueStatus.error => _ErrorView(
                      message: provider.errorMessage,
                      onRetry: provider.loadProducts,
                    ),
                  _ => provider.products.isEmpty
                      ? const Center(child: Text('Aucun produit trouvé'))
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.68,
                          ),
                          itemCount: provider.products.length,
                          itemBuilder: (context, index) {
                            final product = provider.products[index];
                            return ProductCard(
                              product: product,
                              onTap: () => context.push('/product/${product.id}'),
                            );
                          },
                        ),
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CategoryFilter extends StatelessWidget {
  final List<String> categories;
  final String? selected;
  final ValueChanged<String?> onSelected;

  const _CategoryFilter({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // Chip "Tous"
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: const Text('Tous'),
              selected: selected == null,
              onSelected: (_) => onSelected(null),
            ),
          ),
          ...categories.map((cat) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(cat),
                  selected: selected == cat,
                  onSelected: (_) => onSelected(cat),
                ),
              )),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }
}
