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

  // Check if user is admin
  Future<bool> isUserAdmin() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return false;

      final response = await supabase
          .from('user_roles')
          .select('role')
          .eq('user_id', userId)
          .single();
      return response['role'] == 'admin';
    } catch (e) {
      return false;
    }
  }

  // Get user role
  Future<String> getUserRole() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return 'user';

      final response = await supabase
          .from('user_roles')
          .select('role')
          .eq('user_id', userId)
          .single();
      return response['role'] ?? 'user';
    } catch (e) {
      return 'user';
    }
  }

  // Stream to check if current user is admin
  Stream<bool> isCurrentUserAdmin() async* {
    final user = currentUser;
    if (user == null) {
      yield false;
      return;
    }

    // Initial check
    yield await isUserAdmin();

    // Listen to auth state changes
    await for (final state in authStateChanges) {
      if (state.session?.user != null) {
        yield await isUserAdmin();
      } else {
        yield false;
      }
    }
  }
}
