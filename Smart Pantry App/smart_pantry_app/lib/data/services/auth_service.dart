import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Registro con correo y contraseña
  Future<User?> registerWithEmail(
    String email,
    String password,
    String name,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      // Actualizar el nombre del usuario en Firebase
      await user?.updateDisplayName(name);
      return user;
    } catch (e) {
      print("Error en registro: ${e.toString()}");
      return null;
    }
  }

  // Inicio de sesión
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print("Error en login: ${e.toString()}");
      return null;
    }
  }
}
