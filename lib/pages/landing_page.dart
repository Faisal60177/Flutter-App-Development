import 'package:flutter/material.dart';
import 'add_user_page.dart';
import 'view_users_page.dart';
import 'realtime_updates_page.dart';
import 'query_examples_page.dart';
import 'error_handling_page.dart';

/// Landing Page - Main navigation page for Firestore examples
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Query Examples'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Firebase Firestore Learning App',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Learn Firestore queries with practical examples',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _buildFeatureCard(
            context,
            title: '1. Add Data to Firestore',
            description: 'Learn how to add documents with auto-generated and custom IDs',
            icon: Icons.add_circle,
            color: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddUserPage()),
              );
            },
          ),
          _buildFeatureCard(
            context,
            title: '2. Fetch Data from Firestore',
            description: 'View users and learn different query methods',
            icon: Icons.list,
            color: Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ViewUsersPage()),
              );
            },
          ),
          _buildFeatureCard(
            context,
            title: '3. Query Examples',
            description: 'Explore various query operations (where, orderBy, limit, etc.)',
            icon: Icons.search,
            color: Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QueryExamplesPage()),
              );
            },
          ),
          _buildFeatureCard(
            context,
            title: '4. Real-time Updates',
            description: 'See how real-time listeners work with StreamBuilder',
            icon: Icons.update,
            color: Colors.purple,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RealtimeUpdatesPage()),
              );
            },
          ),
          _buildFeatureCard(
            context,
            title: '5. Error Handling',
            description: 'Learn how to handle Firestore errors properly',
            icon: Icons.error_outline,
            color: Colors.red,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ErrorHandlingPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
      BuildContext context, {
        required String title,
        required String description,
        required IconData icon,
        required Color color,
        required VoidCallback onTap,
      }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}