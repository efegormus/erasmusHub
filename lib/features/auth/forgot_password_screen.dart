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

/// Forgot password (02). UI only: no email is sent until Firebase (Step 3).
/// After a valid request the button is locked for three minutes.
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
    if (_countdown.isRunning || !_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _sentTo = _email.text.trim());
    _countdown.start();
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
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.lock_reset,
                      size: 56,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Reset your password',
                      style: AppTextStyles.heading,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Enter your university email and we will send you a '
                      'link to choose a new password.',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: 'University email',
                      hintText: 'name@university.edu.tr',
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.email],
                      validator: Validators.universityEmail,
                      onFieldSubmitted: (_) => _send(),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ValueListenableBuilder<int>(
                      valueListenable: _countdown,
                      builder: (context, _, _) => Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (_sentTo != null) ...[
                            _SentNotice(email: _sentTo!),
                            const SizedBox(height: AppSpacing.md),
                          ],
                          AppButton(
                            label: _countdown.isRunning
                                ? 'Resend in ${_countdown.label}'
                                : _sentTo == null
                                ? 'Send reset link'
                                : 'Resend link',
                            onPressed: _countdown.isRunning ? null : _send,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextButton(
                      onPressed: _backToLogin,
                      child: const Text('Back to login'),
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

class _SentNotice extends StatelessWidget {
  const _SentNotice({required this.email});
  final String email;

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.mark_email_read_outlined,
            color: AppColors.secondary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'If an account exists for $email, a reset link is on its way. '
              'Check your inbox and spam folder.',
              style: AppTextStyles.label,
            ),
          ),
        ],
      ),
    ),
  );
}
