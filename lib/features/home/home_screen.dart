import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/university_data.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/university.dart';
import '../../shared/widgets/empty_state.dart';
import 'widgets/dropdown_filter_chip.dart';
import 'widgets/university_card.dart';

/// Home (screen 06): search and filter the forum-style university list.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _search = TextEditingController();
  String? _country;
  String? _city;
  bool _topRated = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<String> get _countries =>
      placeholderUniversities.map((u) => u.country).toSet().toList()..sort();

  List<String> get _cities =>
      placeholderUniversities
          .where((u) => _country == null || u.country == _country)
          .map((u) => u.city)
          .toSet()
          .toList()
        ..sort();

  List<University> get _results {
    final results = placeholderUniversities
        .where(
          (u) =>
              u.matches(_search.text) &&
              (_country == null || u.country == _country) &&
              (_city == null || u.city == _city),
        )
        .toList();
    if (_topRated) {
      // Universities without reviews go to the end.
      double score(University u) => overallAverage(u.id) ?? -1;
      results.sort((a, b) => score(b).compareTo(score(a)));
    }
    return results;
  }

  void _selectCountry(String? country) => setState(() {
    _country = country;
    if (_city != null && !_cities.contains(_city)) _city = null;
  });

  Future<void> _openUniversity(String id) async {
    await context.push(AppRoutes.university(id));
    // Post counts and ratings may have changed (e.g. a new post).
    if (mounted) setState(() {});
  }

  Future<void> _openAddUniversity() async {
    await context.push(AppRoutes.addUniversity);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;
    final query = _search.text.trim();
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              sliver: SliverToBoxAdapter(child: _buildHeader()),
            ),
            if (results.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyState(
                  icon: Icons.search_off,
                  title: query.isEmpty
                      ? 'No universities found'
                      : 'No results for “$query”',
                  message: 'Check the spelling or add the university yourself.',
                  actionLabel: 'Add university',
                  onAction: _openAddUniversity,
                ),
              )
            else ...[
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                sliver: SliverList.separated(
                  itemCount: results.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSpacing.xs),
                  itemBuilder: (context, index) {
                    final university = results[index];
                    return UniversityCard(
                      key: ValueKey(university.id),
                      university: university,
                      onTap: () => _openUniversity(university.id),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Center(
                    child: TextButton.icon(
                      onPressed: _openAddUniversity,
                      icon: const Icon(Icons.add),
                      label: const Text(
                        "Can't find your university? Add it",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        'Find your destination',
        style: AppTextStyles.heading.copyWith(color: AppColors.textPrimary),
      ),
      const SizedBox(height: AppSpacing.md),
      TextField(
        controller: _search,
        textInputAction: TextInputAction.search,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: 'Search country, city, university',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _search.text.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Clear search',
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(_search.clear),
                ),
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
        ),
      ),
      const SizedBox(height: AppSpacing.sm),
      Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.xs,
        children: [
          DropdownFilterChip(
            label: 'Country',
            allLabel: 'All countries',
            value: _country,
            options: _countries,
            onChanged: _selectCountry,
          ),
          DropdownFilterChip(
            label: 'City',
            allLabel: 'All cities',
            value: _city,
            options: _cities,
            onChanged: (city) => setState(() => _city = city),
          ),
          FilterChip(
            label: const Text('Top rated'),
            selected: _topRated,
            onSelected: (selected) => setState(() => _topRated = selected),
          ),
        ],
      ),
    ],
  );
}
