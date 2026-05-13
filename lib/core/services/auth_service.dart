import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/address_model.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  static const _keyRole = 'user_role';

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign In
  Future<UserCredential> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch and save role
      await _syncUserRole(credential.user?.uid);

      return credential;
    } catch (e) {
      rethrow;
    }
  }

  // Sign Up
  Future<UserCredential> signUp(
    String email,
    String password,
    String name, {
    String role = 'customer',
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user document in Firestore
      await _firestore.collection('users').doc(credential.user?.uid).set({
        'uid': credential.user?.uid,
        'email': email,
        'name': name,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await saveUserRole(role);
      return credential;
    } catch (e) {
      rethrow;
    }
  }

  // Sync role from Firestore to local storage
  Future<void> _syncUserRole(String? uid) async {
    if (uid == null) return;

    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      final role = doc.data()?['role'] as String? ?? 'customer';
      await saveUserRole(role);
    }
  }

  Future<void> saveUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyRole, role);
  }

  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRole);
  }

  Future<void> logout() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyRole);
  }

  Future<Map<String, dynamic>?> getUserDetails(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data();
  }

  Stream<Map<String, dynamic>?> getUserDetailsStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) => doc.data());
  }

  Future<void> updateUserDetails(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);
  }

  // ── Address Management ──────────────────────────────────────────────────
  Stream<List<AddressModel>> getAddressesStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => AddressModel.fromFirestore(doc.data(), doc.id))
              .toList(),
        );
  }

  Stream<AddressModel?> getDefaultAddressStream(String uid) {
    return getAddressesStream(uid).map((addresses) {
      if (addresses.isEmpty) return null;
      return addresses
          .where((a) => a.isDefault)
          .cast<AddressModel?>()
          .firstWhere((a) => a != null, orElse: () => addresses.first);
    });
  }

  Future<AddressModel?> getDefaultAddress(String uid) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .get();
    final addresses = snapshot.docs
        .map((doc) => AddressModel.fromFirestore(doc.data(), doc.id))
        .toList();
    if (addresses.isEmpty) return null;
    return addresses
        .where((a) => a.isDefault)
        .cast<AddressModel?>()
        .firstWhere((a) => a != null, orElse: () => addresses.first);
  }

  Future<void> addAddress(String uid, AddressModel address) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .add(address.toFirestore());
  }

  Future<void> deleteAddress(String uid, String addressId) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('addresses')
        .doc(addressId)
        .delete();
  }

  Future<void> setDefaultAddress(String uid, String addressId) async {
    final batch = _firestore.batch();
    final col = _firestore.collection('users').doc(uid).collection('addresses');
    final all = await col.get();

    for (var doc in all.docs) {
      batch.update(doc.reference, {'isDefault': doc.id == addressId});
    }

    await batch.commit();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
