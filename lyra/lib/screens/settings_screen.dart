import 'package:flutter/material.dart';
import 'package:lyra/widgets/center%20widget/settings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: const SettingsWid(),
      ),
    );
  }
}
