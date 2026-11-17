import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/place_data.dart';
import '../../core/data/profile_data.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/place.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';
import '../../shared/widgets/star_rating.dart';
import 'places_store.dart';

/// Add place (11): name, city, category, star rating and an optional
/// comment, with inline errors and a "Place added" dialog (wireframe page 12).
class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _comment = TextEditingController();
  String? _city;
  PlaceCategory? _category;
  int _rating = 0;

  @override
  void dispose() {
    _name.dispose();
    _comment.dispose();
    super.dispose();
  }

  static String? _validateName(String? value) =>
      value == null || value.trim().isEmpty ? 'Place name is required.' : null;

  void _close([Place? added]) {
    if (context.canPop()) {
      context.pop(added);
    } else {
      context.go(AppRoutes.places);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final place = Place(
      id: 'p${DateTime.now().microsecondsSinceEpoch}',
      name: _name.text.trim(),
      city: _city!,
      category: _category!,
      rating: _rating.toDouble(),
      addedBy: kCurrentUser.name,
      comment: _comment.text.trim(),
    );
    placesStore.add(place);
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Place added'),
        content: Text('Thanks! Your rating is now on the ${place.city} list.'),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (mounted) _close(place);
  }

  InputDecoration _dropdownDecoration(String hint) => InputDecoration(
    hintText: hint,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  );

  @override
  Widget build(BuildContext context) {
    final errorStyle = TextStyle(
      color: Theme.of(context).colorScheme.error,
      fontSize: 12,
    );
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
                    AppTextField(
                      label: 'Place name',
                      hintText: 'e.g. Dok Coffee',
                      controller: _name,
                      textInputAction: TextInputAction.next,
                      validator: _validateName,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text('City', style: AppTextStyles.label),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: _city,
                      isExpanded: true,
                      decoration: _dropdownDecoration('Select city'),
                      items: [
                        for (final city in kPlaceCities)
                          DropdownMenuItem(value: city, child: Text(city)),
                      ],
                      onChanged: (value) => setState(() => _city = value),
                      validator: (value) =>
                          value == null ? 'Choose a city.' : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text('Category', style: AppTextStyles.label),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<PlaceCategory>(
                      initialValue: _category,
                      isExpanded: true,
                      decoration: _dropdownDecoration('Café, Food, Sights…'),
                      items: [
                        for (final c in PlaceCategory.values)
                          DropdownMenuItem(value: c, child: Text(c.label)),
                      ],
                      onChanged: (value) => setState(() => _category = value),
                      validator: (value) =>
                          value == null ? 'Choose a category.' : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text('Your rating', style: AppTextStyles.label),
                    FormField<int>(
                      validator: (_) =>
                          _rating == 0 ? 'Give 1 to 5 stars.' : null,
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
                            Text(field.errorText!, style: errorStyle),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label: 'Comment (optional)',
                      hintText: 'What did you like?',
                      controller: _comment,
                      maxLines: 3,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppButton(label: 'Save place', onPressed: _save),
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
