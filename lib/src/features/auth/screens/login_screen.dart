import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0), () {
      _checkLoggedInUser();
    });
  }

  Future<void> _checkLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    if (username != null && username.isNotEmpty) {
      context.read<AuthBloc>().add(AuthLogin(username));
      Navigator.pushReplacementNamed(context, '/feed');
    }
  }

  void _login(BuildContext context) async {
    final username = _controller.text.trim();
    if (username.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
      context.read<AuthBloc>().add(AuthLogin(username));
      Navigator.pushReplacementNamed(context, '/feed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Center(
        child: Card(
          elevation: 8,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.person, size: 72, color: theme.primaryColor),
                const SizedBox(height: 16),
                Text(
                  'Welcome Back!',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Enter Username',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.login),
                    onPressed: () => _login(context),
                    label: const Text('Login'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
