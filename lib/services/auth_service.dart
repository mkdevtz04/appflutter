import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  // Get current user
  User? get currentUser => supabase.auth.currentUser;

  // Stream of auth changes
  Stream<AuthState> get authStateChanges => supabase.auth.onAuthStateChange;

  // Register with email and password
  Future<AuthResponse?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      );
      return response;
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('An error occurred during registration: $e');
    }
  }

  // Sign in with email and password
  Future<AuthResponse?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception('An error occurred during sign in: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  // Check if user is logged in
  bool isUserLoggedIn() {
    return supabase.auth.currentUser != null;
  }

  // Get user profile
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final response = await supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();
      return response;
    } catch (e) {
      return null;
    }
  }
}
