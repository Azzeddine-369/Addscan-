import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../domain/entities/additive.dart';
import '../../../domain/entities/product.dart';
import '../../providers/additives_provider.dart';
import '../../providers/history_saved_provider.dart';
import '../../providers/products_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/expandable_info_card.dart';
import '../../widgets/safety_info_bottom_sheet.dart';
import '../../widgets/source_illustration.dart';

class AdditiveDetailsScreen extends ConsumerWidget {
  final String code;

  const AdditiveDetailsScreen({
    super.key,
    required this.code,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final additiveAsync = ref.watch(additiveDetailsProvider(code));
    final isSavedAsync = ref.watch(isAdditiveSavedProvider(code));
    final productsAsync = ref.watch(productsForAdditiveProvider(code));
    final langCode = ref.watch(settingsNotifierProvider).locale.languageCode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          context.tr('detailsTitle'),
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
        centerTitle: true,
        actions: [
          // Bookmark Toggle Icon
          additiveAsync.when(
            data: (additive) {
              if (additive == null) return const SizedBox.shrink();
              final isSaved = isSavedAsync.valueOrNull ?? false;
              return IconButton(
                icon: Icon(
                  isSaved ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                  color: isSaved ? AppColors.primaryTeal : (isDark ? Colors.white70 : AppColors.textPrimaryLight),
                  size: 24,
                ),
                onPressed: () async {
                  final nowSaved = await ref.read(savedNotifierProvider.notifier).toggleSave(additive);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(nowSaved ? context.tr('itemSaved') : context.tr('itemUnsaved')),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // Share Icon
          additiveAsync.when(
            data: (additive) {
              if (additive == null) return const SizedBox.shrink();
              return IconButton(
                icon: Icon(
                  Icons.share_outlined,
                  color: isDark ? Colors.white70 : AppColors.textPrimaryLight,
                  size: 22,
                ),
                onPressed: () {
                  final text = '${additive.code} - ${additive.getLocalizedName(langCode)}\n'
                      'Category: ${additive.category ?? "Food Additive"}\n'
                      'Safety: ${additive.safetyLabel}\n\n'
                      '${additive.overview ?? ""}\n\n'
                      'Information via AddiScan (Open Food Facts & EFSA)';
                  Share.share(text, subject: '${additive.code} Details');
                },
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: additiveAsync.when(
        data: (additive) {
          if (additive == null) {
            return Center(
              child: Text(
                'Additive "$code" not found',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Large Source Illustration
                Center(
                  child: SourceIllustration(
                    iconType: additive.iconType,
                    size: 130,
                  ),
                ),
                const SizedBox(height: 12),

                // 2. Big Bold E-Code
                Text(
                  additive.code,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                  ),
                ),

                // Name
                const SizedBox(height: 2),
                Text(
                  additive.getLocalizedName(langCode),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white70 : AppColors.textPrimaryLight.withOpacity(0.85),
                  ),
                ),

                // Category chip (e.g. Acidity Regulator / Antioxidant)
                if (additive.category != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      additive.category!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                // 3. Safety Banner
                _buildSafetyBanner(context, additive, isDark),

                const SizedBox(height: 16),

                // 4. Tag Cards (Vegan, No Allergen, Natural Origin - shown only when data supports it)
                _buildTagCardsRow(context, additive, isDark),

                const SizedBox(height: 18),

                // 5. Expandable Sections
                ExpandableInfoCard(
                  icon: Icons.science_outlined,
                  iconColor: const Color(0xFF0284C7),
                  title: context.tr('overviewRole'),
                  content: additive.overview,
                  initiallyExpanded: true,
                ),
                ExpandableInfoCard(
                  icon: Icons.spa_outlined,
                  iconColor: const Color(0xFF16A34A),
                  title: context.tr('originSource'),
                  content: additive.origin,
                ),
                ExpandableInfoCard(
                  icon: Icons.restaurant_outlined,
                  iconColor: const Color(0xFF2563EB),
                  title: context.tr('commonFoods'),
                  content: additive.commonFoods,
                ),
                ExpandableInfoCard(
                  icon: Icons.shield_outlined,
                  iconColor: const Color(0xFF0D9488),
                  title: context.tr('regulatoryNotes'),
                  content: additive.regulatoryNotes,
                ),

                const SizedBox(height: 16),

                // 6. Products containing this additive (from Open Food Facts live)
                _buildProductsSection(context, productsAsync, isDark),

                const SizedBox(height: 24),

                // 7. Bottom Action Buttons: Compare (outlined) + Report / Suggest Update (filled teal)
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.balance_rounded, size: 20),
                        label: Text(context.tr('compare')),
                        onPressed: () {
                          context.push('/compare?code=${additive.code}');
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 6,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.warning_amber_rounded, size: 20),
                        label: Text(
                          context.tr('reportUpdate'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onPressed: () {
                          context.push('/report?code=${additive.code}');
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Medical Disclaimer note
                Text(
                  context.tr('medicalDisclaimerText'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.4,
                    color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primaryTeal),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildSafetyBanner(BuildContext context, Additive additive, bool isDark) {
    Color bg;
    Color border;
    Color iconColor;
    IconData icon;
    String title;
    String desc;

    switch (additive.safetyStatus) {
      case SafetyStatus.safe:
        bg = isDark ? const Color(0xFF132B23) : const Color(0xFFE8F8F0);
        border = isDark ? const Color(0xFF1E4638) : const Color(0xFFA7F3D0);
        iconColor = AppColors.safeGreenDark;
        icon = Icons.check_circle_rounded;
        title = context.tr('generallyRecognizedAsSafe');
        desc = additive.safetyDescription.isNotEmpty
            ? additive.safetyDescription
            : 'Widely used in food, with no major health concerns at normal levels.';
        break;
      case SafetyStatus.caution:
        bg = isDark ? const Color(0xFF332311) : const Color(0xFFFFF7ED);
        border = isDark ? const Color(0xFF573919) : const Color(0xFFFDE68A);
        iconColor = AppColors.cautionOrangeDark;
        icon = Icons.warning_rounded;
        title = context.tr('useWithCaution');
        desc = additive.safetyDescription.isNotEmpty
            ? additive.safetyDescription
            : 'Potential health risks or exposure limits flagged by regulatory evaluations.';
        break;
      case SafetyStatus.notEvaluated:
      default:
        bg = isDark ? AppColors.cardDark : AppColors.neutralGreyBg;
        border = isDark ? AppColors.dividerDark : AppColors.neutralGreyBorder;
        iconColor = AppColors.neutralGrey;
        icon = Icons.help_outline_rounded;
        title = context.tr('notEvaluated');
        desc = 'No conclusive safety assessment data in the source taxonomy.';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : iconColor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.35,
                    color: isDark ? Colors.white70 : AppColors.textPrimaryLight.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.info_outline_rounded,
              color: isDark ? Colors.white70 : iconColor,
              size: 22,
            ),
            onPressed: () => SafetyInfoBottomSheet.show(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTagCardsRow(BuildContext context, Additive additive, bool isDark) {
    final tags = <Widget>[];

    if (additive.vegan == true) {
      tags.add(_buildTagCard(
        icon: Icons.eco_outlined,
        color: const Color(0xFF16A34A),
        bg: isDark ? const Color(0xFF142E1F) : const Color(0xFFEDFBF2),
        label: context.tr('veganFriendly'),
        isDark: isDark,
      ));
    }

    if (additive.noMajorAllergen == true) {
      tags.add(_buildTagCard(
        icon: Icons.grain_rounded,
        color: const Color(0xFFD97706),
        bg: isDark ? const Color(0xFF332410) : const Color(0xFFFEF3C7),
        label: context.tr('noMajorAllergen'),
        isDark: isDark,
      ));
    }

    if (additive.naturalOrigin == true) {
      tags.add(_buildTagCard(
        icon: Icons.public_rounded,
        color: const Color(0xFF0D9488),
        bg: isDark ? const Color(0xFF132B27) : const Color(0xFFE6F7F5),
        label: context.tr('naturalOrigin'),
        isDark: isDark,
      ));
    }

    if (tags.isEmpty) return const SizedBox.shrink();

    return Row(
      children: tags.map((t) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: t))).toList(),
    );
  }

  Widget _buildTagCard({
    required IconData icon,
    required Color color,
    required Color bg,
    required String label,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : color,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsSection(
    BuildContext context,
    AsyncValue<List<Product>> productsAsync,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.shopping_basket_outlined, color: AppColors.primaryTeal, size: 20),
            const SizedBox(width: 8),
            Text(
              context.tr('productsContaining'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : AppColors.textPrimaryLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        productsAsync.when(
          data: (products) {
            if (products.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppColors.softShadow,
                ),
                child: Text(
                  context.tr('noProductsFound'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textTertiaryLight,
                  ),
                ),
              );
            }

            return SizedBox(
              height: 165,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final p = products[index];
                  return Container(
                    width: 130,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: AppColors.softShadow,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product image
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: p.imageUrl != null
                                ? CachedNetworkImage(
                                    imageUrl: p.imageUrl!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    placeholder: (_, __) => Container(
                                      color: isDark ? Colors.black26 : Colors.black12,
                                      child: const Center(
                                        child: SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryTeal),
                                        ),
                                      ),
                                    ),
                                    errorWidget: (_, __, ___) => const Center(
                                      child: Icon(Icons.fastfood_rounded, color: AppColors.primaryTeal, size: 28),
                                    ),
                                  )
                                : const Center(
                                    child: Icon(Icons.fastfood_rounded, color: AppColors.primaryTeal, size: 28),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          p.productName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : AppColors.textPrimaryLight,
                          ),
                        ),
                        Text(
                          p.displayBrand,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.5,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
          loading: () => const SizedBox(
            height: 80,
            child: Center(child: CircularProgressIndicator(color: AppColors.primaryTeal)),
          ),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}
