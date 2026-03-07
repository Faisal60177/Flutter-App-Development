import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

/// Add User Page - Demonstrates adding data to Firestore
class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _cityController = TextEditingController();
  final _hobbyController = TextEditingController();

  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = false;
  String _selectedMethod = 'Auto-Generated ID';
  bool _isActive = true;
  final List<String> _hobbies = [];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _cityController.dispose();
    _hobbyController.dispose();
    super.dispose();
  }

  Future<void> _addUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = UserModel(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        age: int.parse(_ageController.text.trim()),
        city: _cityController.text.trim(),
        isActive: _isActive,
        hobbies: _hobbies,
        createdAt: DateTime.now(),
      );

      if (_selectedMethod == 'Auto-Generated ID') {
        final userId = await _firestoreService.addUser(user);
        if (mounted) {
          _showSuccessMessage('User added with ID: $userId');
        }
      } else if (_selectedMethod == 'Custom ID') {
        final customId = 'user_${DateTime.now().millisecondsSinceEpoch}';
        await _firestoreService.addUserWithCustomId(customId, user);
        if (mounted) {
          _showSuccessMessage('User added with custom ID: $customId');
        }
      } else if (_selectedMethod == 'Set with Merge') {
        final customId = 'user_${DateTime.now().millisecondsSinceEpoch}';
        await _firestoreService.setUserWithMerge(customId, user);
        if (mounted) {
          _showSuccessMessage('User set with merge: $customId');
        }
      }

      // Clear form
      _nameController.clear();
      _emailController.clear();
      _ageController.clear();
      _cityController.clear();
      _hobbyController.clear();
      _hobbies.clear();
    } catch (e) {
      if (mounted) {
        _showErrorMessage('Error: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _addHobby() {
    final hobby = _hobbyController.text.trim();
    if (hobby.isNotEmpty && !_hobbies.contains(hobby)) {
      setState(() {
        _hobbies.add(hobby);
        _hobbyController.clear();
      });
    }
  }

  void _removeHobby(String hobby) {
    setState(() {
      _hobbies.remove(hobby);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User to Firestore'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add Method',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedMethod,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Auto-Generated ID',
                            child: Text('Auto-Generated ID (add)'),
                          ),
                          DropdownMenuItem(
                            value: 'Custom ID',
                            child: Text('Custom ID (set)'),
                          ),
                          DropdownMenuItem(
                            value: 'Set with Merge',
                            child: Text('Set with Merge'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedMethod = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _selectedMethod == 'Auto-Generated ID'
                            ? 'Creates a new document with auto-generated ID'
                            : _selectedMethod == 'Custom ID'
                            ? 'Creates/overwrites document with custom ID'
                            : 'Creates or updates document (merges data)',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Age *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.cake),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an age';
                  }
                  final age = int.tryParse(value);
                  if (age == null || age < 1 || age > 150) {
                    return 'Please enter a valid age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'City *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_city),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a city';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Active User'),
                subtitle: const Text('Is this user active?'),
                value: _isActive,
                onChanged: (value) {
                  setState(() {
                    _isActive = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hobbies',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _hobbyController,
                              decoration: const InputDecoration(
                                labelText: 'Add hobby',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              onFieldSubmitted: (_) => _addHobby(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: _addHobby,
                            icon: const Icon(Icons.add),
                            color: Colors.blue,
                          ),
                        ],
                      ),
                      if (_hobbies.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _hobbies.map((hobby) {
                            return Chip(
                              label: Text(hobby),
                              onDeleted: () => _removeHobby(hobby),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _addUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Text(
                  'Add User to Firestore',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
