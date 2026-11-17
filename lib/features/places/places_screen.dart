import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/place_data.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/place.dart';
import 'place_card.dart';
import 'places_store.dart';

/// Places (10): places rated by students in the selected city, filtered by
/// category (wireframe page 11).
class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  String _city = kPlaceCities.first;

  /// null means "All".
  PlaceCategory? _category;

  void _remove(Place place) {
    final index = placesStore.remove(place);
    ScaffoldMessenger.of(context)
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

  Future<void> _addPlace() async {
    final added = await context.push<Place>(AppRoutes.addPlace);
    // Show the list the new place was added to.
    if (added != null && mounted) {
      setState(() {
        _city = added.city;
        _category = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Place>>(
      valueListenable: placesStore,
      builder: (context, places, _) {
        final visible = places
            .where(
              (p) =>
                  p.city == _city &&
                  (_category == null || p.category == _category),
            )
            .toList();
        return Scaffold(
          appBar: AppBar(title: const Text('Places')),
          floatingActionButton: visible.isEmpty
              ? null
              : FloatingActionButton.extended(
                  onPressed: _addPlace,
                  icon: const Icon(Icons.add),
                  label: const Text('Add place'),
                ),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _filters()),
                if (visible.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyState(
                      city: _city,
                      category: _category,
                      onAdd: _addPlace,
                    ),
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
            ),
          ),
        );
      },
    );
  }

  Widget _filters() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            key: ValueKey(_city),
            initialValue: _city,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: 'City',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: [
              for (final city in kPlaceCities)
                DropdownMenuItem(value: city, child: Text(city)),
            ],
            onChanged: (city) {
              if (city != null) setState(() => _city = city);
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: [
              _chip('All', null),
              for (final c in PlaceCategory.values) _chip(c.label, c),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, PlaceCategory? value) => ChoiceChip(
    label: Text(label),
    selected: _category == value,
    showCheckmark: false,
    onSelected: (_) => setState(() => _category = value),
  );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.city,
    required this.category,
    required this.onAdd,
  });
  final String city;
  final PlaceCategory? category;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppSpacing.lg),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.place, size: 48, color: AppColors.error),
        const SizedBox(height: AppSpacing.sm),
        Text(
          category == null
              ? 'No places rated in $city yet.'
              : 'No ${category!.label} places rated in $city yet.',
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add),
          label: const Text('Add place'),
        ),
      ],
    ),
  );
}
