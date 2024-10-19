import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:biomark/pages/login_page.dart';

class RecoveryPage extends StatefulWidget {
  final String email;
  const RecoveryPage({Key? key, required this.email}) : super(key: key);

  @override
  _RecoveryPageState createState() => _RecoveryPageState();
}

class _RecoveryPageState extends State<RecoveryPage> {
  int _currentStep = 0;
  bool _isLoading = false;
  String? _errorMessage;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _motherMaidenNameController = TextEditingController();
  final TextEditingController _bestFriendNameController = TextEditingController();
  final TextEditingController _petNameController = TextEditingController();
  final TextEditingController _customQuestionController = TextEditingController();
  final TextEditingController _customAnswerController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  DateTime? _selectedDOB;

  void _nextStep() {
    setState(() {
      _errorMessage = null;
    });

    if (_currentStep == 0) {
      if (_validateStep1()) {
        _submitRecoveryInfo();
      }
    } else if (_currentStep == 1) {
      if (_validateNewPassword()) {
        _resetPassword();
      }
    }
  }

  bool _validateStep1() {
    if (_nameController.text.isEmpty) {
      _showError('Name is required.');
      return false;
    }

    if (_selectedDOB == null) {
      _showError('Date of Birth is required.');
      return false;
    }

    return true;
  }

  bool _validateNewPassword() {
    if (_newPasswordController.text.isEmpty) {
      _showError('New password is required.');
      return false;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showError('Passwords do not match.');
      return false;
    }

    return true;
  }

  void _submitRecoveryInfo() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('account.email', isEqualTo: widget.email)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        _showError('No user found with the provided email.');
        return;
      }

      final userDoc = query.docs.first;
      final recoveryData = userDoc.data()['recovery'];

      final hashedName = _hashData(_nameController.text);
      final hashedDOB = _hashData(DateFormat('yyyy-MM-dd').format(_selectedDOB!));
      final hashedAnswers = {
        'motherMaidenName': _hashData(_motherMaidenNameController.text),
        'bestFriendName': _hashData(_bestFriendNameController.text),
        'petName': _hashData(_petNameController.text),
        'ownQuestion': _hashData(_customQuestionController.text),
        'ownAnswer': _hashData(_customAnswerController.text),
      };

      if (recoveryData['name'] != hashedName || recoveryData['dob'] != hashedDOB) {
        _showError('Name or Date of Birth does not match our records.');
        return;
      }

      for (var key in hashedAnswers.keys) {
        if (recoveryData[key] != hashedAnswers[key]) {
          _showError('Recovery answers do not match our records.');
          return;
        }
      }

      setState(() {
        _currentStep++;
      });
    } catch (e) {
      _showError('An error occurred during recovery. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _resetPassword() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('account.email', isEqualTo: widget.email)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final userDoc = query.docs.first;
        await userDoc.reference.update({
          'account.password': _hashData(_newPasswordController.text),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset successfully!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        _showError('No user found with the provided email.');
      }
    } catch (e) {
      _showError('An error occurred while resetting the password.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _hashData(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
      _isLoading = false;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDOB) {
      setState(() {
        _selectedDOB = picked;
      });
    }
  }

  Widget _buildDateField(String labelText) {
    return Container(
      padding: const EdgeInsets.only(top: 16.0),
      child: GestureDetector(
        onTap: () => _selectDate(context),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: labelText,
            border: const OutlineInputBorder(),
            labelStyle: TextStyle(color: Colors.grey),
          ),
          child: Text(
            _selectedDOB != null
                ? DateFormat.yMd().format(_selectedDOB!)
                : 'Select date',
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.grey),
          border: const OutlineInputBorder(),
        ),
        obscureText: obscureText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Recovery')),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  if (_currentStep == 0) ...[
                    _buildTextField('Name', _nameController),
                    _buildDateField('Date of Birth'),
                    _buildTextField('Mother\'s Maiden Name', _motherMaidenNameController),
                    _buildTextField('Best Friend\'s Name', _bestFriendNameController),
                    _buildTextField('Pet\'s Name', _petNameController),
                    _buildTextField('Custom Question', _customQuestionController),
                    _buildTextField('Custom Answer', _customAnswerController),
                  ] else if (_currentStep == 1) ...[
                    _buildTextField('New Password', _newPasswordController, obscureText: true),
                    _buildTextField('Confirm Password', _confirmPasswordController, obscureText: true),
                  ],
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(_currentStep == 1 ? 'Reset Password' : 'Next'),
                  ),
                ],
              ),
      ),
    );
  }
}
