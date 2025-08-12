import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Form State
class FormState extends Equatable {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  const FormState({
    this.name = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  FormState copyWith({
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return FormState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }

  bool get isValid {
    return name.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password == confirmPassword;
  }

  String? get nameError {
    if (name.isEmpty) return 'Name is required';
    if (name.length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  String? get emailError {
    if (email.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? get passwordError {
    if (password.isEmpty) return 'Password is required';
    if (password.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? get confirmPasswordError {
    if (confirmPassword.isEmpty) return 'Please confirm your password';
    if (password != confirmPassword) return 'Passwords do not match';
    return null;
  }

  @override
  List<Object?> get props => [
    name,
    email,
    password,
    confirmPassword,
    isSubmitting,
    isSuccess,
    errorMessage,
  ];
}

// Form Cubit
class FormCubit extends Cubit<FormState> {
  FormCubit() : super(const FormState());

  void updateName(String name) {
    emit(state.copyWith(name: name, errorMessage: null));
  }

  void updateEmail(String email) {
    emit(state.copyWith(email: email, errorMessage: null));
  }

  void updatePassword(String password) {
    emit(state.copyWith(password: password, errorMessage: null));
  }

  void updateConfirmPassword(String confirmPassword) {
    emit(state.copyWith(confirmPassword: confirmPassword, errorMessage: null));
  }

  void submitForm() async {
    if (!state.isValid) {
      emit(state.copyWith(errorMessage: 'Please fix the errors above'));
      return;
    }

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Simulate success
      emit(state.copyWith(isSubmitting: false, isSuccess: true));

      // Reset form after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        resetForm();
      });
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'An error occurred. Please try again.',
        ),
      );
    }
  }

  void resetForm() {
    emit(const FormState());
  }
}

class FormHandlingScreen extends StatelessWidget {
  const FormHandlingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('05. Form Handling with Cubit'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocProvider(
        create: (context) => FormCubit(),
        child: BlocBuilder<FormCubit, FormState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'User Registration Form',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Success Message
                  if (state.isSuccess)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            'Registration successful!',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (state.isSuccess) const SizedBox(height: 16),

                  // Error Message
                  if (state.errorMessage != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              state.errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (state.errorMessage != null) const SizedBox(height: 16),

                  // Form Fields
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Name Field
                          _buildTextField(
                            label: 'Full Name',
                            value: state.name,
                            onChanged: (value) {
                              context.read<FormCubit>().updateName(value);
                            },
                            errorText: state.nameError,
                            icon: Icons.person,
                          ),

                          const SizedBox(height: 16),

                          // Email Field
                          _buildTextField(
                            label: 'Email',
                            value: state.email,
                            onChanged: (value) {
                              context.read<FormCubit>().updateEmail(value);
                            },
                            errorText: state.emailError,
                            icon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: 16),

                          // Password Field
                          _buildTextField(
                            label: 'Password',
                            value: state.password,
                            onChanged: (value) {
                              context.read<FormCubit>().updatePassword(value);
                            },
                            errorText: state.passwordError,
                            icon: Icons.lock,
                            isPassword: true,
                          ),

                          const SizedBox(height: 16),

                          // Confirm Password Field
                          _buildTextField(
                            label: 'Confirm Password',
                            value: state.confirmPassword,
                            onChanged: (value) {
                              context.read<FormCubit>().updateConfirmPassword(
                                value,
                              );
                            },
                            errorText: state.confirmPasswordError,
                            icon: Icons.lock_outline,
                            isPassword: true,
                          ),

                          const SizedBox(height: 24),

                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed:
                                  state.isSubmitting || !state.isValid
                                      ? null
                                      : () {
                                        context.read<FormCubit>().submitForm();
                                      },
                              child:
                                  state.isSubmitting
                                      ? const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Text('Submitting...'),
                                        ],
                                      )
                                      : const Text('Submit'),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Reset Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: OutlinedButton(
                              onPressed: () {
                                context.read<FormCubit>().resetForm();
                              },
                              child: const Text('Reset Form'),
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildTextField({
    required String label,
    required String value,
    required Function(String) onChanged,
    String? errorText,
    required IconData icon,
    TextInputType? keyboardType,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon),
            border: const OutlineInputBorder(),
            errorText: errorText,
          ),
          onChanged: onChanged,
          keyboardType: keyboardType,
          obscureText: isPassword,
        ),
      ],
    );
  }
}
