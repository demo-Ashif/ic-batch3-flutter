import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ic_batch3_flutter_classes/presentation/user/cubit/user_cubit.dart';
import 'package:ic_batch3_flutter_classes/presentation/user/cubit/user_state.dart';
import 'package:ic_batch3_flutter_classes/presentation/user/pages/login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state.status == UserStatus.unauthenticated ||
            state.status == UserStatus.unknown) {
          return _LoginPrompt();
        }
        if (state.status == UserStatus.authenticated && state.profile != null) {
          final p = state.profile!;
          return Scaffold(
            appBar: AppBar(title: const Text('Profile')),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _tile('Name', p.customerName),
                _tile('Email', p.email),
                _tile('Phone', p.customerPhone),
                const Divider(),
                _tile('Address', p.customerAddress),
                _tile('City', p.customerCity),
                _tile('State', p.customerState),
                _tile('Postcode', p.customerPostcode),
                _tile('Country', p.customerCountry),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => context.read<UserCubit>().logout(),
                  child: const Text('Logout'),
                ),
              ],
            ),
          );
        }

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget _tile(String title, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(value.isEmpty ? '-' : value),
    );
  }
}

class _LoginPrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.person_outline, size: 72),
              const SizedBox(height: 12),
              const Text('You are not logged in'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const LoginPage()));
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
