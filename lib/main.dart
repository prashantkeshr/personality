import 'package:flutter/material.dart';

// Phase 0 bootstrap. Theme, localization, routing, database and onboarding
// replace this in Phase 1 (see docs/PHASES.md).
void main() => runApp(const PersonalityApp());

class PersonalityApp extends StatelessWidget {
  const PersonalityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Personality',
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: Text('Personality'))),
    );
  }
}
