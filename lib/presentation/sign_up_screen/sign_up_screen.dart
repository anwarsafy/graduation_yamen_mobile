
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../core/widgets/already_have_account_text.dart';

import '../../core/theme/styles.dart';
import '../../core/theme/theme_helper.dart';
import '../../core/widgets/login_and_signup_animated_form.dart';

import '../authentication/cubit/auth_cubit.dart';
import '../authentication/cubit/auth_state.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  static Widget builder(BuildContext context) {
    return BlocProvider<AuthCubit>.value(
      value: context.read<AuthCubit>()..fetchStudents(),
      child: const SignUpScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: appTheme.black,
          body: SafeArea(
            child: Container(
              height: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
              child: SingleChildScrollView(
                child: BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) async {
                  if (state is AuthError) {
                      Navigator.of(context).pop();
                      AwesomeDialog(
                        dialogBackgroundColor: appTheme.white,
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        titleTextStyle: TextStyle(color: appTheme.blueLightModeToBlack),
                        desc: state.message,
                        descTextStyle: TextStyle(color: appTheme.blueLightModeToBlack),
                      ).show();
                    } else if (state is UserSignIn) {
                      await Future.delayed(const Duration(seconds: 2));
                      if (!context.mounted) return;
                      // NavigatorService.pushNamedAndRemoveUntil(AppRoutes.homeScreen);
                    } else if (state is UserNotVerified) {
                      AwesomeDialog(
                        dialogBackgroundColor: appTheme.white,
                        titleTextStyle: TextStyle(color: appTheme.blueLightModeToBlack),
                        descTextStyle: TextStyle(color: appTheme.blueLightModeToBlack),
                        context: context,
                        dialogType: DialogType.info,
                        animType: AnimType.rightSlide,
                        title: 'Email Not Verified',
                        desc: 'Please check your email and verify your email.',
                      ).show();
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                            onTap: () {
                             Navigator.of(context).pop();
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: appTheme.blueLightModeToWhite,
                            )),
                        Gap(10.h),
                        Text(
                          "Sign Up",
                          style: TextStyles.font14White400Weight,
                        ),
                        Gap(8.h),
                        const EmailAndPassword(isSignUpPage: true),
                        Gap(40.h),
                        const Center(child: AlreadyHaveAccountText()),
                        Gap(10.h),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}