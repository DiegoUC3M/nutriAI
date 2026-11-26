import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profileTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Avatar
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.secondary, width: 3),
              ),
              child: const CircleAvatar(
                radius: 52,
                backgroundColor: AppColors.surface,
                child: Icon(
                  Icons.person,
                  size: 56,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Nombre
            Text(
              l10n.user,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.freePlan,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),

            // Boton editar perfil
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Text(l10n.editProfile),
              ),
            ),
            const SizedBox(height: 24),

            // Stats row
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: l10n.streakLabel,
                    value: '0',
                    unit: l10n.daysUnitUpper,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: l10n.dietsLabel,
                    value: '0',
                    unit: l10n.createdLabel,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PlanBadge(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // AI Premium banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF1E1B4B),
                    Color(0xFF312E81),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_awesome, color: AppColors.accent, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        l10n.aiNutriAI,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.aiDescription,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: Text(l10n.subscribe),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Settings section
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.settingsAndData,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 16),

            _SettingsTile(
              icon: Icons.person_outline,
              iconColor: AppColors.primary,
              title: l10n.personalData,
              subtitle: l10n.personalDataSub,
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.restaurant_outlined,
              iconColor: AppColors.secondary,
              title: l10n.foodPreferences,
              subtitle: l10n.foodPreferencesSub,
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.track_changes,
              iconColor: AppColors.primary,
              title: l10n.nutritionalGoals,
              subtitle: l10n.nutritionalGoalsSub,
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.cloud_outlined,
              iconColor: AppColors.accent,
              title: l10n.sync,
              subtitle: l10n.syncSub,
              onTap: () {},
            ),

            const SizedBox(height: 24),

            // Log out
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                child: Text(l10n.logOut),
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              'APP VERSION 1.0.0',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textMuted,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            unit,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.surfaceLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PLAN',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.4),
              ),
            ),
            child: const Text(
              'FREE',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColors.accent,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.surfaceLight),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textMuted,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
