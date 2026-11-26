import 'package:flutter/material.dart';
import '../../../data/food_database.dart';
import '../../../l10n/app_localizations.dart';
import '../../../l10n/translations.dart';
import '../../../theme/app_theme.dart';
import 'food_pref_widgets.dart';

class StepFavorites extends StatefulWidget {
  final Set<String> favorites;
  final Set<String> allergies;
  final Set<String> allergyExceptions;
  final Set<String> excludedFoods;
  final ValueChanged<Set<String>> onFavoritesChanged;

  const StepFavorites({
    super.key,
    required this.favorites,
    required this.allergies,
    required this.allergyExceptions,
    this.excludedFoods = const {},
    required this.onFavoritesChanged,
  });

  @override
  State<StepFavorites> createState() => _StepFavoritesState();
}

class _StepFavoritesState extends State<StepFavorites> {
  final _expandedGroups = <int>{};

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final groups = filteredFoodGroups(widget.allergies, widget.allergyExceptions)
        .map((g) {
          final foods = g.foods.where((f) => !widget.excludedFoods.contains(f)).toList();
          return FoodGroup(emoji: g.emoji, title: g.title, foods: foods);
        })
        .where((g) => g.foods.isNotEmpty)
        .toList();
    final totalFavorites = widget.favorites.length;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.favoritesTitle,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.favoritesSubtitle,
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.4),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.favoritesInfoText,
                    style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SectionHeader(
            icon: Icons.favorite_rounded,
            iconColor: AppColors.secondary,
            title: l10n.myFavorites,
            subtitle: l10n.openCategoryAndSelect,
            trailing: totalFavorites > 0
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$totalFavorites',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < groups.length; i++) ...[
            ExpandableCategoryCard(
              emoji: groups[i].emoji,
              title: tr(groups[i].title, locale),
              items: groups[i].foods,
              selected: widget.favorites,
              isExpanded: _expandedGroups.contains(i),
              selectedColor: AppColors.secondary,
              onExpand: () => setState(() {
                if (_expandedGroups.contains(i)) {
                  _expandedGroups.remove(i);
                } else {
                  _expandedGroups.add(i);
                }
              }),
              onChanged: widget.onFavoritesChanged,
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
