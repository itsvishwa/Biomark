import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting the date and time

class RegisterPageStep1 extends StatefulWidget {
  const RegisterPageStep1({Key? key}) : super(key: key);

  @override
  RegisterPageStep1State createState() => RegisterPageStep1State();
}

class RegisterPageStep1State extends State<RegisterPageStep1> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _ethnicityController = TextEditingController();
  final TextEditingController _eyeColorController = TextEditingController();

  // Function to save the form data
  Map<String, dynamic> saveData() {
    return {
      'dateOfBirth': _selectedDate,
      'timeOfBirth': _selectedTime,
      'locationOfBirth': _locationController.text,
      'bloodGroup': _bloodGroupController.text,
      'sex': _sexController.text,
      'height': _heightController.text,
      'ethnicity': _ethnicityController.text,
      'eyeColor': _eyeColorController.text,
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
        _buildDateField("Date of Birth", _selectedDate, _selectDate),
        _buildTimeField("Time of Birth", _selectedTime, _selectTime),
        _buildTextField("Location of Birth", _locationController),
        _buildTextField("Blood Group", _bloodGroupController),
        _buildTextField("Sex", _sexController),
        _buildTextField("Height", _heightController),
        _buildTextField("Ethnicity", _ethnicityController),
        _buildTextField("Eye Colour", _eyeColorController),
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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Widget _buildDateField(String labelText, DateTime? selectedDate, Function(BuildContext) onSelect) {
    return GestureDetector(
      onTap: () => onSelect(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
        child: Text(selectedDate != null
            ? DateFormat.yMd().format(selectedDate)
            : 'Select date'),
      ),
    );
  }

  Widget _buildTimeField(String labelText, TimeOfDay? selectedTime, Function(BuildContext) onSelect) {
    return GestureDetector(
      onTap: () => onSelect(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
        child: Text(selectedTime != null
            ? selectedTime.format(context)
            : 'Select time'),
      ),
    );
  }
}
