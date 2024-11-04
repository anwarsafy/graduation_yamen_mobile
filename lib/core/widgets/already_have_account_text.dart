import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../presentation/sign_in_screen/sign_in_screen.dart';
import '../theme/styles.dart';
import '../theme/theme_helper.dart';

class AlreadyHaveAccountText extends StatelessWidget {
  const AlreadyHaveAccountText({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);

      },
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Already have an account? ',
              style: TextStyles.font11White400Weight
                  .copyWith(color: appTheme.whiteA700),
            ),
            TextSpan(
              text: '  ',
              style: TextStyles.font11DarkBlue400Weight,
            ),
            TextSpan(
              text: 'Sign In',
              style: TextStyles.font13Grey400Weight.copyWith(
                  color: appTheme.gradientShade4,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
