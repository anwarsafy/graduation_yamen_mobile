// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_yamen_mobile/presentation/authentication/cubit/auth_cubit.dart';
import 'package:graduation_yamen_mobile/presentation/authentication/cubit/auth_state.dart';
import 'package:graduation_yamen_mobile/presentation/section_of_parent/main_screen/parent_screen.dart';
import 'package:graduation_yamen_mobile/presentation/section_of_students/main_screen/students_screen.dart';
import 'package:graduation_yamen_mobile/presentation/section_of_teacher/main_screen/teacher_screen.dart';
import 'package:graduation_yamen_mobile/presentation/sign_in_screen/sign_in_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Simple Auth App',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.light,
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthListener(),
          '/teacherHome': (context) => const TeacherHomeScreen(),
          '/studentHome': (context) => const StudentHomeScreen(),
          '/parentHome': (context) => const ParentHomeScreen(),
          '/login': (context) => const LoginScreen(),
        },
      ),
    );
  }
}

class AuthListener extends StatelessWidget {
  const AuthListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // Handle navigation based on user type
        if (state is UserAuthenticatedWithType) {
          // Use `Future.microtask` to prevent multiple rebuilds
          Future.microtask(() {
            if (state.userType == 'teacher') {
              Navigator.pushReplacementNamed(context, '/teacherHome');
            } else if (state.userType == 'student') {
              Navigator.pushReplacementNamed(context, '/studentHome');
            } else if (state.userType == 'parent') {
              Navigator.pushReplacementNamed(context, '/parentHome');
            }
          });
        } else if (state is UserSignedOut) {
          // Navigate to login screen on sign out
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              // User is logged in, check for user type
              if (context.read<AuthCubit>().state is! UserAuthenticatedWithType) {
                // User type is not fetched yet, show loading indicator
                context.read<AuthCubit>().fetchUserType(snapshot.data!);
                return const Center(child: CircularProgressIndicator());
              }
            } else {
              // No user is logged in, show the login screen
              return const LoginScreen();
            }
            return const Center(child: CircularProgressIndicator());
          },
        );
      },
    );
  }
}


