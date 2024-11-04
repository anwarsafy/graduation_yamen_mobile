import 'package:flutter/material.dart';

import '../../../core/theme/styles.dart';
import '../../../core/theme/theme_helper.dart';
import '../../sign_up_screen/sign_up_screen.dart';


class DoNotHaveAccountText extends StatelessWidget {
  const DoNotHaveAccountText({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const SignUpScreen(),
          ),
        );

      },
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Do not have an account?',
              style: TextStyles.font13White400Weight
                  .copyWith(color: appTheme.whiteA700),
            ),
            TextSpan(
              text: '  ',
              style: TextStyles.font13Grey400Weight
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyles.font13White400Weight.copyWith(
                  fontWeight: FontWeight.bold, color: appTheme.gradientShade4),
            ),
          ],
        ),
      ),
    );
  }
}
