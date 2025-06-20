import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

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
    Future.delayed(Duration.zero, () => _checkLoggedInUser());
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
      // Facebook-like background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo / Title
              Text(
                'Insta Feed',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                  fontFamily: 'Arial',
                  letterSpacing: -1.5,
                ),
              ),
              const SizedBox(height: 40),

              // Login Card
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _login(context),

                          child: const Text('Log In'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Footer Text
              // TextButton(
              //   onPressed: () {
              //     // Optionally handle navigation
              //   },
              //   child: const Text(
              //     'Create new account',
              //     style: TextStyle(
              //       color: Color(0xFF1877F2),
              //       fontWeight: FontWeight.w600,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
