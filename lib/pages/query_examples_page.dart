import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

/// Query Examples Page - Demonstrates various Firestore queries
class QueryExamplesPage extends StatefulWidget {
  const QueryExamplesPage({super.key});

  @override
  State<QueryExamplesPage> createState() => _QueryExamplesPageState();
}

class _QueryExamplesPageState extends State<QueryExamplesPage> {
  final FirestoreService _firestoreService = FirestoreService();
  List<UserModel> _results = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedQuery = 'All Users';

  final Map<String, String> _queryDescriptions = {
    'All Users': 'Get all users from the collection',
    'By Age': 'Get users with specific age (isEqualTo)',
    'Age Range': 'Get users within age range (isGreaterThanOrEqualTo, isLessThanOrEqualTo)',
    'By City': 'Get users from a specific city',
    'Active Users': 'Get only active users (isEqualTo: true)',
    'With Limit': 'Get limited number of users',
    'Ordered by Age': 'Get users ordered by age (descending)',
    'By Hobby': 'Get users who have a specific hobby (arrayContains)',
  };

  Future<void> _executeQuery(String queryType) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _selectedQuery = queryType;
    });

    try {
      List<UserModel> results = [];

      switch (queryType) {
        case 'All Users':
          results = await _firestoreService.getAllUsers();
          break;
        case 'By Age':
          results = await _firestoreService.getUsersByAge(25);
          break;
        case 'Age Range':
          results = await _firestoreService.getUsersByAgeRange(20, 40);
          break;
        case 'By City':
          results = await _firestoreService.getUsersByCity('New York');
          break;
        case 'Active Users':
          results = await _firestoreService.getActiveUsers();
          break;
        case 'With Limit':
          results = await _firestoreService.getUsersWithLimit(5);
          break;
        case 'Ordered by Age':
          results = await _firestoreService.getUsersOrderedByAge(limit: 10);
          break;
        case 'By Hobby':
          results = await _firestoreService.getUsersByHobby('reading');
          break;
      }

      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Query Examples'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Row(
        children: [
          // Sidebar with query options
          Container(
            width: 300,
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Available Queries',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _queryDescriptions.length,
                    itemBuilder: (context, index) {
                      final queryType = _queryDescriptions.keys.elementAt(index);
                      final isSelected = _selectedQuery == queryType;
                      return InkWell(
                        onTap: () => _executeQuery(queryType),
                        child: Container(
                          color: isSelected ? Colors.orange[100] : null,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                queryType,
                                style: TextStyle(
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected ? Colors.orange[900] : null,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _queryDescriptions[queryType]!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Results area
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Error executing query',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _executeQuery(_selectedQuery),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.orange[50],
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedQuery,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _queryDescriptions[_selectedQuery]!,
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Chip(
                        label: Text('${_results.length} results'),
                        backgroundColor: Colors.orange[200],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _results.isEmpty
                      ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No results found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                      : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _results.length,
                    itemBuilder: (context, index) {
                      final user = _results[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.orange,
                            child: Text(
                              user.name[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          title: Text(
                            user.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text('Email: ${user.email}'),
                              Text('Age: ${user.age}'),
                              Text('City: ${user.city}'),
                              Text(
                                'Active: ${user.isActive ? "Yes" : "No"}',
                              ),
                            ],
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
