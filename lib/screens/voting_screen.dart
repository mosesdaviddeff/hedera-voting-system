import 'package:flutter/material.dart';
import 'package:voting_system/screens/result_screen.dart';

class VotingScreen extends StatefulWidget {
  const VotingScreen({super.key});
  static const routeName = '/voting';

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  // In a real app, this would come from your HederaService
  final List<String> _candidates = [
    "Bola Ahmed Tinubu",
    "Peter Obi",
    "Musa Kwankwoso",
    "Nasir El-Rufai",
  ];

  int? _selectedCandidateIndex;

  void _castVote() {
    if (_selectedCandidateIndex != null) {
      // In a real app, you would call your HederaService.vote() method here.
      // The candidate ID would be _selectedCandidateIndex! + 1
      print('Voting for: ${_candidates[_selectedCandidateIndex!]}');

      // Navigate to the result screen and pass the message
      Navigator.pushReplacementNamed(context, ResultScreen.routeName);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a candidate to vote.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select a Candidate')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _candidates.length,
                itemBuilder: (context, index) {
                  return RadioListTile<int>(
                    title: Text(_candidates[index]),
                    value: index,
                    groupValue: _selectedCandidateIndex,
                    onChanged: (value) =>
                        setState(() => _selectedCandidateIndex = value),
                  );
                },
              ),
            ),
            ElevatedButton(onPressed: _castVote, child: const Text('Cast Vote')),
          ],
        ),
      ),
    );
  }
}