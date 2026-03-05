import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class StepFoodPreferences extends StatelessWidget {
  final Set<String> favorites;
  final Set<String> allergies;
  final Set<String> disliked;
  final ValueChanged<Set<String>> onFavoritesChanged;
  final ValueChanged<Set<String>> onAllergiesChanged;
  final ValueChanged<Set<String>> onDislikedChanged;

  const StepFoodPreferences({
    super.key,
    required this.favorites,
    required this.allergies,
    required this.disliked,
    required this.onFavoritesChanged,
    required this.onAllergiesChanged,
    required this.onDislikedChanged,
  });

  static const _proteins = [
    'Pollo', 'Pavo', 'Ternera', 'Cerdo', 'Salmón', 'Atún',
    'Merluza', 'Huevos', 'Tofu', 'Tempeh', 'Lentejas',
    'Garbanzos', 'Gambas', 'Sardinas',
  ];

  static const _carbs = [
    'Arroz', 'Pasta', 'Pan integral', 'Avena', 'Patata',
    'Boniato', 'Quinoa', 'Cuscús', 'Maíz', 'Tortillas',
  ];

  static const _fats = [
    'Aceite de oliva', 'Aguacate', 'Frutos secos', 'Mantequilla de cacahuete',
    'Semillas de chía', 'Almendras', 'Nueces',
  ];

  static const _veggies = [
    'Brócoli', 'Espinacas', 'Tomate', 'Pepino', 'Zanahoria',
    'Calabacín', 'Pimiento', 'Cebolla', 'Lechuga', 'Champiñones',
    'Judías verdes', 'Espárragos',
  ];

  static const _fruits = [
    'Plátano', 'Manzana', 'Naranja', 'Fresas', 'Arándanos',
    'Kiwi', 'Piña', 'Mango', 'Uvas', 'Pera',
  ];

  static const _allergyOptions = [
    'Gluten', 'Lactosa', 'Frutos secos', 'Mariscos', 'Huevo',
    'Soja', 'Pescado', 'Cacahuetes',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '¿Qué te gusta comer?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Selecciona tus alimentos favoritos y los que quieres evitar para personalizar tu dieta.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 28),

          // Alergias
          _SectionHeader(
            icon: Icons.warning_amber_rounded,
            iconColor: AppColors.warning,
            title: 'Alergias o intolerancias',
          ),
          const SizedBox(height: 12),
          _ChipGroup(
            items: _allergyOptions,
            selected: allergies,
            selectedColor: AppColors.error,
            onChanged: onAllergiesChanged,
          ),
          const SizedBox(height: 28),

          // Favoritos - Proteínas
          _SectionHeader(
            icon: Icons.favorite,
            iconColor: AppColors.secondary,
            title: 'Proteínas favoritas',
          ),
          const SizedBox(height: 12),
          _ChipGroup(
            items: _proteins,
            selected: favorites,
            selectedColor: AppColors.secondary,
            onChanged: onFavoritesChanged,
          ),
          const SizedBox(height: 28),

          // Carbohidratos
          _SectionHeader(
            icon: Icons.grain,
            iconColor: AppColors.primary,
            title: 'Carbohidratos',
          ),
          const SizedBox(height: 12),
          _ChipGroup(
            items: _carbs,
            selected: favorites,
            selectedColor: AppColors.secondary,
            onChanged: onFavoritesChanged,
          ),
          const SizedBox(height: 28),

          // Grasas saludables
          _SectionHeader(
            icon: Icons.water_drop,
            iconColor: AppColors.primaryLight,
            title: 'Grasas saludables',
          ),
          const SizedBox(height: 12),
          _ChipGroup(
            items: _fats,
            selected: favorites,
            selectedColor: AppColors.secondary,
            onChanged: onFavoritesChanged,
          ),
          const SizedBox(height: 28),

          // Verduras
          _SectionHeader(
            icon: Icons.eco,
            iconColor: AppColors.secondary,
            title: 'Verduras',
          ),
          const SizedBox(height: 12),
          _ChipGroup(
            items: _veggies,
            selected: favorites,
            selectedColor: AppColors.secondary,
            onChanged: onFavoritesChanged,
          ),
          const SizedBox(height: 28),

          // Frutas
          _SectionHeader(
            icon: Icons.apple,
            iconColor: AppColors.warning,
            title: 'Frutas',
          ),
          const SizedBox(height: 12),
          _ChipGroup(
            items: _fruits,
            selected: favorites,
            selectedColor: AppColors.secondary,
            onChanged: onFavoritesChanged,
          ),
          const SizedBox(height: 28),

          // Alimentos a evitar
          _SectionHeader(
            icon: Icons.block,
            iconColor: AppColors.error,
            title: 'Alimentos que no te gustan',
          ),
          const SizedBox(height: 8),
          const Text(
            'Pulsa alimentos que NO quieres en tu dieta',
            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 12),
          _ChipGroup(
            items: [..._proteins, ..._carbs, ..._veggies],
            selected: disliked,
            selectedColor: AppColors.error,
            onChanged: onDislikedChanged,
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;

  const _SectionHeader({
    required this.icon,
    required this.iconColor,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _ChipGroup extends StatelessWidget {
  final List<String> items;
  final Set<String> selected;
  final Color selectedColor;
  final ValueChanged<Set<String>> onChanged;

  const _ChipGroup({
    required this.items,
    required this.selected,
    required this.selectedColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        final isSelected = selected.contains(item);
        return GestureDetector(
          onTap: () {
            if (isSelected) {
              selected.remove(item);
            } else {
              selected.add(item);
            }
            onChanged(selected);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? selectedColor.withValues(alpha: 0.15)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? selectedColor : AppColors.surfaceLight,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Text(
              item,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? selectedColor : AppColors.textSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
