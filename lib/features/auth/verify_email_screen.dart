import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/app_button.dart';
import 'resend_countdown.dart';

/// Verify email (05), two states from wireframe page 6.
/// Waiting: the link was just sent and Resend is locked for 3 minutes.
/// Not verified: shown when "I verified my email" is tapped before
/// verifying; Resend becomes available.
/// UI only until Firebase (Step 3): the first tap shows "not verified",
/// the second tap opens Home, so both states can be demonstrated.
class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key, this.email});

  /// Shown in the message when sign-up passes it as `?email=`.
  final String? email;

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _countdown = ResendCountdown(const Duration(minutes: 3));
  bool _notVerified = false;

  @override
  void initState() {
    super.initState();
    // The link was sent when the account was created.
    _countdown.start();
  }

  @override
  void dispose() {
    _countdown.dispose();
    super.dispose();
  }

  void _verified() {
    if (!_notVerified) {
      setState(() => _notVerified = true);
      _countdown.stop();
      return;
    }
    context.go(AppRoutes.home);
  }

  void _resend() {
    if (_countdown.isRunning) return;
    setState(() => _notVerified = false);
    _countdown.start();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('A new verification link was sent.')),
      );
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.email?.trim();
    final hasEmail = email != null && email.isNotEmpty;
    final secondary = AppTextStyles.body.copyWith(
      color: AppColors.textSecondary,
    );
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: ValueListenableBuilder<int>(
                valueListenable: _countdown,
                builder: (context, _, _) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSpacing.xl),
                    const Icon(
                      Icons.mark_email_unread_outlined,
                      size: 64,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Verify your email',
                      style: AppTextStyles.heading,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    if (_notVerified) ...[
                      Text(
                        'Your email is not verified yet. Please open the '
                        'link we sent.',
                        style: AppTextStyles.body.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Check your spam folder too.',
                        style: secondary,
                        textAlign: TextAlign.center,
                      ),
                    ] else ...[
                      Text(
                        'Verification link sent to',
                        style: secondary,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        hasEmail ? email : 'your university email',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Open the link in the email, then come back and tap '
                        'the button below.',
                        style: secondary,
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xl),
                    AppButton(
                      label: 'I verified my email',
                      onPressed: _verified,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                      label: 'Resend link',
                      outlined: true,
                      onPressed: _countdown.isRunning ? null : _resend,
                    ),
                    if (_countdown.isRunning) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'You can request a new link in ${_countdown.label}',
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.sm),
                    TextButton(
                      onPressed: () => context.go(AppRoutes.signUpAccount),
                      child: const Text('Change email'),
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
