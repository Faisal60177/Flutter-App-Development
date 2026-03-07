import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
// Firestore Service - Handles all Firestore operations
// This service demonstrates best practices for Firestore queries

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionName = 'users';

  // ==================== ADD DATA ====================

  /// Add a new user with auto-generated ID
  Future<String> addUser(UserModel user) async {
    try {
      final docRef = await _firestore.collection(_collectionName).add({
        ...user.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      throw Exception('Error adding user: $e');
    }
  }

  /// Add a user with custom ID
  Future<void> addUserWithCustomId(String userId, UserModel user) async {
    try {
      await _firestore.collection(_collectionName).doc(userId).set({
        ...user.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error adding user with custom ID: $e');
    }
  }

  /// Update user (merge with existing data)
  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection(_collectionName).doc(userId).update({
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }

  /// Set user with merge option (create or update)
  ///
  /// DIFFERENCE BETWEEN set() WITH AND WITHOUT MERGE:
  ///
  /// 1. set() WITHOUT merge (like addUserWithCustomId):
  ///    - If document EXISTS: COMPLETELY REPLACES/OVERWRITES the entire document
  ///    - If document DOESN'T EXIST: Creates new document
  ///    - Example: Document has {name, email, age, city, createdAt}
  ///               You set() with {name, email}
  ///               Result: Document now ONLY has {name, email} - all other fields DELETED!
  ///
  /// 2. set() WITH merge: true (this method):
  ///    - If document EXISTS: MERGES new data with existing data (keeps other fields)
  ///    - If document DOESN'T EXIST: Creates new document
  ///    - Example: Document has {name, email, age, city, createdAt}
  ///               You set() with merge: {name, email}
  ///               Result: Document has {name, email, age, city, createdAt} - other fields PRESERVED!
  ///
  /// 3. update() (like updateUser method):
  ///    - Only works if document EXISTS (throws error if doesn't exist)
  ///    - Only updates specified fields, keeps others
  ///    - Cannot add new fields to nested objects easily
  ///
  /// WHEN TO USE EACH:
  /// - Use set() without merge: When you want to completely replace a document
  /// - Use set() with merge: When you want to create OR update (upsert pattern)
  /// - Use update(): When you're sure document exists and only want to update specific fields
  Future<void> setUserWithMerge(String userId, UserModel user) async {
    try {
      await _firestore.collection(_collectionName).doc(userId).set({
        ...user.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Error setting user with merge: $e');
    }
  }

  /// Delete a user
  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection(_collectionName).doc(userId).delete();
    } catch (e) {
      throw Exception('Error deleting user: $e');
    }
  }

  // ==================== FETCH DATA ====================

  /// Get a single user by ID
  Future<UserModel?> getUser(String userId) async {
    try {
      final doc = await _firestore
          .collection(_collectionName)
          .doc(userId)
          .get();
      if (doc.exists) {
        return UserModel.fromMap(doc.id, doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Error getting user: $e');
    }
  }

  /// Get all users
  Future<List<UserModel>> getAllUsers() async {
    try {
      final snapshot = await _firestore.collection(_collectionName).get();
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error getting all users: $e');
    }
  }

  /// Get users by age (equal to)
  Future<List<UserModel>> getUsersByAge(int age) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('age', isEqualTo: age)
          .get();
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error getting users by age: $e');
    }
  }

  /// Get users by age range
  Future<List<UserModel>> getUsersByAgeRange(int minAge, int maxAge) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('age', isGreaterThanOrEqualTo: minAge)
          .where('age', isLessThanOrEqualTo: maxAge)
          .get();
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error getting users by age range: $e');
    }
  }

  /// Get users by city
  Future<List<UserModel>> getUsersByCity(String city) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('city', isEqualTo: city)
          .get();
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error getting users by city: $e');
    }
  }

  /// Get active users only
  Future<List<UserModel>> getActiveUsers() async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('isActive', isEqualTo: true)
          .get();
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error getting active users: $e');
    }
  }

  /// Get users with limit
  Future<List<UserModel>> getUsersWithLimit(int limit) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .limit(limit)
          .get();
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error getting users with limit: $e');
    }
  }

  /// Get users ordered by age (descending)
  Future<List<UserModel>> getUsersOrderedByAge({int? limit}) async {
    try {
      Query query = _firestore
          .collection(_collectionName)
          .orderBy('age', descending: true);

      if (limit != null) {
        query = query.limit(limit);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map(
            (doc) =>
            UserModel.fromMap(doc.id, doc.data() as Map<String, dynamic>),
      )
          .toList();
    } catch (e) {
      throw Exception('Error getting users ordered by age: $e');
    }
  }

  /// Get users with multiple conditions (age and city)
  /// Note: This requires a composite index in Firestore
  Future<List<UserModel>> getUsersByAgeAndCity(int minAge, String city) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('age', isGreaterThanOrEqualTo: minAge)
          .where('city', isEqualTo: city)
          .get();
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error getting users by age and city: $e');
    }
  }

  /// Get users with array contains (hobbies)
  Future<List<UserModel>> getUsersByHobby(String hobby) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('hobbies', arrayContains: hobby)
          .get();
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error getting users by hobby: $e');
    }
  }

  // ==================== REAL-TIME UPDATES ====================

  /// Stream of a single user document
  Stream<UserModel?> streamUser(String userId) {
    return _firestore.collection(_collectionName).doc(userId).snapshots().map((
        doc,
        ) {
      if (doc.exists) {
        return UserModel.fromMap(doc.id, doc.data()!);
      }
      return null;
    });
  }

  /// Stream of all users
  Stream<List<UserModel>> streamAllUsers() {
    return _firestore
        .collection(_collectionName)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((doc) => UserModel.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }

  /// Stream of active users
  Stream<List<UserModel>> streamActiveUsers() {
    return _firestore
        .collection(_collectionName)
        .where('isActive', isEqualTo: true)
        .orderBy('age', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((doc) => UserModel.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }

  /// Stream of users ordered by age
  Stream<List<UserModel>> streamUsersOrderedByAge({int? limit}) {
    Query query = _firestore
        .collection(_collectionName)
        .orderBy('age', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map(
          (snapshot) => snapshot.docs
          .map(
            (doc) =>
            UserModel.fromMap(doc.id, doc.data() as Map<String, dynamic>),
      )
          .toList(),
    );
  }
}