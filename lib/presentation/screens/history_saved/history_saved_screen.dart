import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../domain/entities/additive.dart';
import '../../../domain/entities/history_item.dart';
import '../../providers/additives_provider.dart';
import '../../providers/history_saved_provider.dart';
import '../../widgets/additive_card.dart';
import '../../widgets/did_you_know_card.dart';
import '../../widgets/footer_credit.dart';

class HistorySavedScreen extends ConsumerStatefulWidget {
  final int initialTab; // 0: History, 1: Saved

  const HistorySavedScreen({
    super.key,
    this.initialTab = 0,
  });

  @override
  ConsumerState<HistorySavedScreen> createState() => _HistorySavedScreenState();
}

class _HistorySavedScreenState extends ConsumerState<HistorySavedScreen> {
  late int _selectedTab; // 0: History, 1: Saved
  final TextEditingController _filterController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final historyAsync = ref.watch(historyNotifierProvider);
    final savedAsync = ref.watch(savedNotifierProvider);
    final filterStatus = ref.watch(filterStatusProvider);
    final filterQuery = ref.watch(filterQueryProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar: Title & Filter Icon
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.history_toggle_off_rounded,
                      color: AppColors.primaryTeal,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    context.tr('historySavedTitle'),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Spacer(),
                  // Filter Status Menu Button
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.tune_rounded,
                      color: filterStatus != 'all'
                          ? AppColors.primaryTeal
                          : (isDark ? Colors.white70 : AppColors.textPrimaryLight),
                    ),
                    onSelected: (val) {
                      ref.read(filterStatusProvider.notifier).state = val;
                    },
                    itemBuilder: (ctx) => [
                      PopupMenuItem(
                        value: 'all',
                        child: Text(context.tr('filterAll')),
                      ),
                      PopupMenuItem(
                        value: 'safe',
                        child: Text(context.tr('filterSafe')),
                      ),
                      PopupMenuItem(
                        value: 'caution',
                        child: Text(context.tr('filterCaution')),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Segmented Toggle: History | Saved
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : const Color(0xFFF0F4F3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSegmentButton(
                        index: 0,
                        title: context.tr('historyTab'),
                        icon: Icons.history_rounded,
                        isSelected: _selectedTab == 0,
                      ),
                    ),
                    Expanded(
                      child: _buildSegmentButton(
                        index: 1,
                        title: context.tr('savedTab'),
                        icon: Icons.bookmark_rounded,
                        isSelected: _selectedTab == 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Filter Field: "Filter by code or name..."
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppColors.softShadow,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                child: Row(
                  children: [
                    Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: AppColors.textTertiaryLight,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _filterController,
                        onChanged: (val) {
                          ref.read(filterQueryProvider.notifier).state = val;
                        },
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        ),
                        decoration: InputDecoration(
                          hintText: context.tr('filterHint'),
                          hintStyle: const TextStyle(
                            fontSize: 13.5,
                            color: AppColors.textTertiaryLight,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: false,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    if (_filterController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        color: AppColors.textTertiaryLight,
                        onPressed: () {
                          _filterController.clear();
                          ref.read(filterQueryProvider.notifier).state = '';
                        },
                      ),
                    Icon(
                      Icons.filter_list_rounded,
                      size: 20,
                      color: filterStatus != 'all' ? AppColors.primaryTeal : AppColors.textTertiaryLight,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Main List with Dismissible Swipe to Delete
            Expanded(
              child: _selectedTab == 0
                  ? _buildItemsList(historyAsync, isHistory: true, isDark: isDark)
                  : _buildItemsList(savedAsync, isHistory: false, isDark: isDark),
            ),

            // "Did you know?" tip card pinned above footer
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: DidYouKnowCard(),
            ),

            // Footer Credit
            const FooterCredit(withDecoration: false),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentButton({
    required int index,
    required String title,
    required IconData icon,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() => _selectedTab = index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryTeal : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : AppColors.textSecondaryLight,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList(
    AsyncValue<List<HistoryItem>> asyncItems, {
    required bool isHistory,
    required bool isDark,
  }) {
    final filterQuery = ref.watch(filterQueryProvider).trim().toLowerCase();
    final filterStatus = ref.watch(filterStatusProvider);

    return asyncItems.when(
      data: (items) {
        var filtered = items.where((item) {
          // Status filter
          if (filterStatus != 'all' && item.safetyStatus.toLowerCase() != filterStatus) {
            return false;
          }
          // Search query filter
          if (filterQuery.isNotEmpty) {
            final matchesCode = item.additiveCode.toLowerCase().contains(filterQuery);
            final matchesName = item.additiveName.toLowerCase().contains(filterQuery);
            if (!matchesCode && !matchesName) return false;
          }
          return true;
        }).toList();

        if (filtered.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isHistory ? Icons.history_rounded : Icons.bookmark_border_rounded,
                    size: 56,
                    color: AppColors.textTertiaryLight,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isHistory ? context.tr('emptyHistory') : context.tr('emptySaved'),
                    style: TextStyle(
                      fontSize: 15,
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final item = filtered[index];
            final timestampStr = _formatTimestamp(item.timestamp, context);

            SafetyStatus status;
            switch (item.safetyStatus.toLowerCase()) {
              case 'safe':
                status = SafetyStatus.safe;
                break;
              case 'caution':
                status = SafetyStatus.caution;
                break;
              default:
                status = SafetyStatus.notEvaluated;
            }

            return Dismissible(
              key: Key('${isHistory ? "h" : "s"}_${item.id}_${item.additiveCode}'),
              direction: DismissDirection.endToStart,
              background: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.only(right: 20),
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 26),
              ),
              onDismissed: (_) {
                if (isHistory) {
                  ref.read(historyNotifierProvider.notifier).removeItem(item.id);
                } else {
                  ref.read(savedNotifierProvider.notifier).removeSaved(item.additiveCode);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(context.tr('itemDeleted')),
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: AdditiveCard(
                code: item.additiveCode,
                name: item.additiveName,
                safetyStatus: status,
                iconType: item.iconType,
                subtitle: timestampStr,
                shortChip: true,
                onTap: () async {
                  final additive = await ref.read(additiveDetailsProvider(item.additiveCode).future);
                  if (additive != null && context.mounted) {
                    ref.read(historyNotifierProvider.notifier).recordVisit(additive);
                    context.push('/details/${additive.code}');
                  }
                },
              ),
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

  String _formatTimestamp(DateTime dt, BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final itemDay = DateTime(dt.year, dt.month, dt.day);
    final timeStr = DateFormat('HH:mm').format(dt);

    if (itemDay == today) {
      return '${context.tr("today")} • $timeStr';
    } else if (itemDay == today.subtract(const Duration(days: 1))) {
      return '${context.tr("yesterday")} • $timeStr';
    } else {
      final dateStr = DateFormat('MMM d').format(dt);
      return '$dateStr • $timeStr';
    }
  }
}
