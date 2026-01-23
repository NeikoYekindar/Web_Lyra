import 'package:flutter/material.dart';
import '../widgets/theme_toggle_button.dart';

class ThemeTestScreen extends StatelessWidget {
  const ThemeTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Test'),
        actions: const [
          ThemeToggleButton(),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Indicator
            const Row(
              children: [
                Text('Current Theme: '),
                ThemeIndicator(),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Colors Preview
            Text(
              'Colors Preview',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            
            // Background Colors
            _buildColorCard(
              context,
              'Background',
              Theme.of(context).colorScheme.surface,
            ),
            _buildColorCard(
              context,
              'Surface',
              Theme.of(context).colorScheme.surface,
            ),
            _buildColorCard(
              context,
              'Primary',
              Theme.of(context).colorScheme.primary,
            ),
            _buildColorCard(
              context,
              'Secondary',
              Theme.of(context).colorScheme.secondary,
            ),
            
            const SizedBox(height: 24),
            
            // Text Styles Preview
            Text(
              'Text Styles Preview',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            
            _buildTextStyleCard(context, 'Display Large', Theme.of(context).textTheme.displayLarge),
            _buildTextStyleCard(context, 'Headline Large', Theme.of(context).textTheme.headlineLarge),
            _buildTextStyleCard(context, 'Title Large', Theme.of(context).textTheme.titleLarge),
            _buildTextStyleCard(context, 'Body Large', Theme.of(context).textTheme.bodyLarge),
            _buildTextStyleCard(context, 'Body Medium', Theme.of(context).textTheme.bodyMedium),
            _buildTextStyleCard(context, 'Body Small', Theme.of(context).textTheme.bodySmall),
            
            const SizedBox(height: 24),
            
            // Buttons Preview
            Text(
              'Buttons Preview',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Elevated Button'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Outlined Button'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Text Button'),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Cards Preview
            Text(
              'Cards Preview',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sample Card',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This is a sample card to demonstrate the theme colors and styles.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorCard(BuildContext context, String name, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '#${color.value.toRadixString(16).toUpperCase()}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextStyleCard(BuildContext context, String name, TextStyle? style) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 4),
            Text('Sample text in $name style', style: style),
          ],
        ),
      ),
    );
  }
}