import 'package:firebase_auth/firebase_auth.dart';

/// Service class that manages user authentication using [FirebaseAuth].
///
/// It provides essential methods for identity management, allowing users to
/// create new accounts and access existing ones via email and password.
class AuthService {
  /// Instance of [FirebaseAuth] to handle the communication with Firebase.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Registers a new user with the provided [email], [password], and [name].
  ///
  /// This method creates a new entry in the Firebase Authentication database.
  /// If successful, it also updates the user's [displayName] with the
  /// provided name.
  ///
  /// Returns a [User] object if the account is created successfully,
  /// or `null` if the process fails (e.g., email already in use).
  Future<User?> registerWithEmail(
    String email,
    String password,
    String name,
  ) async {
    try {
      // Create user credentials in Firebase
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      // Persist the user's display name in their Firebase profile
      await user?.updateDisplayName(name);
      return user;
    } catch (e) {
      // Internal error tracking
      print("Error during registration: ${e.toString()}");
      return null;
    }
  }

  /// Authenticates an existing user using their [email] and [password].
  ///
  /// It verifies the credentials against the Firebase Authentication database.
  ///
  /// Returns the authenticated [User] if successful,
  /// or `null` if the login fails (e.g., wrong password or non-existent user).
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      // Authenticate with Firebase
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      // Internal error tracking
      print("Error during login: ${e.toString()}");
      return null;
    }
  }
}
