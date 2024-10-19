import 'package:flutter/material.dart';

class RegisterPageStep3 extends StatefulWidget {
  const RegisterPageStep3({Key? key}) : super(key: key);

  @override
  RegisterPageStep3State createState() => RegisterPageStep3State();
}

class RegisterPageStep3State extends State<RegisterPageStep3> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Function to save the form data
  Map<String, dynamic> saveData() {
    return {
      'email': _emailController.text,
      'password': _passwordController.text,
    };
  }

  Widget _buildTextField(String labelText, TextEditingController controller, bool obscureText) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField("Email", _emailController, false),
        const SizedBox(height: 10),
        _buildTextField("Password", _passwordController, true),
        const SizedBox(height: 10),
        _buildTextField("Confirm Password", _confirmPasswordController, true),
      ],
    );
  }
}
