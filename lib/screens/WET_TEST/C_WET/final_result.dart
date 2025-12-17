// final_result.dart
import 'package:flutter/material.dart';

class FinalResultScreen extends StatelessWidget {
  const FinalResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Final Result')),
      body: const Center(
        child: Text('All groups confirmed! Here is your final result.'),
      ),
    );
  }
}
