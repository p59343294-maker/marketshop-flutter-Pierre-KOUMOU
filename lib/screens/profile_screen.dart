// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/user_profile.dart';
import '../providers/profile_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _editing = false;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;

  @override
  void initState() {
    super.initState();
    final profile = context.read<ProfileProvider>().profile;
    _nameCtrl = TextEditingController(text: profile.name);
    _emailCtrl = TextEditingController(text: profile.email);
    _phoneCtrl = TextEditingController(text: profile.phone);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().load();
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _syncControllers(UserProfile profile) {
    if (!_editing) {
      _nameCtrl.text = profile.name;
      _emailCtrl.text = profile.email;
      _phoneCtrl.text = profile.phone;
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<ProfileProvider>();
    final updated = provider.profile.copyWith(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
    );
    await provider.save(updated);
    setState(() => _editing = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil sauvegardé !')),
      );
    }
  }

  Future<void> _clearData() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Vider mes données'),
        content: const Text('Cette action supprimera votre profil, votre panier et toutes vos commandes. Continuer ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Vider', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true && mounted) {
      await context.read<ProfileProvider>().clearData();
      await context.read<CartProvider>().clear();
      await context.read<OrderProvider>().clearAll();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Données supprimées')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          TextButton(
            onPressed: _editing ? _save : () => setState(() => _editing = true),
            child: Text(_editing ? 'Sauvegarder' : 'Modifier',
                style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, _) {
          _syncControllers(provider.profile);
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Avatar
              Center(
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColors.accent.withOpacity(0.15),
                  child: Text(
                    provider.profile.name.isNotEmpty ? provider.profile.name[0].toUpperCase() : '?',
                    style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w800, color: AppColors.accent),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Formulaire
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildField(
                      controller: _nameCtrl,
                      label: 'Nom complet',
                      icon: Icons.person_outline,
                      enabled: _editing,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Champ obligatoire' : null,
                    ),
                    const SizedBox(height: 12),
                    _buildField(
                      controller: _emailCtrl,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      enabled: _editing,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Champ obligatoire' : null,
                    ),
                    const SizedBox(height: 12),
                    _buildField(
                      controller: _phoneCtrl,
                      label: 'Téléphone',
                      icon: Icons.phone_outlined,
                      enabled: _editing,
                      keyboardType: TextInputType.phone,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Champ obligatoire';
                        if (!RegExp(r'^\d+$').hasMatch(v.trim())) return 'Numérique uniquement';
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Mode sombre
              Card(
                child: SwitchListTile(
                  title: const Text('Mode sombre', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Activer le thème sombre'),
                  secondary: Icon(
                    provider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: AppColors.accent,
                  ),
                  value: provider.isDarkMode,
                  activeColor: AppColors.accent,
                  onChanged: (val) => provider.toggleDarkMode(val),
                ),
              ),
              const SizedBox(height: 16),

              // Vider données
              OutlinedButton.icon(
                onPressed: _clearData,
                icon: const Icon(Icons.delete_sweep_outlined, color: Colors.red),
                label: const Text('Vider mes données', style: TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool enabled,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
      ),
    );
  }
}
