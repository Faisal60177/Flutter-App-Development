import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

/// Error Handling Page - Demonstrates proper error handling in Firestore
class ErrorHandlingPage extends StatefulWidget {
  const ErrorHandlingPage({super.key});

  @override
  State<ErrorHandlingPage> createState() => _ErrorHandlingPageState();
}

class _ErrorHandlingPageState extends State<ErrorHandlingPage> {
  final FirestoreService _firestoreService = FirestoreService();
  final _userIdController = TextEditingController();
  String? _lastError;
  String? _lastSuccess;
  bool _isLoading = false;

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }

  // Example 1: Try-Catch with FirebaseException
  Future<void> _addUserWithErrorHandling() async {
    setState(() {
      _isLoading = true;
      _lastError = null;
      _lastSuccess = null;
    });

    try {
      final user = UserModel(
        name: 'Test User',
        email: 'test@example.com',
        age: 25,
        city: 'Test City',
      );

      await _firestoreService.addUser(user);
      setState(() {
        _lastSuccess = 'User added successfully!';
        _isLoading = false;
      });
    } on FirebaseException catch (e) {
      setState(() {
        _lastError = _getErrorMessage(e);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _lastError = 'Unexpected error: $e';
        _isLoading = false;
      });
    }
  }

  // Example 2: Check document existence
  Future<void> _getUserSafely() async {
    final userId = _userIdController.text.trim();
    if (userId.isEmpty) {
      setState(() {
        _lastError = 'Please enter a user ID';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _lastError = null;
      _lastSuccess = null;
    });

    try {
      final user = await _firestoreService.getUser(userId);
      if (user != null) {
        setState(() {
          _lastSuccess = 'User found: ${user.name} (${user.email})';
          _isLoading = false;
        });
      } else {
        setState(() {
          _lastError = 'User not found with ID: $userId';
          _isLoading = false;
        });
      }
    } on FirebaseException catch (e) {
      setState(() {
        _lastError = _getErrorMessage(e);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _lastError = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  // Example 3: Delete with confirmation and error handling
  Future<void> _deleteUserSafely() async {
    final userId = _userIdController.text.trim();
    if (userId.isEmpty) {
      setState(() {
        _lastError = 'Please enter a user ID';
      });
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete user: $userId?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _isLoading = true;
      _lastError = null;
      _lastSuccess = null;
    });

    try {
      await _firestoreService.deleteUser(userId);
      setState(() {
        _lastSuccess = 'User deleted successfully!';
        _isLoading = false;
      });
      _userIdController.clear();
    } on FirebaseException catch (e) {
      setState(() {
        _lastError = _getErrorMessage(e);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _lastError = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  // Example 4: Error handling in StreamBuilder
  Widget _buildStreamWithErrorHandling() {
    return StreamBuilder<List<UserModel>>(
      stream: _firestoreService.streamAllUsers(),
      builder: (context, snapshot) {
        // Handle errors
        if (snapshot.hasError) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red),
            ),
            child: Column(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 8),
                const Text(
                  'Stream Error',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getErrorMessage(snapshot.error as FirebaseException?),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          );
        }

        // Handle loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Handle empty data
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: const Column(
              children: [
                Icon(Icons.info_outline, size: 48, color: Colors.grey),
                SizedBox(height: 8),
                Text(
                  'No users found',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // Display data
        final users = snapshot.data!;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 8),
                  Text(
                    'Stream Active',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Users count: ${users.length}'),
            ],
          ),
        );
      },
    );
  }

  String _getErrorMessage(FirebaseException? e) {
    if (e == null) return 'Unknown error';

    switch (e.code) {
      case 'permission-denied':
        return 'Permission denied. Check your Firestore security rules.';
      case 'not-found':
        return 'The requested data was not found.';
      case 'invalid-argument':
        return 'Invalid argument provided. Check your data.';
      case 'deadline-exceeded':
        return 'Request timed out. Please try again.';
      case 'unavailable':
        return 'Firestore is temporarily unavailable.';
      case 'already-exists':
        return 'This item already exists.';
      case 'failed-precondition':
        return 'Operation cannot be completed.';
      default:
        return 'Error: ${e.message ?? e.code}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error Handling'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Information card
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'Error Handling Best Practices',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildBestPractice('Always use try-catch for async operations'),
                    _buildBestPractice('Catch FirebaseException specifically'),
                    _buildBestPractice('Check document existence before accessing'),
                    _buildBestPractice('Provide user-friendly error messages'),
                    _buildBestPractice('Handle stream errors in StreamBuilder'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Example 1: Add user with error handling
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Example 1: Add User with Error Handling',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This demonstrates try-catch with FirebaseException',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _addUserWithErrorHandling,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                          : const Text('Add Test User'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Example 2: Get user safely
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Example 2: Get User Safely',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Check if document exists before accessing',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _userIdController,
                      decoration: const InputDecoration(
                        labelText: 'User ID',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                            _isLoading ? null : _getUserSafely,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Get User'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                            _isLoading ? null : _deleteUserSafely,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Delete User'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Example 3: Stream with error handling
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Example 3: Stream with Error Handling',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Handle errors in StreamBuilder',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    _buildStreamWithErrorHandling(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Error/Success messages
            if (_lastError != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _lastError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            if (_lastSuccess != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _lastSuccess!,
                        style: const TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBestPractice(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 16, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
