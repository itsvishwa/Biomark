import 'package:biomark/pages/register_step_1_page.dart';
import 'package:biomark/pages/register_step_2_page.dart';
import 'package:biomark/pages/register_step_3_page.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _currentStep = 0;

  // Data structures for the form data
  Map<String, dynamic> model = {};
  Map<String, dynamic> recovery = {};
  Map<String, dynamic> account = {};

  // Function to move to the next step
  void _nextStep() {
    if (_currentStep == 0) {
      // Save data from step 1 (model)
      final step1State = _getStep1State();
      if (step1State != null) {
        setState(() {
          model = step1State;
        });
      }
    } else if (_currentStep == 1) {
      // Save data from step 2 (recovery)
      final step2State = _getStep2State();
      if (step2State != null) {
        setState(() {
          recovery = step2State;
        });
      }
    } else if (_currentStep == 2) {
      // Save data from step 3 (account)
      final step3State = _getStep3State();
      if (step3State != null) {
        setState(() {
          account = step3State;
        });
        _submitForm(); // Submit the form after final step
        return; // End after submission
      }
    }

    // Move to the next step
    if (_currentStep < 2) {
      setState(() {
        _currentStep += 1;
      });
    }
  }

  // Function to go back to the previous step
  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  // Retrieve data from step 1 (form 1)
  Map<String, dynamic>? _getStep1State() {
    final step1Form = _step1Key.currentState;
    if (step1Form != null) {
      return step1Form.saveData();
    }
    return null;
  }

  // Retrieve data from step 2 (form 2)
  Map<String, dynamic>? _getStep2State() {
    final step2Form = _step2Key.currentState;
    if (step2Form != null) {
      return step2Form.saveData();
    }
    return null;
  }

  // Retrieve data from step 3 (form 3)
  Map<String, dynamic>? _getStep3State() {
    final step3Form = _step3Key.currentState;
    if (step3Form != null) {
      return step3Form.saveData();
    }
    return null;
  }

  // Submit the final form
  void _submitForm() {
    print('Model: $model');
    print('Recovery: $recovery');
    print('Account: $account');

    // Now you can send this data to your server or use it as needed.
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
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Login Now",
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

  // Keys for accessing form states
  final GlobalKey<RegisterPageStep1State> _step1Key = GlobalKey<RegisterPageStep1State>();
  final GlobalKey<RegisterPageStep2State> _step2Key = GlobalKey<RegisterPageStep2State>();
  final GlobalKey<RegisterPageStep3State> _step3Key = GlobalKey<RegisterPageStep3State>();
}
