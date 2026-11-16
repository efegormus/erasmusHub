import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/router/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../shared/widgets/app_button.dart';
import 'resend_countdown.dart';

/// Verify email (05). UI only: "I've verified" opens Home without checking,
/// real verification comes with Firebase in Step 3.
class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key, this.email});

  /// Shown in the message when sign-up passes it as `?email=`.
  final String? email;

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _countdown = ResendCountdown(const Duration(seconds: 60));

  @override
  void dispose() {
    _countdown.dispose();
    super.dispose();
  }

  void _resend() {
    if (_countdown.isRunning) return;
    _countdown.start();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Verification email sent again.')),
      );
  }

  void _back() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.email?.trim();
    final target = email == null || email.isEmpty
        ? 'your university email'
        : email;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify your email'),
        automaticallyImplyLeading: false,
        leading: BackButton(onPressed: _back),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.mark_email_unread_outlined,
                    size: 64,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Check your inbox',
                    style: AppTextStyles.heading,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'We sent a verification link to $target. Open it to '
                    'activate your ErasmusHub account, then come back here.',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    label: "I've verified my email",
                    onPressed: () => context.go(AppRoutes.home),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ValueListenableBuilder<int>(
                    valueListenable: _countdown,
                    builder: (context, _, _) => AppButton(
                      label: _countdown.isRunning
                          ? 'Resend in ${_countdown.label}'
                          : 'Resend email',
                      outlined: true,
                      onPressed: _countdown.isRunning ? null : _resend,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    "Didn't get it? Check your spam folder.",
                    style: AppTextStyles.label.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.login),
                    child: const Text('Back to login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
