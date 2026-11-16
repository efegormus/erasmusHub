import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/profile_data.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/validators.dart';
import '../../models/place.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/star_rating.dart';
import 'places_store.dart';

/// Add place (11): form with inline validation and a confirmation dialog.
class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _city = TextEditingController();
  final _country = TextEditingController();
  final _description = TextEditingController();
  final _imageUrl = TextEditingController();
  PlaceCategory? _category;
  int _rating = 0;

  @override
  void dispose() {
    _name.dispose();
    _city.dispose();
    _country.dispose();
    _description.dispose();
    _imageUrl.dispose();
    super.dispose();
  }

  static String? _validateDescription(String? value) =>
      Validators.required(value) ?? Validators.minLength(10)(value?.trim());

  static String? _validateImageUrl(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    final uri = Uri.tryParse(text);
    final ok =
        uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
    return ok ? null : 'Enter a link starting with http:// or https://';
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.places);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final place = Place(
      id: 'p${DateTime.now().microsecondsSinceEpoch}',
      name: _name.text.trim(),
      city: _city.text.trim(),
      country: _country.text.trim(),
      category: _category!,
      description: _description.text.trim(),
      rating: _rating.toDouble(),
      addedBy: kCurrentUser.name,
      imageUrl: _imageUrl.text.trim().isEmpty ? null : _imageUrl.text.trim(),
    );
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add this place?'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(place.name, style: AppTextStyles.title),
              Text(
                '${place.category.label} · ${place.city}, ${place.country}',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              StarRating(value: place.rating, size: 18),
              const SizedBox(height: AppSpacing.sm),
              const Text('Other students will see it on the Places screen.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Add place'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    placesStore.add(place);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('${place.name} added')));
    _close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add place'),
        automaticallyImplyLeading: false,
        leading: BackButton(onPressed: _close),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Recommend a place to students going to the same city.',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: 'Place name',
                      hintText: 'e.g. Café Linné',
                      controller: _name,
                      textInputAction: TextInputAction.next,
                      validator: Validators.required,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text('Category', style: AppTextStyles.label),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<PlaceCategory>(
                      initialValue: _category,
                      isExpanded: true,
                      hint: const Text('Choose a category'),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: [
                        for (final c in PlaceCategory.values)
                          DropdownMenuItem(value: c, child: Text(c.label)),
                      ],
                      onChanged: (value) => setState(() => _category = value),
                      validator: (value) =>
                          value == null ? 'Choose a category.' : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label: 'City',
                      hintText: 'e.g. Uppsala',
                      controller: _city,
                      textInputAction: TextInputAction.next,
                      validator: Validators.required,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label: 'Country',
                      hintText: 'e.g. Sweden',
                      controller: _country,
                      textInputAction: TextInputAction.next,
                      validator: Validators.required,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text('Your rating', style: AppTextStyles.label),
                    FormField<int>(
                      validator: (_) =>
                          _rating == 0 ? 'Give the place 1 to 5 stars.' : null,
                      builder: (field) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StarRating(
                            value: _rating.toDouble(),
                            size: 28,
                            onChanged: (value) {
                              setState(() => _rating = value);
                              field.didChange(value);
                            },
                          ),
                          if (field.hasError)
                            Text(
                              field.errorText!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label: 'Why do you recommend it?',
                      hintText: 'Prices, opening hours, tips…',
                      controller: _description,
                      maxLines: 4,
                      validator: _validateDescription,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label: 'Photo link (optional)',
                      hintText: 'https://…',
                      controller: _imageUrl,
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      validator: _validateImageUrl,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppButton(label: 'Add place', onPressed: _submit),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
