import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/authentication/cubit/auth_cubit.dart';
import '../theme/custom_text_style.dart';
import '../theme/theme_helper.dart';

class LoginDialog extends StatelessWidget {
  const LoginDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 8.0,
          child: const LoginDialogBody(),
        ),
      ),
    );
  }
}

class LoginDialogBody extends StatelessWidget {
  const LoginDialogBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 14.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'login_required',
            style: CustomTextStyles.titleLargeRegular,
          ),
          const SizedBox(height: 16.0),
          const Text(
            'You_need_to_log_in_to_continue',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () async{
                  await context.read<AuthCubit>().signOut();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    'log_in',
                    style: CustomTextStyles.titleSmallErrorContainer.copyWith(
                      color: appTheme.red500,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                },
                child: Text(
                  'not_now',
                  style: CustomTextStyles.titleSmallErrorContainer
                      .copyWith(color: appTheme.whiteA700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
