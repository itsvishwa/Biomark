import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegisterPageStep2 extends StatefulWidget {
  const RegisterPageStep2({Key? key}) : super(key: key);

  @override
  RegisterPageStep2State createState() => RegisterPageStep2State();
}

class RegisterPageStep2State extends State<RegisterPageStep2> {
  DateTime? _selectedDate;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _motherMaidenNameController = TextEditingController();
  final TextEditingController _bestFriendNameController = TextEditingController();
  final TextEditingController _petNameController = TextEditingController();
  final TextEditingController _ownQuestionController = TextEditingController();
  final TextEditingController _ownAnswerController = TextEditingController();

  String? _nameError;
  String? _motherMaidenNameError;
  String? _bestFriendNameError;
  String? _petNameError;
  String? _ownQuestionError;
  String? _ownAnswerError;

  Map<String, dynamic> saveData() {
    return {
      'dob': _selectedDate,
      'name': _nameController.text,
      'motherMaidenName': _motherMaidenNameController.text,
      'bestFriendName': _bestFriendNameController.text,
      'petName': _petNameController.text,
      'ownQuestion': _ownQuestionController.text,
      'ownAnswer': _ownAnswerController.text,
    };
  }

  @override
  void initState() {
    super.initState();

    _nameController.addListener(validateName);
    _motherMaidenNameController.addListener(validateMotherMaidenName);
    _bestFriendNameController.addListener(validateBestFriendName);
    _petNameController.addListener(validatePetName);
    _ownQuestionController.addListener(validateOwnQuestion);
    _ownAnswerController.addListener(validateOwnAnswer);
  }

  void validateName() {
    setState(() {
      _nameError = _nameController.text.isEmpty ? 'Name is required.' : null;
    });
  }

  void validateMotherMaidenName() {
    setState(() {
      _motherMaidenNameError = _motherMaidenNameController.text.isEmpty ? "Mother’s Maiden Name is required." : null;
    });
  }

  void validateBestFriendName() {
    setState(() {
      _bestFriendNameError = _bestFriendNameController.text.isEmpty ? "Best Friend's Name is required." : null;
    });
  }

  void validatePetName() {
    setState(() {
      _petNameError = _petNameController.text.isEmpty ? "Pet Name is required." : null;
    });
  }

  void validateOwnQuestion() {
    setState(() {
      _ownQuestionError = _ownQuestionController.text.isEmpty ? "Own Question is required." : null;
    });
  }

  void validateOwnAnswer() {
    setState(() {
      _ownAnswerError = _ownAnswerController.text.isEmpty ? "Own Answer is required." : null;
    });
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
        _buildDateField("Date of Birth", _selectedDate, _selectDate),
        _buildTextField("Name", _nameController, _nameError),
        _buildTextField("Mother's Maiden Name", _motherMaidenNameController, _motherMaidenNameError),
        _buildTextField("Childhood Best Friend's Name", _bestFriendNameController, _bestFriendNameError),
        _buildTextField("Childhood Pet's Name", _petNameController, _petNameError),
        _buildTextField("Your Own Question", _ownQuestionController, _ownQuestionError),
        _buildTextField("Your Own Answer", _ownAnswerController, _ownAnswerError),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Widget _buildDateField(String labelText, DateTime? selectedDate, Function(BuildContext) onSelect) {
    return Container(
      padding: const EdgeInsets.only(top: 16.0, bottom: 12.0), // Margin between fields
      child: GestureDetector(
        onTap: () => onSelect(context),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          ),
          child: Text(selectedDate != null
              ? DateFormat.yMd().format(selectedDate)
              : 'Select date'),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _motherMaidenNameController.dispose();
    _bestFriendNameController.dispose();
    _petNameController.dispose();
    _ownQuestionController.dispose();
    _ownAnswerController.dispose();
    super.dispose();
  }
}
