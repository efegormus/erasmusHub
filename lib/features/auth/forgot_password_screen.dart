import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/validators.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/app_text_field.dart';
import 'resend_countdown.dart';

/// Forgot password (02), three states from wireframe pages 3-5:
/// 1. enter email, 2. link sent with a 3-minute lock, 3. resend available.
/// UI only: no email is sent until Firebase (Step 3).
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _countdown = ResendCountdown(const Duration(minutes: 3));
  String? _sentTo;

  @override
  void dispose() {
    _email.dispose();
    _countdown.dispose();
    super.dispose();
  }

  void _send() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _sentTo = _email.text.trim());
    _countdown.start();
  }

  void _resend() {
    if (_countdown.isRunning) return;
    _countdown.start();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('A new reset link was sent.')),
      );
  }

  void _backToLogin() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot password'),
        automaticallyImplyLeading: false,
        leading: BackButton(onPressed: _backToLogin),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: _sentTo == null ? _enterEmail() : _linkSent(_sentTo!),
            ),
          ),
        ),
      ),
    );
  }

  /// State 1: enter email.
  Widget _enterEmail() => Form(
    key: _formKey,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.lg),
        const Icon(Icons.lock_outline, size: 56, color: AppColors.primary),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Reset your password',
          style: AppTextStyles.heading,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Enter your university email. We will send you a link to reset '
          'your password.',
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppTextField(
          label: 'University email',
          hintText: 'name.surname@sabanciuniv.edu',
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.email],
          validator: Validators.universityEmail,
          onFieldSubmitted: (_) => _send(),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton(label: 'Send reset link', onPressed: _send),
      ],
    ),
  );

  /// States 2 and 3: link sent; resend is locked until the timer ends.
  Widget _linkSent(String email) => ValueListenableBuilder<int>(
    valueListenable: _countdown,
    builder: (context, _, _) {
      final locked = _countdown.isRunning;
      final secondary = AppTextStyles.body.copyWith(
        color: AppColors.textSecondary,
      );
      return Semantics(
        liveRegion: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSpacing.lg),
            const Icon(
              Icons.mark_email_unread_outlined,
              size: 56,
              color: AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Check your email',
              style: AppTextStyles.heading,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Reset link sent to',
              style: secondary,
              textAlign: TextAlign.center,
            ),
            Text(
              email,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              locked
                  ? 'Open the link in the email to choose a new password. '
                        'Check your spam folder too.'
                  : 'Did not get it? You can send the link again.',
              style: secondary,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Resend link',
              outlined: locked,
              onPressed: locked ? null : _resend,
            ),
            if (locked) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                'You can request a new link in',
                style: AppTextStyles.label.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                _countdown.label,
                style: AppTextStyles.title,
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: _backToLogin,
              child: const Text('Back to login'),
            ),
          ],
        ),
      );
    },
  );
}
