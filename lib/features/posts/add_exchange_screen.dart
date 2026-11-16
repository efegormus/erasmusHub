import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/posts_data.dart';
import '../../core/data/profile_data.dart';
import '../../core/router/app_routes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/exchange_experience.dart';
import '../../models/user_profile.dart';
import 'widgets/confirmation_dialog.dart';
import 'widgets/form_widgets.dart';

/// What the Add exchange form hands back to Edit profile.
typedef AddExchangeResult = ({
  ExchangeExperience experience,
  ExchangeStatus status,
});

/// Add exchange form (screen 14).
///
/// Pops with an [AddExchangeResult] so Edit profile can add it to its list:
/// `final added = await context.push<AddExchangeResult>(AppRoutes.addExchange);`
class AddExchangeScreen extends StatefulWidget {
  const AddExchangeScreen({super.key});

  @override
  State<AddExchangeScreen> createState() => _AddExchangeScreenState();
}

class _AddExchangeScreenState extends State<AddExchangeScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _universityId;
  String? _term;
  ExchangeProgram _program = ExchangeProgram.erasmus;
  ExchangeStatus? _status;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final university = hostUniversityById(_universityId)!;
    final status = _status!;
    final result = (
      experience: ExchangeExperience(
        id: 'exp${DateTime.now().microsecondsSinceEpoch}',
        hostUniversity: university.name,
        city: university.city,
        country: university.country,
        program: _program,
        term: _term!,
        department: kCurrentUser.department,
      ),
      status: status,
    );
    await showConfirmationDialog(
      context,
      title: 'Exchange added',
      message:
          '${university.name} was added to your Erasmus+/Exchange experiences.',
    );
    if (!mounted) return;
    if (context.canPop()) {
      context.pop(result);
    } else {
      context.go(AppRoutes.editProfile);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Add exchange')),
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
                    'Add every exchange you have done or plan to do.',
                    style: AppTextStyles.label,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  LabeledField(
                    label: 'Host university',
                    child: DropdownButtonFormField<String>(
                      initialValue: _universityId,
                      isExpanded: true,
                      decoration: dropdownDecoration(
                        context,
                        'Select university',
                      ),
                      items: [
                        for (final university in kHostUniversities)
                          DropdownMenuItem(
                            value: university.id,
                            child: Text(
                              university.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      onChanged: (value) => _universityId = value,
                      validator: (value) =>
                          value == null ? 'Please select a university.' : null,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  LabeledField(
                    label: 'Program',
                    child: SegmentedButton<ExchangeProgram>(
                      segments: [
                        for (final program in ExchangeProgram.values)
                          ButtonSegment(
                            value: program,
                            label: Text(program.label),
                          ),
                      ],
                      selected: {_program},
                      onSelectionChanged: (selection) =>
                          setState(() => _program = selection.first),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  LabeledField(
                    label: 'Term',
                    child: DropdownButtonFormField<String>(
                      initialValue: _term,
                      isExpanded: true,
                      decoration: dropdownDecoration(
                        context,
                        'e.g. Spring 2025',
                      ),
                      items: [
                        for (final term in kTerms)
                          DropdownMenuItem(value: term, child: Text(term)),
                      ],
                      onChanged: (value) => _term = value,
                      validator: (value) =>
                          value == null ? 'Please select a term.' : null,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FormField<ExchangeStatus>(
                    validator: (value) =>
                        value == null ? 'Choose Going or Returned.' : null,
                    builder: (field) => LabeledField(
                      label: 'Status',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SegmentedButton<ExchangeStatus>(
                            emptySelectionAllowed: true,
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
                            selected: {?field.value},
                            onSelectionChanged: (selection) {
                              final value = selection.isEmpty
                                  ? null
                                  : selection.first;
                              _status = value;
                              field.didChange(value);
                            },
                          ),
                          if (field.hasError) FieldError(field.errorText!),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton(
                    onPressed: _save,
                    child: const Text('Save exchange'),
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
