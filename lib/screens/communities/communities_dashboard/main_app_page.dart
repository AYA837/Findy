import 'package:flutter/material.dart';

class MainAppPage extends StatelessWidget {
  const MainAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Findy'),
      ),
      body: const Center(
        child: Text(
          'Main Findy Application',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
