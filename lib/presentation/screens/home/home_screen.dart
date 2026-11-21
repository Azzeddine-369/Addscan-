import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../domain/entities/additive.dart';
import '../../providers/additives_provider.dart';
import '../../providers/history_saved_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/additive_card.dart';
import '../../widgets/addiscan_logo.dart';
import '../../widgets/footer_credit.dart';
import '../../widgets/fruit_hero_illustration.dart';
import '../../widgets/search_bar_widget.dart';
import '../../widgets/source_illustration.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final popularAsync = ref.watch(popularAdditivesProvider);
    final historyAsync = ref.watch(historyNotifierProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final searchResultsAsync = ref.watch(searchResultsProvider);
    final langCode = ref.watch(settingsNotifierProvider).locale.languageCode;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header Bar: Logo + Tagline + Settings Icon
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AddiScanLogo(size: 36, showTagline: true),
                  IconButton(
                    icon: Icon(
                      Icons.settings_outlined,
                      color: isDark ? Colors.white70 : AppColors.textPrimaryLight,
                      size: 24,
                    ),
                    onPressed: () => context.push('/settings'),
                  ),
                ],
              ),
            ),

            // Search Bar (Pinned right under header for accessibility)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SearchBarWidget(
                controller: _searchController,
                onChanged: (val) {
                  ref.read(searchQueryProvider.notifier).state = val;
                },
                onScanPressed: () => context.push('/scanner'),
                onClear: () {
                  ref.read(searchQueryProvider.notifier).state = '';
                },
              ),
            ),
            const SizedBox(height: 12),

            // Body: If searching, show search results; otherwise show Home Content
            Expanded(
              child: searchQuery.trim().isNotEmpty
                  ? _buildSearchResults(searchResultsAsync, langCode, isDark)
                  : _buildHomeContent(popularAsync, historyAsync, langCode, isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(
    AsyncValue<List<Additive>> searchResultsAsync,
    String langCode,
    bool isDark,
  ) {
    return searchResultsAsync.when(
      data: (items) {
        if (items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search_off_rounded, size: 56, color: AppColors.textTertiaryLight),
                  const SizedBox(height: 14),
                  Text(
                    context.tr('emptyFilter'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return AdditiveCard(
              code: item.code,
              name: item.getLocalizedName(langCode),
              safetyStatus: item.safetyStatus,
              iconType: item.iconType,
              subtitle: item.category,
              onTap: () => _openAdditive(item),
            );
          },
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primaryTeal),
      ),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildHomeContent(
    AsyncValue<List<Additive>> popularAsync,
    AsyncValue<List<dynamic>> historyAsync,
    String langCode,
    bool isDark,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Hero Card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 4, bottom: 20),
            padding: const EdgeInsets.fromLTRB(20, 18, 14, 18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF16322E), const Color(0xFF0F2623)]
                    : [const Color(0xFFE6F7F3), const Color(0xFFD6F3EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isDark ? const Color(0xFF234C45) : const Color(0xFFBFEADB),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.tr('heroTitle'),
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          height: 1.25,
                          color: isDark ? Colors.white : const Color(0xFF0C4D44),
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        context.tr('heroSubtitle'),
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.35,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white70 : const Color(0xFF1E5D52),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const FruitHeroIllustration(width: 105, height: 105),
              ],
            ),
          ),

          // 2. Popular Searches Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.tr('popularSearches'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                ),
              ),
              InkWell(
                onTap: () => _openAllAdditivesCatalog(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        context.tr('seeAll'),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryTeal,
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.primaryTeal),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Popular Chips Horizontal List
          popularAsync.when(
            data: (popularList) {
              return SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: popularList.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final item = popularList[index];
                    return _buildPopularChip(item, isDark);
                  },
                ),
              );
            },
            loading: () => const SizedBox(
              height: 48,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryTeal)),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),

          const SizedBox(height: 24),

          // 3. Your Recent Searches Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.history_rounded, size: 20, color: AppColors.primaryTeal),
                  const SizedBox(width: 6),
                  Text(
                    context.tr('recentSearches'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => context.go('/history'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        context.tr('seeAll'),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryTeal,
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.primaryTeal),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Recent Searches List (Top 3-4 items from design)
          historyAsync.when(
            data: (items) {
              if (items.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      context.tr('emptyHistory'),
                      style: TextStyle(color: AppColors.textTertiaryLight, fontSize: 14),
                    ),
                  ),
                );
              }

              final displayItems = items.take(4).toList();
              return Column(
                children: displayItems.map((item) {
                  SafetyStatus status;
                  switch (item.safetyStatus.toString().toLowerCase()) {
                    case 'safe':
                      status = SafetyStatus.safe;
                      break;
                    case 'caution':
                      status = SafetyStatus.caution;
                      break;
                    default:
                      status = SafetyStatus.notEvaluated;
                  }

                  return AdditiveCard(
                    code: item.additiveCode,
                    name: item.additiveName,
                    safetyStatus: status,
                    iconType: item.iconType,
                    onTap: () => _openAdditiveByCode(item.additiveCode),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(color: AppColors.primaryTeal),
              ),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),

          const SizedBox(height: 16),

          // Footer Credit
          const FooterCredit(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildPopularChip(Additive item, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.softShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openAdditive(item),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SourceIllustration(iconType: item.iconType, size: 22),
                const SizedBox(width: 8),
                Text(
                  item.code,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openAdditive(Additive additive) {
    ref.read(historyNotifierProvider.notifier).recordVisit(additive);
    context.push('/details/${additive.code}');
  }

  void _openAdditiveByCode(String code) async {
    final additive = await ref.read(additiveDetailsProvider(code).future);
    if (additive != null && mounted) {
      ref.read(historyNotifierProvider.notifier).recordVisit(additive);
      context.push('/details/${additive.code}');
    }
  }

  void _openAllAdditivesCatalog() {
    // Fill search bar with 'E' to show all catalog entries
    _searchController.text = 'E';
    ref.read(searchQueryProvider.notifier).state = 'E';
  }
}
