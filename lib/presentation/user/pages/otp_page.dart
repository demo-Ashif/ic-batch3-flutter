import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
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
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('OTP sent to: ${widget.email}'),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _otpController,
                    decoration: const InputDecoration(labelText: '6-digit OTP'),
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    validator: (value) {
                      if (value == null || value.length != 6) {
                        return 'Enter 6-digit OTP';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed:
                          isLoading
                              ? null
                              : () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  context.read<UserCubit>().verifyOtp(
                                    email: widget.email,
                                    otp: _otpController.text.trim(),
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
