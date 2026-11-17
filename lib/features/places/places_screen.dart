import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/place.dart';
import 'place_card.dart';
import 'places_store.dart';

/// Places (10): student recommendations, filtered by category.
class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  /// null means "All".
  PlaceCategory? _category;

  void _remove(Place place) {
    final index = placesStore.remove(place);
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${place.name} removed'),
          persist: false,
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () => placesStore.insert(index, place),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Places')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.addPlace),
        icon: const Icon(Icons.add_location_alt_outlined),
        label: const Text('Add place'),
      ),
      body: SafeArea(
        child: ValueListenableBuilder<List<Place>>(
          valueListenable: placesStore,
          builder: (context, places, _) {
            final visible = _category == null
                ? places
                : places.where((p) => p.category == _category).toList();
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _filters()),
                if (visible.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyState(filtered: _category != null),
                  )
                else
                  SliverPadding(
                    // Bottom space keeps the last card clear of the button.
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      0,
                      AppSpacing.md,
                      96,
                    ),
                    sliver: SliverList.separated(
                      itemCount: visible.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, i) => Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 560),
                          child: PlaceCard(
                            key: ValueKey(visible[i].id),
                            place: visible[i],
                            onRemove: () => _remove(visible[i]),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _filters() {
    Widget chip(String label, PlaceCategory? value) => Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: ChoiceChip(
        label: Text(label),
        selected: _category == value,
        onSelected: (_) => setState(() => _category = value),
      ),
    );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          chip('All', null),
          for (final c in PlaceCategory.values) chip(c.label, c),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.filtered});
  final bool filtered;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppSpacing.lg),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.place_outlined,
          size: 48,
          color: AppColors.textSecondary,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          filtered ? 'No places in this category yet.' : 'No places yet.',
          style: AppTextStyles.body,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Add the first one with the button below.',
          style: AppTextStyles.label.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
