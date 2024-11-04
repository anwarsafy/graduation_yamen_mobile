import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../core/pref_utils.dart';
import 'auth_state.dart';


class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  AuthCubit() : super(AuthInitial());

/// Sign in with email and password
  Future<void> signInWithEmail(String email, String password) async {
    emit(AuthLoading());
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Emit UserAuthenticated state with the current user
      emit(UserAuthenticated(userCredential.user!));
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'lbl_user_not_found';
          break;
        case 'wrong-password':
          errorMessage = 'lbl_wrong_password';
          break;
        case 'invalid-email':
          errorMessage = 'lbl_invalid_email';
          break;
        case 'user-disabled':
          errorMessage = 'lbl_user_disabled';
          break;
        case 'too-many-requests':
          errorMessage = 'lbl_too_many_requests';
          break;
        default:
          errorMessage = e.message ?? 'lbl_unknown_error';
          break;
      }
      emit(AuthError(errorMessage));
    }
  }
/// Sign out
  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      await _auth.signOut().then((value) async{
        await PrefUtils().setIsUserLogin(false);
      },);
      // await _auth.signOut().then(
      //       (value)
      //       async{
      //         await PrefUtils().setIsUserLogin(false);
      //         await NavigatorService.pushNamedAndRemoveUntil(AppRoutes.signInScreen);
      //       },
      // );
      emit(UserSignedOut());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'An unknown error occurred. Please try again later.'));
    } catch (e) {
      emit(AuthError('An unknown error occurred. Please try again later.'));
    }
  }
/// Sign up
  Future<void> signUp({
    required String userType,
    required String name,
    required String email,
    required String password,
    String? nationalId,
    String? studentId,
    String? jobId,
    String? relationWithStudent,
    Map<String, dynamic>? selectedStudent,
    File? nationalIdImage,
  }) async {
    emit(AuthLoading());
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      await user!.updateDisplayName(name);

      // Upload national ID image for parents if provided
      String? nationalIdImageUrl;
      if (userType == 'parent' && nationalIdImage != null) {
        nationalIdImageUrl = await _uploadNationalIdImage(user.uid, nationalIdImage);
      }

      // Set up user data based on the type
      Map<String, dynamic> userData = {
        'userType': userType,
        'name': name,
        'email': email,
        'userId': user.uid,
      };

      if (userType == 'student') {
        userData.addAll({
          'nationalId': nationalId,
          'studentId': studentId,
        });
      } else if (userType == 'teacher') {
        userData.addAll({
          'jobId': jobId,
        });
      } else if (userType == 'parent') {
        userData.addAll({
          'nationalId': nationalId,
          'relationWithStudent': relationWithStudent,
          'selectedStudent': selectedStudent,
          'nationalIdImageUrl': nationalIdImageUrl,
        });
      }

      // Save user data to Firestore
      await _firestore.collection('users').doc(user.uid).set(userData);
      // Emit UserAuthenticated state with the newly created user
      emit(UserAuthenticated(user));
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'email-already-in-use') {
        errorMessage = 'lbl_email_already_in_use';
      } else {
        errorMessage = e.message ?? 'lbl_unknown_error';
      }
      emit(AuthError(errorMessage));
    } catch (e) {
      emit(AuthError('lbl_unknown_error'));
    }
  }
/// Upload national ID image
  Future<String> _uploadNationalIdImage(String userId, File imageFile) async {
    try {
      TaskSnapshot snapshot = await _storage
          .ref('nationalIdImages/$userId')
          .putFile(imageFile);
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload national ID image');
    }
  }

  /// Fetch user type
  Future<void> fetchUserType(User user) async {
    emit(AuthLoading());
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      String userType = userDoc['userType'];
      emit(UserAuthenticatedWithType(user, userType));
    } catch (e) {
      emit(AuthError('Failed to fetch user type'));
    }
  }

  /// Fetch Students
  Future<void> fetchStudents() async {
    emit(AuthLoading());
    try {
      QuerySnapshot studentsSnapshot = await _firestore.collection('users').where('userType', isEqualTo: 'student').get();
      List<Map<String, dynamic>> students = studentsSnapshot.docs.map((doc) => {
        'email': doc['email'],
        'name': doc['name']
      }).toList();
      emit(StudentsFetched(students));
    } catch (e) {
      emit(AuthError('Failed to fetch students'));
    }
  }


}
