import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/validators.dart';

/// Sign up, step 1 of 2: account (email, password, confirmation). UI only.
class SignUpAccountScreen extends StatefulWidget {
  const SignUpAccountScreen({super.key});

  @override
  State<SignUpAccountScreen> createState() => _SignUpAccountScreenState();
}

class _SignUpAccountScreenState extends State<SignUpAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _hidePassword = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  String? _validateConfirm(String? value) {
    final requiredError = Validators.required(value);
    if (requiredError != null) return requiredError;
    return value == _password.text ? null : 'Passwords do not match.';
  }

  void _continue() {
    if (_formKey.currentState!.validate()) {
      context.push('/sign-up/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign up')),
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
                      'Step 1 of 2 · Account',
                      style: AppTextStyles.label.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      decoration: const InputDecoration(
                        labelText: 'University email',
                        hintText: 'name.surname@sabanciuniv.edu',
                      ),
                      validator: Validators.universityEmail,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _password,
                      obscureText: _hidePassword,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'At least 8 characters',
                        helperText: 'Use 8 or more characters.',
                        suffixIcon: IconButton(
                          tooltip: _hidePassword
                              ? 'Show password'
                              : 'Hide password',
                          icon: Icon(
                            _hidePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () =>
                              setState(() => _hidePassword = !_hidePassword),
                        ),
                      ),
                      validator: Validators.minLength(8),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _confirm,
                      obscureText: _hideConfirm,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _continue(),
                      decoration: InputDecoration(
                        labelText: 'Confirm password',
                        hintText: 'Repeat password',
                        suffixIcon: IconButton(
                          tooltip: _hideConfirm
                              ? 'Show password'
                              : 'Hide password',
                          icon: Icon(
                            _hideConfirm
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () =>
                              setState(() => _hideConfirm = !_hideConfirm),
                        ),
                      ),
                      validator: _validateConfirm,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    FilledButton(
                      onPressed: _continue,
                      child: const Text('Continue'),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: const Text('Already have an account? Log in'),
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
