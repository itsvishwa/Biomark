import 'package:flutter/material.dart';

class RegisterPageStep3 extends StatefulWidget {
  const RegisterPageStep3({Key? key}) : super(key: key);

  @override
  RegisterPageStep3State createState() => RegisterPageStep3State();
}

class RegisterPageStep3State extends State<RegisterPageStep3> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();

    _nameController.addListener(validateName);
    _emailController.addListener(validateEmail);
    _passwordController.addListener(validatePassword);
    _confirmPasswordController.addListener(validateConfirmPassword);
  }

  void validateName() {
    setState(() {
      _nameError = _nameController.text.isEmpty ? 'Name is required.' : null;
    });
  }

  void validateEmail() {
    setState(() {
      if (_emailController.text.isEmpty) {
        _emailError = 'Email is required.';
      } else if (!_isValidEmail(_emailController.text)) {
        _emailError = 'Enter a valid email address (example@mail.com).';
      } else {
        _emailError = null;
      }
    });
  }

  bool _isValidEmail(String email) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(email);
  }

  void validatePassword() {
    setState(() {
      _passwordError = _passwordController.text.isEmpty ? 'Password is required.' : null;
    });
  }

  void validateConfirmPassword() {
    setState(() {
      if (_confirmPasswordController.text.isEmpty) {
        _confirmPasswordError = 'Confirm Password is required.';
      } else if (_passwordController.text != _confirmPasswordController.text) {
        _confirmPasswordError = 'Passwords do not match.';
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  Map<String, dynamic> saveData() {
    return {
      'name': _nameController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
    };
  }

  Widget _buildTextField(String labelText, TextEditingController controller, bool obscureText, String? errorText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(),
            errorText: errorText,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField("Name", _nameController, false, _nameError),
        _buildTextField("Email", _emailController, false, _emailError),
        _buildTextField("Password", _passwordController, true, _passwordError),
        _buildTextField("Confirm Password", _confirmPasswordController, true, _confirmPasswordError),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
