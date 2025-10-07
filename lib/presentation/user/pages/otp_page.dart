import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:ic_batch3_flutter_classes/presentation/user/cubit/user_cubit.dart';
import 'package:ic_batch3_flutter_classes/presentation/user/cubit/user_state.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key, required this.email});

  final String email;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final pinTheme = PinTheme(
      width: 50,
      height: 56,
      textStyle: theme.textTheme.titleLarge,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<UserCubit, UserState>(
          listener: (context, state) {
            if (state.status == UserStatus.authenticated) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
            if (state.status == UserStatus.error && state.message != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message!)));
            }
          },
          builder: (context, state) {
            final isLoading = state.status == UserStatus.authenticating;
            return Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(
                                    'assets/images/crafty-bay-logo.png',
                                    height: 64,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (_, __, ___) =>
                                            const SizedBox(height: 64),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Verify Code',
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'We sent a 6-digit code to ${widget.email}',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Center(
                              child: Pinput(
                                length: 6,
                                controller: _otpController,
                                defaultPinTheme: pinTheme,
                                focusedPinTheme: pinTheme.copyWith(
                                  decoration: pinTheme.decoration?.copyWith(
                                    border: Border.all(
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ),
                                submittedPinTheme: pinTheme.copyWith(
                                  decoration: pinTheme.decoration?.copyWith(
                                    color: colorScheme.primaryContainer,
                                    border: Border.all(
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.length != 6) {
                                    return '';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 48,
                              child: FilledButton(
                                onPressed:
                                    isLoading
                                        ? null
                                        : () {
                                          if ((_formKey.currentState
                                                      ?.validate() ??
                                                  false) &&
                                              _otpController.text.length == 6) {
                                            context.read<UserCubit>().verifyOtp(
                                              email: widget.email,
                                              otp: _otpController.text,
                                            );
                                          }
                                        },
                                child:
                                    isLoading
                                        ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                        : const Text('Verify'),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Didn\'t receive the code? Check spam or try again.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
