import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voting_system/screens/voting_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _ninController = TextEditingController();

  void _signIn() {
    if (_ninController.text.length == 11) {
      // In a real app, you would perform Hedera DID authentication here.
      // For now, we just navigate to the next screen.
      Navigator.pushReplacementNamed(context, VotingScreen.routeName);
    } else {
      // Show an error if the NIN is not 11 digits
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 11-digit NIN.')),
      );
    }
  }

  @override
  void dispose() {
    _ninController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hedera Vote - Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter your National Identification Number (NIN) to continue.',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _ninController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Your NIN',
                counterText: "", // Hides the counter text below the field
              ),
              maxLength: 11,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: _signIn, child: const Text('Sign In')),
          ],
        ),
      ),
    );
  }
}