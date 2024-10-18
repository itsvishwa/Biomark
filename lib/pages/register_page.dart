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

  // Function to move to the next step
  void _nextStep() {
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
              // logo
              Icon(
                Icons.account_circle,
                size: 80,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),

              // space
              const SizedBox(height: 25),

              // Title
              const Text(
                "Welcome, Register Here",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // already have an account ?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(" Login Now",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          )))
                ],
              ),

              // Make Stepper Scrollable and Full Width
              Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: double.infinity, // Full width Stepper
                    child: Stepper(
                      currentStep: _currentStep,
                      onStepContinue: _nextStep,
                      onStepCancel: _previousStep,
                      steps: [
                        Step(
                          title: const Text("Step 1: Model Data"),
                          content: const RegisterPageStep1(),
                          isActive: _currentStep >= 0,
                          state: _currentStep > 0
                              ? StepState.complete
                              : StepState.indexed,
                        ),
                        Step(
                          title: const Text("Step 2: Account Recovery Data"),
                          content: const RegisterPageStep2(),
                          isActive: _currentStep >= 1,
                          state: _currentStep > 1
                              ? StepState.complete
                              : StepState.indexed,
                        ),
                        Step(
                          title: const Text("Step 3: Email & Password"),
                          content: const RegisterPageStep3(),
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
}
