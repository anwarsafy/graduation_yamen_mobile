import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../core/widgets/login_and_signup_animated_form.dart';
import '../../core/theme/styles.dart';
import '../../core/theme/theme_helper.dart';
import '../authentication/cubit/auth_cubit.dart';
import '../authentication/cubit/auth_state.dart';
import 'widgets/do_not_have_account.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static Widget builder(BuildContext context) {
    return BlocProvider<AuthCubit>.value(
      value: context.read<AuthCubit>(),

      child: const LoginScreen(),
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
                    if (state is AuthLoading) {

                    } else if (state is AuthError) {
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
                    } else if (state is UserAuthenticatedWithType) {
                      await Future.delayed(const Duration(seconds: 2));
                      if (!context.mounted) return;

                      Navigator.of(context).pop();
                    }
                  },
                  builder: (context, state) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // _buildAppLogo(),
                        Gap(40.h),
                        Text(
                          "Sign In",
                          style: TextStyles.font14White400Weight,
                        ),
                        Gap(40.h),
                        const EmailAndPassword(),
                        Gap(26.h),
                        const Center(child:  DoNotHaveAccountText()),
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

// Widget _buildAppLogo() {
//   return CustomImageView(
//     color: appTheme.blueLightModeToWhite,
//     height: 100.sp,
//     // width: 100.sp,
//     imagePath: ImageConstant.imgPlusLogo,
//   );
// }
}