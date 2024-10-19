import 'package:flutter/material.dart';

class RegisterPageStep2 extends StatefulWidget {
  const RegisterPageStep2({Key? key}) : super(key: key);

  @override
  RegisterPageStep2State createState() => RegisterPageStep2State();
}

class RegisterPageStep2State extends State<RegisterPageStep2> {
  final TextEditingController _motherMaidenNameController = TextEditingController();
  final TextEditingController _petNameController = TextEditingController();
  final TextEditingController _firstSchoolController = TextEditingController();
  final TextEditingController _favoriteColorController = TextEditingController();

  // Function to save the form data
  Map<String, dynamic> saveData() {
    return {
      'motherMaidenName': _motherMaidenNameController.text,
      'petName': _petNameController.text,
      'firstSchool': _firstSchoolController.text,
      'favoriteColor': _favoriteColorController.text,
    };
  }

  Widget _buildTextField(String labelText, TextEditingController controller) {
    return TextField(
      controller: controller,
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
        _buildTextField("Mother's Maiden Name", _motherMaidenNameController),
        const SizedBox(height: 10),
        _buildTextField("Pet's Name", _petNameController),
        const SizedBox(height: 10),
        _buildTextField("First School", _firstSchoolController),
        const SizedBox(height: 10),
        _buildTextField("Favorite Color", _favoriteColorController),
      ],
    );
  }
}
