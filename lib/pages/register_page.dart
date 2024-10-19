import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:biomark/pages/register_step_1_page.dart';
import 'package:biomark/pages/register_step_2_page.dart';
import 'package:biomark/pages/register_step_3_page.dart';
import 'package:biomark/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _currentStep = 0;

  Map<String, dynamic> model = {};
  Map<String, dynamic> recovery = {};
  Map<String, dynamic> account = {};

  void _nextStep() {
    if (_currentStep == 0) {
      final step1State = _getStep1State();
      if (step1State != null) {
        setState(() {
          model = step1State;
        });
      }
    } else if (_currentStep == 1) {
      final step2State = _getStep2State();
      if (step2State != null) {
        setState(() {
          recovery = step2State;
        });
      }
    } else if (_currentStep == 2) {
      final step3State = _getStep3State();
      if (step3State != null) {
        setState(() {
          account = step3State;
        });
        _submitForm();
        return;
      }
    }

    if (_currentStep < 2) {
      setState(() {
        _currentStep += 1;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  Map<String, dynamic>? _getStep1State() {
    final step1Form = _step1Key.currentState;
    if (step1Form != null) {
      return step1Form.saveData();
    }
    return null;
  }

  Map<String, dynamic>? _getStep2State() {
    final step2Form = _step2Key.currentState;
    if (step2Form != null) {
      return step2Form.saveData();
    }
    return null;
  }

  Map<String, dynamic>? _getStep3State() {
    final step3Form = _step3Key.currentState;
    if (step3Form != null) {
      return step3Form.saveData();
    }
    return null;
  }

  void _submitForm() {
    print('Submitting form...');

    if (model['dateOfBirth'] is DateTime) {
      final date = model['dateOfBirth'] as DateTime;
      model['dateOfBirth'] = "${date.year}-${date.month}-${date.day}";
    }

    if (model['timeOfBirth'] is TimeOfDay) {
      final time = model['timeOfBirth'] as TimeOfDay;
      model['timeOfBirth'] = "${time.hour}:${time.minute}";
    }

    if (recovery['dob'] is DateTime) {
      final date = recovery['dob'] as DateTime;
      recovery['dob'] = "${date.year}-${date.month}-${date.day}";
    }

    if (_validateForm(model, 'Model') && _validateForm(recovery, 'Recovery') && _validateForm(account, 'Account')) {
      if (account['password'] != null) {
        final hashedPassword = _hashData(account['password']);
        account['password'] = hashedPassword;
      }

      recovery = recovery.map((key, value) {
        if (value != null) {
          return MapEntry(key, _hashData(value));
        }
        return MapEntry(key, value);
      });

      FirebaseFirestore.instance.collection('users').add({
        'model': model,
        'recovery': recovery,
        'account': account,
      }).then((_) {
        print('User registered successfully!');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('User Registered Successfully!'),
            duration: const Duration(seconds: 2),
          ),
        );
        setState(() {
          model = {};
          recovery = {};
          account = {};
          _currentStep = 0;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }).catchError((error) {
        print('Failed to register user: $error');
      });
    }
  }

  String _hashData(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  bool _validateForm(Map<String, dynamic> formData, String formName) {
    for (var entry in formData.entries) {
      if (entry.value == null || (entry.value is String && entry.value.isEmpty)) {
        print('$formName field "${entry.key}" is required.');
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.account_circle,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              const SizedBox(height: 25),
              const Text(
                "Welcome, Register Here",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: double.infinity,
                    child: Stepper(
                      currentStep: _currentStep,
                      onStepContinue: _nextStep,
                      onStepCancel: _previousStep,
                      steps: [
                        Step(
                          title: const Text("Step 1: Model Data"),
                          content: RegisterPageStep1(key: _step1Key),
                          isActive: _currentStep >= 0,
                          state: _currentStep > 0
                              ? StepState.complete
                              : StepState.indexed,
                        ),
                        Step(
                          title: const Text("Step 2: Account Recovery Data"),
                          content: RegisterPageStep2(key: _step2Key),
                          isActive: _currentStep >= 1,
                          state: _currentStep > 1
                              ? StepState.complete
                              : StepState.indexed,
                        ),
                        Step(
                          title: const Text("Step 3: Email & Password"),
                          content: RegisterPageStep3(key: _step3Key),
                          isActive: _currentStep >= 2,
                          state: _currentStep == 2
                              ? StepState.complete
                              : StepState.indexed,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final GlobalKey<RegisterPageStep1State> _step1Key = GlobalKey<RegisterPageStep1State>();
  final GlobalKey<RegisterPageStep2State> _step2Key = GlobalKey<RegisterPageStep2State>();
  final GlobalKey<RegisterPageStep3State> _step3Key = GlobalKey<RegisterPageStep3State>();
}
