import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  // Change these to your own details.
  static const String appVersion = '1.0.0';
  static const String developerName = 'Your Name';
  static const String developerInfo = 'Md Belal Mondal';

  static const List<(IconData, String)> _features = [
    (Icons.add_circle_outline, 'Add income and expense transactions'),
    (Icons.edit_outlined, 'Edit or delete any transaction'),
    (Icons.account_balance_wallet_outlined,
        'Live total income, expense and balance'),
    (Icons.storage_outlined, 'Data saved offline on your device'),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('About App')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 8),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset('assets/icon/app_logo.png',
                  width: 96, height: 96),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text('Expense Tracker',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text('Version $appVersion',
                style: TextStyle(color: scheme.outline)),
          ),
          const SizedBox(height: 20),
          const Text(
            'Expense Tracker helps you manage your daily income and '
            'expenses in one place. Add transactions, see where your money '
            'goes, and always know your current balance.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, height: 1.4),
          ),
          const SizedBox(height: 24),
          const Text('Features',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                for (final f in _features)
                  ListTile(
                    dense: true,
                    leading: Icon(f.$1, color: scheme.primary),
                    title: Text(f.$2),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Built With',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              Chip(label: Text('Flutter')),
              Chip(label: Text('Dart')),
              Chip(label: Text('Sqflite (SQLite)')),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Developer',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text(developerName),
              subtitle: const Text(developerInfo),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text('© ${DateTime.now().year} Expense Tracker',
                style: TextStyle(color: scheme.outline, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
