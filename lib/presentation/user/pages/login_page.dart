import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ic_batch3_flutter_classes/presentation/user/cubit/user_cubit.dart';
import 'package:ic_batch3_flutter_classes/presentation/user/cubit/user_state.dart';
import 'package:ic_batch3_flutter_classes/presentation/user/pages/otp_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<UserCubit, UserState>(
          listener: (context, state) {
            if (state.status == UserStatus.otpSent && state.email != null) {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => OtpPage(email: state.email!)),
              );
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
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'you@example.com',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      if (!value.contains('@')) {
                        return 'Enter a valid email';
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
                                  context.read<UserCubit>().requestOtp(
                                    _emailController.text.trim(),
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
                              : const Text('Send OTP'),
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
