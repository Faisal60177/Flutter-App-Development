import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

/// Real-time Updates Page - Demonstrates real-time listeners with StreamBuilder
class RealtimeUpdatesPage extends StatefulWidget {
  const RealtimeUpdatesPage({super.key});

  @override
  State<RealtimeUpdatesPage> createState() => _RealtimeUpdatesPageState();
}

class _RealtimeUpdatesPageState extends State<RealtimeUpdatesPage> {
  final FirestoreService _firestoreService = FirestoreService();
  String _selectedStream = 'All Users';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-time Updates'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Stream selector
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.purple[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Stream Type',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildStreamChip('All Users', Icons.people),
                    _buildStreamChip('Active Users', Icons.check_circle),
                    _buildStreamChip('Ordered by Age', Icons.sort),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _selectedStream == 'All Users'
                              ? 'Listening to all users. Changes will appear automatically!'
                              : _selectedStream == 'Active Users'
                              ? 'Listening to active users only. Try adding/updating users!'
                              : 'Listening to users ordered by age. Updates in real-time!',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Stream content
          Expanded(
            child: _buildStreamContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildStreamChip(String label, IconData icon) {
    final isSelected = _selectedStream == label;
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedStream = label;
          });
        }
      },
      selectedColor: Colors.purple[200],
      checkmarkColor: Colors.purple[900],
    );
  }

  Widget _buildStreamContent() {
    switch (_selectedStream) {
      case 'All Users':
        return _buildAllUsersStream();
      case 'Active Users':
        return _buildActiveUsersStream();
      case 'Ordered by Age':
        return _buildOrderedUsersStream();
      default:
        return _buildAllUsersStream();
    }
  }

  Widget _buildAllUsersStream() {
    return StreamBuilder<List<UserModel>>(
      stream: _firestoreService.streamAllUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No users found',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final users = snapshot.data!;

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.green[50],
              child: Row(
                children: [
                  const Icon(Icons.update, color: Colors.green),
                  const SizedBox(width: 8),
                  const Text(
                    'Real-time updates active',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text('${users.length} users'),
                    backgroundColor: Colors.green[200],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: user.isActive
                            ? Colors.green
                            : Colors.grey,
                        child: Text(
                          user.name[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        user.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email: ${user.email}'),
                          Text('Age: ${user.age} | City: ${user.city}'),
                        ],
                      ),
                      trailing: user.isActive
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.cancel, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActiveUsersStream() {
    return StreamBuilder<List<UserModel>>(
      stream: _firestoreService.streamActiveUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No active users found',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final users = snapshot.data!;

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.green[50],
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 8),
                  const Text(
                    'Active users only (real-time)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text('${users.length} active'),
                    backgroundColor: Colors.green[200],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    color: Colors.green[50],
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(
                        user.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Age: ${user.age} | City: ${user.city}'),
                      trailing: const Icon(Icons.check_circle, color: Colors.green),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrderedUsersStream() {
    return StreamBuilder<List<UserModel>>(
      stream: _firestoreService.streamUsersOrderedByAge(limit: 10),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sort, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No users found',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final users = snapshot.data!;

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.blue[50],
              child: Row(
                children: [
                  const Icon(Icons.sort, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Text(
                    'Ordered by age (descending) - Top 10',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text('${users.length} users'),
                    backgroundColor: Colors.blue[200],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        user.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('City: ${user.city}'),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Age: ${user.age}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
