import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/validators.dart';
import '../../models/exchange_experience.dart';
import '../../models/user_profile.dart';
import 'profile_store.dart';
import '../posts/add_exchange_screen.dart';
import 'widgets/experience_card.dart';

/// Profile (edit mode): details form, experience cards with remove, contacts.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _major;
  late final TextEditingController _minor;
  late final TextEditingController _instagram;
  late final TextEditingController _linkedin;
  late final TextEditingController _phone;
  late ExchangeStatus _status;

  @override
  void initState() {
    super.initState();
    final p = profileStore.value;
    _name = TextEditingController(text: p.name);
    _major = TextEditingController(text: p.major);
    _minor = TextEditingController(text: p.minor);
    _instagram = TextEditingController(text: p.instagram);
    _linkedin = TextEditingController(text: p.linkedin);
    _phone = TextEditingController(text: p.phone);
    _status = p.status;
  }

  @override
  void dispose() {
    _name.dispose();
    _major.dispose();
    _minor.dispose();
    _instagram.dispose();
    _linkedin.dispose();
    _phone.dispose();
    super.dispose();
  }

  String? _validatePhone(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    return RegExp(r'^[+0-9 ()-]{7,}$').hasMatch(text)
        ? null
        : 'Enter a valid phone number.';
  }

  void _removeExperience(ExchangeExperience experience) {
    final index = profileStore.value.experiences.indexOf(experience);
    profileStore.removeExperience(experience.id);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          persist: false,
          duration: const Duration(seconds: 7),
          content: Text('${experience.hostUniversity} removed'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () => profileStore.restoreExperience(index, experience),
          ),
        ),
      );
  }

  Future<void> _openExchange([ExchangeExperience? existing]) async {
    final result = await context.push<AddExchangeResult>(
      AppRoutes.addExchange,
      extra: existing,
    );
    if (!mounted || result == null) return;
    final experience = result.experience.copyWith(status: result.status);
    if (existing == null) {
      profileStore.addExperience(experience);
    } else {
      profileStore.update(
        profileStore.value.copyWith(
          experiences: [
            for (final item in profileStore.value.experiences)
              if (item.id == existing.id) experience else item,
          ],
        ),
      );
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    profileStore.update(
      profileStore.value.copyWith(
        name: _name.text.trim(),
        major: _major.text.trim(),
        minor: _minor.text.trim(),
        status: _status,
        instagram: _instagram.text.trim(),
        linkedin: _linkedin.text.trim(),
        phone: _phone.text.trim(),
      ),
    );
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profile updated'),
        content: const Text('Your changes were saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.profile);
    }
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete your account?'),
        content: const Text(
          'Your profile and personal data will be removed permanently. '
          'This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit profile')),
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
                    TextFormField(
                      controller: _name,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(labelText: 'Full name'),
                      validator: Validators.required,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _major,
                      decoration: const InputDecoration(labelText: 'Major'),
                      validator: Validators.required,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _minor,
                      decoration: const InputDecoration(
                        labelText: 'Double major / minor (optional)',
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
                      onSelectionChanged: (s) =>
                          setState(() => _status = s.first),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Erasmus+/Exchange Experiences',
                      style: AppTextStyles.title,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ValueListenableBuilder<UserProfile>(
                      valueListenable: profileStore,
                      builder: (context, profile, _) {
                        if (profile.experiences.isEmpty) {
                          return Text(
                            'No experiences yet.',
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          );
                        }
                        return Column(
                          children: [
                            for (final experience in profile.experiences)
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.sm,
                                ),
                                child: ExperienceCard(
                                  experience: experience,
                                  onEdit: () => _openExchange(experience),
                                  onDelete: () => _removeExperience(experience),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () => _openExchange(),
                        icon: const Icon(Icons.add),
                        label: const Text('Add exchange'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Contact links (optional)',
                      style: AppTextStyles.title,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _instagram,
                      decoration: const InputDecoration(
                        labelText: 'Instagram',
                        hintText: '@username',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _linkedin,
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(
                        labelText: 'LinkedIn URL',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _phone,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone number',
                      ),
                      validator: _validatePhone,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    FilledButton(
                      onPressed: _save,
                      child: const Text('Save changes'),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextButton(
                      onPressed: _deleteAccount,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.error,
                      ),
                      child: const Text('Delete account'),
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
