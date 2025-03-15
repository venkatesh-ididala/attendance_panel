// // // import 'package:firebase_auth/firebase_auth.dart';

// // // class AuthService {
// // //   final FirebaseAuth _auth = FirebaseAuth.instance;

// // //   get user => null;

// // //   Future<User?> signIn(String email, String password) async {
// // //     try {
// // //       UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
// // //       return userCredential.user;
// // //     } catch (e) {
// // //       print(e);
// // //       return null;
// // //     }
// // //   }

// // //   Future<User?> register(String email, String password) async {
// // //     try {
// // //       UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
// // //       return userCredential.user;
// // //     } catch (e) {
// // //       print(e);
// // //       return null;
// // //     }
// // //   }

// // //   Future<void> signOut() async {
// // //     await _auth.signOut();
// // //   }
// // // }

// // // services/auth_service.dart
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';

// // class AuthService extends ChangeNotifier {
// //   final FirebaseAuth _auth = FirebaseAuth.instance;
// //   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// //   User? _user;
// //   String _role = '';

// //   AuthService() {
// //     _auth.authStateChanges().listen((User? user) async {
// //       _user = user;
// //       if (_user != null) {
// //         await _fetchUserRole();
// //       }
// //       notifyListeners();
// //     });
// //   }

// //   User? get user => _user;
// //   String get role => _role;

// //   Future<void> signIn(String email, String password) async {
// //     try {
// //       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
// //           email: email, password: password);
// //       _user = userCredential.user;
// //       await _fetchUserRole();
// //       notifyListeners();
// //     } catch (e) {
// //       print(e);
// //     }
// //   }

// //   Future<void> register(
// //       String name, String email, String password, String role) async {
// //     try {
// //       UserCredential userCredential = await _auth
// //           .createUserWithEmailAndPassword(email: email, password: password);
// //       _user = userCredential.user;
// //       await _firestore
// //           .collection('users')
// //           .doc(_user!.uid)
// //           .set({'name': name, 'email': email, 'role': role});
// //       _role = role;
// //       notifyListeners();
// //     } catch (e) {
// //       print(e);
// //     }
// //   }

// //   Future<void> signOut() async {
// //     await _auth.signOut();
// //     _user = null;
// //     _role = '';
// //     notifyListeners();
// //   }

// //   Future<void> _fetchUserRole() async {
// //     if (_user != null) {
// //       DocumentSnapshot userDoc =
// //           await _firestore.collection('users').doc(_user!.uid).get();
// //       _role = userDoc['role'] ?? '';
// //     }
// //   }
// // }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class AuthService extends ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   User? _user;
//   String _role = '';

//   AuthService() {
//     _auth.authStateChanges().listen((User? user) async {
//       _user = user;
//       if (_user != null) {
//         await _fetchUserRole();
//       }
//       notifyListeners();
//     });
//   }

//   User? get user => _user;
//   String get role => _role;

//   /// Sign in a user with email and password
//   Future<String?> signIn(String email, String password) async {
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
//       _user = userCredential.user;
//       await _fetchUserRole();
//       notifyListeners();
//       return null; // No error, success
//     } on FirebaseAuthException catch (e) {
//       return e.message; // Return error message
//     }
//   }

//   /// Register a new user and store their role
//   Future<String?> register(
//       String name, String email, String password, String role) async {
//     try {
//       UserCredential userCredential = await _auth
//           .createUserWithEmailAndPassword(email: email, password: password);
//       _user = userCredential.user;

//       await _firestore.collection('users').doc(_user!.uid).set({
//         'name': name,
//         'email': email,
//         'role': role,
//       });

//       _role = role;
//       notifyListeners();
//       return null; // No error, success
//     } on FirebaseAuthException catch (e) {
//       return e.message; // Return error message
//     }
//   }

//   /// Sign out the user and reset state
//   Future<void> signOut(BuildContext context) async {
//     try {
//       await _auth.signOut();
//       _user = null;
//       _role = '';
//       notifyListeners();

//       // Navigate to login screen after logout
//       if (context.mounted) {
//         Navigator.pushReplacementNamed(context, '/login');
//       }
//     } catch (e) {
//       print("Error signing out: $e");
//     }
//   }

//   /// Fetch user role from Firestore
//   Future<void> _fetchUserRole() async {
//     if (_user != null) {
//       DocumentSnapshot userDoc =
//           await _firestore.collection('users').doc(_user!.uid).get();
//       _role = userDoc['role'] ?? '';
//     }
//   }
// }

//-------------------------------------------------------------------------------->
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class AuthService extends ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   User? _user;
//   String _role = '';

//   AuthService() {
//     _auth.authStateChanges().listen((User? user) async {
//       _user = user;
//       if (_user != null) {
//         await _fetchUserRole();
//       }
//       notifyListeners();
//     });
//   }

//   User? get user => _user;
//   String get role => _role;

//   Future<void> signIn(String email, String password) async {
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
//       _user = userCredential.user;
//       await _fetchUserRole();
//       notifyListeners();
//     } catch (e) {
//       print("Sign-in error: $e");
//     }
//   }

//   Future<void> register(
//       String name, String email, String password, String role) async {
//     try {
//       UserCredential userCredential = await _auth
//           .createUserWithEmailAndPassword(email: email, password: password);
//       _user = userCredential.user;
//       await _firestore
//           .collection('users')
//           .doc(_user!.uid)
//           .set({'name': name, 'email': email, 'role': role});
//       _role = role;
//       notifyListeners();
//     } catch (e) {
//       print("Registration error: $e");
//     }
//   }

//   Future<void> signOut(BuildContext context) async {
//     try {
//       await _auth.signOut();
//       _user = null;
//       _role = '';
//       notifyListeners();

//       // Ensure navigation after logout
//       if (context.mounted) {
//         Future.delayed(Duration.zero, () {
//           Navigator.pushReplacementNamed(context, '/login');
//         });
//       }
//     } catch (e) {
//       print("Sign-out error: $e");
//     }
//   }

//   Future<void> _fetchUserRole() async {
//     if (_user != null) {
//       DocumentSnapshot userDoc =
//           await _firestore.collection('users').doc(_user!.uid).get();
//       _role = userDoc['role'] ?? '';
//     }
//   }
// }

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class AuthService extends ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   User? _user;
//   String _role = '';

//   AuthService() {
//     _auth.authStateChanges().listen((User? user) async {
//       _user = user;
//       if (_user != null) {
//         await _fetchUserRole();
//       }
//       notifyListeners();
//     });
//   }

//   User? get user => _user;
//   String get role => _role;

//   Future<void> signIn(String email, String password) async {
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//           email: email, password: password);
//       _user = userCredential.user;
//       await _fetchUserRole();
//       notifyListeners();
//     } catch (e) {
//       print("Sign-in error: $e");
//     }
//   }

//   Future<void> register(
//       String name, String email, String password, String role) async {
//     try {
//       UserCredential userCredential = await _auth
//           .createUserWithEmailAndPassword(email: email, password: password);
//       _user = userCredential.user;
//       await _firestore
//           .collection('users')
//           .doc(_user!.uid)
//           .set({'name': name, 'email': email, 'role': role});
//       _role = role;
//       notifyListeners();
//     } catch (e) {
//       print("Registration error: $e");
//     }
//   }

//   Future<void> signOut(BuildContext context) async {
//     try {
//       await _auth.signOut();
//       _user = null;
//       _role = '';
//       notifyListeners();

//       if (context.mounted) {
//         Future.delayed(Duration.zero, () {
//           Navigator.pushReplacementNamed(context, '/login');
//         });
//       }
//     } catch (e) {
//       print("Sign-out error: $e");
//     }
//   }

//   Future<void> resetPassword(String email) async {
//     try {
//       await _auth.sendPasswordResetEmail(email: email);
//       print("Password reset email sent successfully.");
//     } catch (e) {
//       print("Error sending password reset email: $e");
//     }
//   }

//   Future<void> _fetchUserRole() async {
//     if (_user != null) {
//       DocumentSnapshot userDoc =
//           await _firestore.collection('users').doc(_user!.uid).get();
//       _role = userDoc['role'] ?? '';
//     }
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  String _role = '';

  AuthService() {
    _auth.authStateChanges().listen((User? user) async {
      _user = user;
      if (_user != null) {
        await _fetchUserRole();
      }
      notifyListeners();
    });
  }

  User? get user => _user;
  String get role => _role;

  Future<void> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      await _fetchUserRole();
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw _getAuthErrorMessage(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  Future<void> register(
      String name, String email, String password, String role) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      _user = userCredential.user;
      await _firestore
          .collection('users')
          .doc(_user!.uid)
          .set({'name': name, 'email': email, 'role': role});
      _role = role;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw _getAuthErrorMessage(e);
    } catch (e) {
      throw 'Registration failed. Please try again.';
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      _user = null;
      _role = '';
      notifyListeners();

      if (context.mounted) {
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacementNamed(context, '/login');
        });
      }
    } catch (e) {
      throw 'Sign-out failed. Please try again.';
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _getAuthErrorMessage(e);
    } catch (e) {
      throw 'Failed to send password reset email. Try again.';
    }
  }

  Future<void> _fetchUserRole() async {
    if (_user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(_user!.uid).get();
      _role = userDoc['role'] ?? '';
    }
  }

  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return '❌ Invalid email format. Please enter a valid email address.';
      case 'user-not-found':
        return '⚠️ No account found with this email. Please register or try again.';
      case 'wrong-password':
        return '🔒 Incorrect password. Please try again.';
      case 'email-already-in-use':
        return '📩 This email is already registered. Try signing in instead.';
      case 'weak-password':
        return '⚠️ Your password is too weak. Please use at least 6 characters.';
      case 'network-request-failed':
        return '🌐 Network error. Please check your connection and try again.';
      case 'too-many-requests':
        return '🚨 Too many login attempts. Please wait a moment and try again.';
      default:
        return '❗ Authentication error: ${e.message ?? 'Unknown error occurred.'}';
    }
  }
}
