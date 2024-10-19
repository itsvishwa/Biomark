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

  String? _motherMaidenNameError;
  String? _petNameError;
  String? _firstSchoolError;
  String? _favoriteColorError;

  @override
  void initState() {
    super.initState();

    _motherMaidenNameController.addListener(validateMotherMaidenName);
    _petNameController.addListener(validatePetName);
    _firstSchoolController.addListener(validateFirstSchool);
    _favoriteColorController.addListener(validateFavoriteColor);
  }

  void validateMotherMaidenName() {
    setState(() {
      _motherMaidenNameError = _motherMaidenNameController.text.isEmpty ? "Mother’s Maiden Name is required." : null;
    });
  }

  void validatePetName() {
    setState(() {
      _petNameError = _petNameController.text.isEmpty ? "Pet Name is required." : null;
    });
  }

  void validateFirstSchool() {
    setState(() {
      _firstSchoolError = _firstSchoolController.text.isEmpty ? "First School is required." : null;
    });
  }

  void validateFavoriteColor() {
    setState(() {
      _favoriteColorError = _favoriteColorController.text.isEmpty ? "Favorite Color is required." : null;
    });
  }

  Map<String, dynamic> saveData() {
    return {
      'motherMaidenName': _motherMaidenNameController.text,
      'petName': _petNameController.text,
      'firstSchool': _firstSchoolController.text,
      'favoriteColor': _favoriteColorController.text,
    };
  }

  Widget _buildTextField(String labelText, TextEditingController controller, String? errorText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
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
        _buildTextField("Mother's Maiden Name", _motherMaidenNameController, _motherMaidenNameError),
        _buildTextField("Pet's Name", _petNameController, _petNameError),
        _buildTextField("First School", _firstSchoolController, _firstSchoolError),
        _buildTextField("Favorite Color", _favoriteColorController, _favoriteColorError),
      ],
    );
  }

  @override
  void dispose() {
    _motherMaidenNameController.dispose();
    _petNameController.dispose();
    _firstSchoolController.dispose();
    _favoriteColorController.dispose();
    super.dispose();
  }
}
