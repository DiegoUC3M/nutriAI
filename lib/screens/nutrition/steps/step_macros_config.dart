import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_theme.dart';

class StepMacrosConfig extends StatelessWidget {
  final bool autoMacros;
  final double protein;
  final double carbs;
  final double fat;
  final String goal;
  final String sex;
  final int age;
  final double weight;
  final double height;
  final String activityLevel;

  final ValueChanged<bool> onAutoMacrosChanged;
  final ValueChanged<double> onProteinChanged;
  final ValueChanged<double> onCarbsChanged;
  final ValueChanged<double> onFatChanged;
  final ValueChanged<String> onGoalChanged;
  final ValueChanged<String> onSexChanged;
  final ValueChanged<int> onAgeChanged;
  final ValueChanged<double> onWeightChanged;
  final ValueChanged<double> onHeightChanged;
  final ValueChanged<String> onActivityChanged;

  const StepMacrosConfig({
    super.key,
    required this.autoMacros,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.goal,
    required this.sex,
    required this.age,
    required this.weight,
    required this.height,
    required this.activityLevel,
    required this.onAutoMacrosChanged,
    required this.onProteinChanged,
    required this.onCarbsChanged,
    required this.onFatChanged,
    required this.onGoalChanged,
    required this.onSexChanged,
    required this.onAgeChanged,
    required this.onWeightChanged,
    required this.onHeightChanged,
    required this.onActivityChanged,
  });

  int get _totalCalories =>
      ((protein * 4) + (carbs * 4) + (fat * 9)).round();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.configureMacros,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.macrosSubtitle,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),

          // Toggle auto/manual
          Row(
            children: [
              Expanded(
                child: _ModeButton(
                  icon: Icons.auto_awesome,
                  label: l10n.automatic,
                  subtitle: l10n.weCalculateForYou,
                  isSelected: autoMacros,
                  color: AppColors.accent,
                  onTap: () => onAutoMacrosChanged(true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ModeButton(
                  icon: Icons.tune,
                  label: l10n.manual,
                  subtitle: l10n.youDecide,
                  isSelected: !autoMacros,
                  color: AppColors.primary,
                  onTap: () => onAutoMacrosChanged(false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          if (autoMacros) ...[
            _buildAutoSection(context),
          ] else ...[
            _buildManualSection(context),
          ],

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildAutoSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Objetivo
        _SectionLabel(l10n.whatIsYourGoal),
        const SizedBox(height: 12),
        _OptionSelector(
          options: {
            'lose': l10n.loseFat,
            'maintain': l10n.maintainWeight,
            'gain': l10n.gainMuscle,
          },
          selected: goal,
          onChanged: onGoalChanged,
        ),
        const SizedBox(height: 24),

        // Sexo
        _SectionLabel(l10n.sexLabel),
        const SizedBox(height: 12),
        _OptionSelector(
          options: {
            'male': l10n.male,
            'female': l10n.female,
          },
          selected: sex,
          onChanged: onSexChanged,
        ),
        const SizedBox(height: 24),

        // Edad, Peso, Altura
        Row(
          children: [
            Expanded(
              child: _NumberInput(
                label: l10n.ageLabel,
                value: age.toString(),
                unit: l10n.yearsUnit,
                onChanged: (v) {
                  final parsed = int.tryParse(v);
                  if (parsed != null && parsed > 0 && parsed < 120) {
                    onAgeChanged(parsed);
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _NumberInput(
                label: l10n.weightLabel,
                value: weight.toStringAsFixed(0),
                unit: l10n.kgUnit,
                onChanged: (v) {
                  final parsed = double.tryParse(v);
                  if (parsed != null && parsed > 0) {
                    onWeightChanged(parsed);
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _NumberInput(
                label: l10n.heightLabel,
                value: height.toStringAsFixed(0),
                unit: l10n.cmUnit,
                onChanged: (v) {
                  final parsed = double.tryParse(v);
                  if (parsed != null && parsed > 0) {
                    onHeightChanged(parsed);
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Actividad física
        _SectionLabel(l10n.activityLevel),
        const SizedBox(height: 12),
        _ActivitySelector(
          selected: activityLevel,
          onChanged: onActivityChanged,
        ),
        const SizedBox(height: 28),

        // Resultado calculado
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.accent.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              Text(
                l10n.yourCalculatedPlan,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$_totalCalories kcal',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _MacroColumn(
                    label: l10n.proteinLabel,
                    grams: protein.round(),
                    color: AppColors.secondary,
                  ),
                  _MacroColumn(
                    label: l10n.carbsLabel,
                    grams: carbs.round(),
                    color: AppColors.primary,
                  ),
                  _MacroColumn(
                    label: l10n.fatLabel,
                    grams: fat.round(),
                    color: AppColors.warning,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildManualSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Calorías totales estimadas
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              Text(
                l10n.estimatedCalories,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$_totalCalories kcal',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Proteínas
        _MacroSlider(
          label: l10n.proteinsLabel,
          value: protein,
          unit: 'g',
          color: AppColors.secondary,
          min: 50,
          max: 350,
          info: '${(protein * 4).round()} kcal',
          onChanged: onProteinChanged,
        ),
        const SizedBox(height: 20),

        // Carbohidratos
        _MacroSlider(
          label: l10n.carbohydratesLabel,
          value: carbs,
          unit: 'g',
          color: AppColors.primary,
          min: 50,
          max: 500,
          info: '${(carbs * 4).round()} kcal',
          onChanged: onCarbsChanged,
        ),
        const SizedBox(height: 20),

        // Grasas
        _MacroSlider(
          label: l10n.fatsLabel,
          value: fat,
          unit: 'g',
          color: AppColors.warning,
          min: 20,
          max: 200,
          info: '${(fat * 9).round()} kcal',
          onChanged: onFatChanged,
        ),
      ],
    );
  }
}

class _ModeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _ModeButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : AppColors.surfaceLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? color : AppColors.textMuted, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected ? color : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _OptionSelector extends StatelessWidget {
  final Map<String, String> options;
  final String selected;
  final ValueChanged<String> onChanged;

  const _OptionSelector({
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.entries.map((entry) {
        final isSelected = entry.key == selected;
        return GestureDetector(
          onTap: () => onChanged(entry.key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.15)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.surfaceLight,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Text(
              entry.value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _NumberInput extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final ValueChanged<String> onChanged;

  const _NumberInput({
    required this.label,
    required this.value,
    required this.unit,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: value,
          keyboardType: TextInputType.number,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          decoration: InputDecoration(
            suffixText: unit,
            suffixStyle: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _MacroSlider extends StatelessWidget {
  final String label;
  final double value;
  final String unit;
  final Color color;
  final double min;
  final double max;
  final String info;
  final ValueChanged<double> onChanged;

  const _MacroSlider({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.min,
    required this.max,
    required this.info,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Row(
              children: [
                Text(
                  '${value.round()}$unit',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  info,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            inactiveTrackColor: color.withValues(alpha: 0.15),
            thumbColor: color,
            overlayColor: color.withValues(alpha: 0.15),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _MacroColumn extends StatelessWidget {
  final String label;
  final int grams;
  final Color color;

  const _MacroColumn({
    required this.label,
    required this.grams,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${grams}g',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _ActivitySelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const _ActivitySelector({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final options = [
      ('sedentary', l10n.sedentary, l10n.sedentaryDesc),
      ('light', l10n.lightActivity, l10n.lightActivityDesc),
      ('moderate', l10n.moderateActivity, l10n.moderateActivityDesc),
      ('active', l10n.activeActivity, l10n.activeActivityDesc),
      ('very_active', l10n.veryActiveActivity, l10n.veryActiveActivityDesc),
    ];
    return Column(
      children: options.map((option) {
        final (key, label, description) = option;
        final isSelected = key == selected;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: GestureDetector(
            onTap: () => onChanged(key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.surfaceLight,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected ? AppColors.primary.withValues(alpha: 0.7) : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
