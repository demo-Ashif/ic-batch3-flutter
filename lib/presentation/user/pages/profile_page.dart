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
          final theme = Theme.of(context);
          final colorScheme = theme.colorScheme;
          return Scaffold(
            appBar: AppBar(title: const Text('Profile')),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: colorScheme.primaryContainer,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(36),
                            child: Image.asset(
                              'assets/images/crafty-bay-logo.png',
                              fit: BoxFit.contain,
                              height: 48,
                              errorBuilder:
                                  (_, __, ___) => Icon(
                                    Icons.person,
                                    color: colorScheme.onPrimaryContainer,
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          p.customerName.isEmpty ? 'User' : p.customerName,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(p.email, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Contact',
                  children: [
                    _kv('Phone', p.customerPhone),
                    _kv('Fax', p.customerFax),
                  ],
                ),
                const SizedBox(height: 16),
                _SectionCard(
                  title: 'Billing Address',
                  children: [
                    _kv('Address', p.customerAddress),
                    _kv('City', p.customerCity),
                    _kv('State', p.customerState),
                    _kv('Postcode', p.customerPostcode),
                    _kv('Country', p.customerCountry),
                  ],
                ),
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

  Widget _kv(String k, String v) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(k, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(v.isEmpty ? '-' : v),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
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
