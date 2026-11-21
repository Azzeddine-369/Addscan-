import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../domain/entities/additive.dart';
import '../../providers/additives_provider.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/source_illustration.dart';
import '../../widgets/status_chip.dart';

class CompareScreen extends ConsumerStatefulWidget {
  final String? initialCode;

  const CompareScreen({super.key, this.initialCode});

  @override
  ConsumerState<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends ConsumerState<CompareScreen> {
  String _code1 = 'E330';
  String _code2 = 'E621';

  @override
  void initState() {
    super.initState();
    if (widget.initialCode != null && widget.initialCode!.isNotEmpty) {
      _code1 = widget.initialCode!;
      _code2 = _code1.toUpperCase() == 'E330' ? 'E621' : 'E330';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final additive1Async = ref.watch(additiveDetailsProvider(_code1));
    final additive2Async = ref.watch(additiveDetailsProvider(_code2));
    final langCode = ref.watch(settingsNotifierProvider).locale.languageCode;

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
          context.tr('compareTitle'),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
        centerTitle: true,
      ),
      body: additive1Async.when(
        data: (add1) {
          return additive2Async.when(
            data: (add2) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    // Top Additive Selectors & Hero Headers
                    Row(
                      children: [
                        Expanded(
                          child: _buildAdditiveHeader(
                            context,
                            add1,
                            onPick: () => _pickAdditive(1),
                            isDark: isDark,
                            langCode: langCode,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildAdditiveHeader(
                            context,
                            add2,
                            onPick: () => _pickAdditive(2),
                            isDark: isDark,
                            langCode: langCode,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Side-by-Side Comparison Rows
                    _buildCompareRow(
                      title: 'Safety Assessment',
                      child1: add1 != null
                          ? StatusChip(status: add1.safetyStatus, short: true)
                          : const Text('-'),
                      child2: add2 != null
                          ? StatusChip(status: add2.safetyStatus, short: true)
                          : const Text('-'),
                      isDark: isDark,
                    ),

                    _buildCompareRow(
                      title: 'Functional Category',
                      child1: Text(
                        add1?.category ?? 'Not specified',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      child2: Text(
                        add2?.category ?? 'Not specified',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      isDark: isDark,
                    ),

                    _buildCompareRow(
                      title: 'Dietary (Vegan / Veg)',
                      child1: Text(
                        add1?.vegan == true ? 'Vegan Friendly' : (add1?.vegan == false ? 'Non-Vegan' : 'Not Evaluated'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12.5),
                      ),
                      child2: Text(
                        add2?.vegan == true ? 'Vegan Friendly' : (add2?.vegan == false ? 'Non-Vegan' : 'Not Evaluated'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12.5),
                      ),
                      isDark: isDark,
                    ),

                    _buildCompareRow(
                      title: 'Origin & Production',
                      child1: Text(
                        add1?.origin ?? 'Derived per taxonomy specs',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                      child2: Text(
                        add2?.origin ?? 'Derived per taxonomy specs',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                      isDark: isDark,
                    ),

                    _buildCompareRow(
                      title: 'Common Uses',
                      child1: Text(
                        add1?.commonFoods ?? 'General food preservation & preparation',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                      child2: Text(
                        add2?.commonFoods ?? 'General food preservation & preparation',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                      ),
                      isDark: isDark,
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal)),
            error: (e, _) => Center(child: Text('Error: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryTeal)),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildAdditiveHeader(
    BuildContext context,
    Additive? additive, {
    required VoidCallback onPick,
    required bool isDark,
    required String langCode,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        children: [
          SourceIllustration(
            iconType: additive?.iconType ?? 'flask',
            size: 60,
          ),
          const SizedBox(height: 8),
          Text(
            additive?.code ?? '-',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 2),
          Text(
            additive?.getLocalizedName(langCode) ?? '-',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: onPick,
            child: const Text('Change', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildCompareRow({
    required String title,
    required Widget child1,
    required Widget child2,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: AppColors.primaryTeal,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Center(child: child1)),
              Container(
                width: 1,
                height: 35,
                color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
              ),
              Expanded(child: Center(child: child2)),
            ],
          ),
        ],
      ),
    );
  }

  void _pickAdditive(int slot) async {
    final all = await ref.read(allAdditivesProvider.future);
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Text(
                'Select Additive to Compare',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: all.length,
                  itemBuilder: (c, i) {
                    final item = all[i];
                    return ListTile(
                      leading: SourceIllustration(iconType: item.iconType, size: 28),
                      title: Text('${item.code} - ${item.name}', style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text(item.category ?? ''),
                      onTap: () {
                        setState(() {
                          if (slot == 1) {
                            _code1 = item.code;
                          } else {
                            _code2 = item.code;
                          }
                        });
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
