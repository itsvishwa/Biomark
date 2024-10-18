import 'package:biomark/components/custom_button.dart';
import 'package:biomark/components/custom_text_field.dart';
import 'package:biomark/pages/register_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  void logInHandler() {}
  void navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Center(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                    "Login Here",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // space
                  const SizedBox(height: 50),

                  // Email Field
                  CustomTextField(
                    hintText: "Email",
                    obscureText: false,
                    controller: emailController,
                  ),

                  // space
                  const SizedBox(height: 10),

                  // Password Field
                  CustomTextField(
                    hintText: "Password",
                    obscureText: true,
                    controller: passwordController,
                  ),

                  // space
                  const SizedBox(height: 10),

                  // forget password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Forget Password?",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),

                  // space
                  const SizedBox(height: 25),

                  // sigin in button
                  CustomButton(text: "Log In", onTap: logInHandler),

                  // space
                  const SizedBox(height: 25),

                  // don't have an account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                          onPressed: navigateToRegister,
                          child: Text(" Register Now",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              )))
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
