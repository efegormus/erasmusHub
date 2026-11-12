import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/validators.dart';
import '../../models/user_profile.dart';

/// Temporary list until the shared university data is on `main`.
const _universities = [
  'Sabancı University',
  'Boğaziçi University',
  'Koç University',
  'Middle East Technical University',
  'Istanbul Technical University',
  'Bilkent University',
];

/// Sign up, step 2 of 2: profile. UI only.
class SignUpProfileScreen extends StatefulWidget {
  const SignUpProfileScreen({super.key});

  @override
  State<SignUpProfileScreen> createState() => _SignUpProfileScreenState();
}

class _SignUpProfileScreenState extends State<SignUpProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _major = TextEditingController();
  final _minor = TextEditingController();
  ExchangeStatus _status = ExchangeStatus.planning;

  @override
  void dispose() {
    _name.dispose();
    _major.dispose();
    _minor.dispose();
    super.dispose();
  }

  String? _validateUniversity(String? value) {
    final requiredError = Validators.required(value);
    if (requiredError != null) return requiredError;
    return _universities.contains(value) ? null : 'Pick a university from the list.';
  }

  void _createAccount() {
    if (_formKey.currentState!.validate()) {
      context.go('/verify-email');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your profile')),
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
                      'Step 2 of 2 · Profile',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: _name,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(labelText: 'Full name'),
                      validator: Validators.required,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Autocomplete<String>(
                      optionsBuilder: (value) {
                        final query = value.text.trim().toLowerCase();
                        if (query.isEmpty) return const Iterable<String>.empty();
                        return _universities.where(
                          (u) => u.toLowerCase().contains(query),
                        );
                      },
                      fieldViewBuilder:
                          (context, controller, focusNode, onFieldSubmitted) {
                        return TextFormField(
                          controller: controller,
                          focusNode: focusNode,
                          decoration: const InputDecoration(
                            labelText: 'Home university',
                            hintText: 'Search your university',
                            suffixIcon: Icon(Icons.arrow_drop_down),
                          ),
                          validator: _validateUniversity,
                          onFieldSubmitted: (_) => onFieldSubmitted(),
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () => context.push('/add-university'),
                        child: const Text('+ University not listed? Add it'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _major,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Major',
                        hintText: 'e.g. Computer Science',
                      ),
                      validator: Validators.required,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _minor,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        labelText: 'Double major / minor (optional)',
                        hintText: 'e.g. Economics',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text('Status', style: AppTextStyles.label),
                    const SizedBox(height: AppSpacing.sm),
                    SegmentedButton<ExchangeStatus>(
                      segments: const [
                        ButtonSegment(
                          value: ExchangeStatus.planning,
                          label: Text('Going'),
                        ),
                        ButtonSegment(
                          value: ExchangeStatus.returned,
                          label: Text('Returned'),
                        ),
                      ],
                      selected: {_status},
                      onSelectionChanged: (selection) =>
                          setState(() => _status = selection.first),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    FormField<bool>(
                      initialValue: false,
                      validator: (accepted) => accepted == true
                          ? null
                          : 'You must accept to create an account.',
                      builder: (field) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CheckboxListTile(
                              value: field.value ?? false,
                              onChanged: field.didChange,
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                'I agree to the processing of my data under '
                                'KVKK and the privacy notice.',
                                style: AppTextStyles.label,
                              ),
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
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    FilledButton(
                      onPressed: _createAccount,
                      child: const Text('Create account'),
                    ),
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
