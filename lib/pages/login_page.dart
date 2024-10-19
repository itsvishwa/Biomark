import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:biomark/pages/profile_page.dart';
import 'package:biomark/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  String? _emailError;
  String? _passwordError;

  final RegExp _emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  void _login() async {
    setState(() {
      _emailError = _validateEmail(_emailController.text);
      _passwordError = _passwordController.text.isEmpty ? 'Password is required' : null;
    });

    if (_emailError != null || _passwordError != null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final hashedPassword = _hashPassword(_passwordController.text);
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('account.email', isEqualTo: _emailController.text)
          .where('account.password', isEqualTo: hashedPassword)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Successful login
        final userDoc = querySnapshot.docs.first;
        print('Login successful for user: ${userDoc['account']['email']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Login Successful!'),
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage(email: userDoc['account']['email'])),
        );
      } else {
        // Invalid credentials
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Invalid email or password.'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      print('Failed to login: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Login failed. Please try again later.'),
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email is required';
    } else if (!_emailRegExp.hasMatch(email)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              const SizedBox(height: 25),
              const Text(
                "Login to Your Account",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              _buildTextField("Email", _emailController, _emailError),
              _buildTextField("Password", _passwordController, _passwordError, obscureText: true),
              const SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        backgroundColor: Colors.white, // Set background color to white
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.black), // Set text color to black
                      ),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterPage()),
                      );
                    },
                    child: Text(
                      "Register Now",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller, String? errorText, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
          errorText: errorText,
        ),
      ),
    );
  }
}
