import 'package:firebase_auth/firebase_auth.dart';


abstract class AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class IsNewUserApple extends AuthState {}

class ResetPasswordSent extends AuthState {}

class UserNotVerified extends AuthState {}

class UserSignedOut extends AuthState {}

class UserSignIn extends AuthState {}

// Add this state
class UserAuthenticated extends AuthState {
  final User user;

  UserAuthenticated(this.user);
}
class UserAuthenticatedWithType extends AuthState {
  final User user;
  final String userType;

  UserAuthenticatedWithType(this.user, this.userType);
}
class StudentsFetched extends AuthState {
  final List<Map<String, dynamic>> students;
  StudentsFetched(this.students);
}