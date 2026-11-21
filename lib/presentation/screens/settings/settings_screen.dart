import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../providers/history_saved_provider.dart';
import '../../providers/products_provider.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settings = ref.watch(settingsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          context.tr('settings'),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          // Section 1: Language
          _buildSectionHeader(context.tr('language'), isDark),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: AppColors.softShadow,
            ),
            child: Column(
              children: [
                _buildLanguageTile(
                  title: 'English',
                  subtitle: 'English',
                  code: 'en',
                  currentLocale: settings.locale,
                  onSelect: () => ref.read(settingsNotifierProvider.notifier).setLocale(const Locale('en')),
                ),
                Divider(height: 1, color: isDark ? AppColors.dividerDark : AppColors.dividerLight),
                _buildLanguageTile(
                  title: 'Français',
                  subtitle: 'French',
                  code: 'fr',
                  currentLocale: settings.locale,
                  onSelect: () => ref.read(settingsNotifierProvider.notifier).setLocale(const Locale('fr')),
                ),
                Divider(height: 1, color: isDark ? AppColors.dividerDark : AppColors.dividerLight),
                _buildLanguageTile(
                  title: 'العربية',
                  subtitle: 'Arabic (RTL)',
                  code: 'ar',
                  currentLocale: settings.locale,
                  onSelect: () => ref.read(settingsNotifierProvider.notifier).setLocale(const Locale('ar')),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Section 2: Appearance / Theme
          _buildSectionHeader(context.tr('theme'), isDark),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: AppColors.softShadow,
            ),
            child: Column(
              children: [
                _buildThemeTile(
                  title: context.tr('themeLight'),
                  icon: Icons.light_mode_outlined,
                  mode: ThemeMode.light,
                  currentMode: settings.themeMode,
                  onSelect: () => ref.read(settingsNotifierProvider.notifier).setThemeMode(ThemeMode.light),
                ),
                Divider(height: 1, color: isDark ? AppColors.dividerDark : AppColors.dividerLight),
                _buildThemeTile(
                  title: context.tr('themeDark'),
                  icon: Icons.dark_mode_outlined,
                  mode: ThemeMode.dark,
                  currentMode: settings.themeMode,
                  onSelect: () => ref.read(settingsNotifierProvider.notifier).setThemeMode(ThemeMode.dark),
                ),
                Divider(height: 1, color: isDark ? AppColors.dividerDark : AppColors.dividerLight),
                _buildThemeTile(
                  title: context.tr('themeSystem'),
                  icon: Icons.settings_brightness_outlined,
                  mode: ThemeMode.system,
                  currentMode: settings.themeMode,
                  onSelect: () => ref.read(settingsNotifierProvider.notifier).setThemeMode(ThemeMode.system),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Section 3: Data & Storage
          _buildSectionHeader('Data & Storage', isDark),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: AppColors.softShadow,
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent),
                  title: Text(
                    context.tr('clearHistory'),
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () async {
                    await ref.read(historyNotifierProvider.notifier).clearAll();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(context.tr('historyCleared')),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                ),
                Divider(height: 1, color: isDark ? AppColors.dividerDark : AppColors.dividerLight),
                ListTile(
                  leading: const Icon(Icons.cleaning_services_outlined, color: AppColors.primaryTeal),
                  title: Text(
                    context.tr('clearCache'),
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () async {
                    await ref.read(cacheManagerProvider).clearAllCache();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(context.tr('cacheCleared')),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: isDark ? AppColors.textTertiaryDark : AppColors.textSecondaryLight,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildLanguageTile({
    required String title,
    required String subtitle,
    required String code,
    required Locale currentLocale,
    required VoidCallback onSelect,
  }) {
    final isSelected = currentLocale.languageCode == code;

    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryTeal)
          : null,
      onTap: onSelect,
    );
  }

  Widget _buildThemeTile({
    required String title,
    required IconData icon,
    required ThemeMode mode,
    required ThemeMode currentMode,
    required VoidCallback onSelect,
  }) {
    final isSelected = currentMode == mode;

    return ListTile(
      leading: Icon(icon, color: isSelected ? AppColors.primaryTeal : AppColors.textSecondaryLight),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.5,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.radio_button_checked_rounded, color: AppColors.primaryTeal)
          : const Icon(Icons.radio_button_off_rounded, color: AppColors.textTertiaryLight),
      onTap: onSelect,
    );
  }
}
