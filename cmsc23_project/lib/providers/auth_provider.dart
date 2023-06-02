import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../api/firebase_auth_api.dart';
import '../models/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../api/firebase_todo_api.dart';
import '../models/user_model.dart';
import '../models/admin_model.dart';
import '../models/health_monitor_model.dart';

class AuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  late Stream<User?> uStream;
  User? userObj;

  // for managing user authentication using Firebase Authentication Service
  AuthProvider() {
    authService = FirebaseAuthAPI();
    fetchAuthentication();
  }

  // getter
  Stream<User?> get userStream => uStream;

  // fetching the user's authentication status and updating ustream
  void fetchAuthentication() {
    uStream = authService.getUser();

    notifyListeners();
  }

  // registering new users with firebase authentication
  Future<void> signUp(String email, String password, UserRecord temp) async {
    await authService.signUp(email, password, temp);
    notifyListeners();
  }

  // authenticating a user with firebase authentication
  Future<String> signIn(String email, String password) async {
    String err = await authService.signIn(email, password);
    notifyListeners();
    return err;
  }

  // signing out the currently authenticated user from firebase authentication
  Future<void> signOut() async {
    print('going to API');
    await authService.signOut();
    notifyListeners();
  }
}
