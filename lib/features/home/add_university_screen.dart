import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/university_data.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/validators.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';
import '../posts/widgets/confirmation_dialog.dart';
import '../posts/widgets/form_widgets.dart';

/// Add university (screen 15): name, country and city of a missing university.
/// Reached from Home and from Sign-up step 2.
class AddUniversityScreen extends StatefulWidget {
  const AddUniversityScreen({super.key});

  @override
  State<AddUniversityScreen> createState() => _AddUniversityScreenState();
}

class _AddUniversityScreenState extends State<AddUniversityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _city = TextEditingController();
  String? _country;
  /// Blocks a second submit while the confirmation dialog is open.
  bool _saving = false;
  /// After the first submit, errors update while the user edits.
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;

  @override
  void dispose() {
    _name.dispose();
    _city.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    final error =
        Validators.required(value) ?? Validators.minLength(2)(value?.trim());
    if (error != null) return error;
    return universityNameExists(value!)
        ? 'This university is already in the list.'
        : null;
  }

  String? _validateCountry(String? value) =>
      value == null ? 'Please select a country.' : null;

  Future<void> _submit() async {
    if (_saving) return;
    if (!_formKey.currentState!.validate()) {
      setState(() => _autovalidate = AutovalidateMode.onUserInteraction);
      return;
    }
    _saving = true;
    final university = addPlaceholderUniversity(
      name: _name.text,
      city: _city.text,
      country: _country!,
    );
    await showConfirmationDialog(
      context,
      title: 'University added',
      message: '${university.name} is now in the list and can be searched.',
    );
    if (!mounted) return;
    if (context.canPop()) {
      context.pop(university);
    } else {
      context.go(AppRoutes.home);
    }
  }

  void _back() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: BackButton(onPressed: _back),
      title: const Text('Add university'),
    ),
    body: SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Form(
              key: _formKey,
              autovalidateMode: _autovalidate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Cannot find your university? Add it so others can '
                    'find it too.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppTextField(
                    label: 'University name',
                    hintText: 'e.g. Lund University',
                    controller: _name,
                    validator: _validateName,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  LabeledField(
                    label: 'Country',
                    child: DropdownButtonFormField<String>(
                      initialValue: _country,
                      isExpanded: true,
                      decoration: dropdownDecoration(context, 'Select country'),
                      validator: _validateCountry,
                      items: [
                        for (final country in kUniversityCountries)
                          DropdownMenuItem(value: country, child: Text(country)),
                      ],
                      onChanged: (value) => setState(() => _country = value),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'City',
                    hintText: 'e.g. Lund',
                    controller: _city,
                    validator: Validators.required,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(label: 'Add university', onPressed: _submit),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
