import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../../presentation/authentication/cubit/auth_cubit.dart';
import '../../presentation/authentication/cubit/auth_state.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import 'app_rgx.dart';
import 'app_text_button.dart';
import 'app_text_form_field.dart';

class EmailAndPassword extends StatefulWidget {
  final bool? isSignUpPage;
  final bool? isPasswordPage;
  final OAuthCredential? credential;

  const EmailAndPassword({
    super.key,
    this.isSignUpPage,
    this.isPasswordPage,
    this.credential,
  });

  @override
  EmailAndPasswordState createState() => EmailAndPasswordState();
}


class EmailAndPasswordState extends State<EmailAndPassword> {
  bool isObscureText = true;
  String _selectedUserType = 'student'; // Default to student for sign-up
  File? nationalIdImage; // For parent to upload national ID image in sign-up

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nationalIdController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController jobIdController = TextEditingController();
  final TextEditingController relationController = TextEditingController();
  List<String> selectedStudents = []; // Store selected students' IDs


  final formKey = GlobalKey<FormState>();
  final passwordFocusNode = FocusNode();
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.isSignUpPage == true) userTypeDropdown(),
          if (widget.isSignUpPage == true) Gap(15.h),
          emailField(),
          Gap(15.h),
          passwordField(),
          if (widget.isSignUpPage == true) ...[
            Gap(15.h),
            nameField(),
            if (_selectedUserType == 'student') ...[
              Gap(15.h),
              nationalIdField(),
              Gap(15.h),
              studentIdField(),
            ],
            if (_selectedUserType == 'teacher') ...[
              Gap(15.h),
              jobIdField(),
            ],
            if (_selectedUserType == 'parent') ...[
              Gap(15.h),
              nationalIdField(),
              Gap(15.h),
              relationField(),
              Gap(15.h),
              selectStudentDropdown(),
              Gap(15.h),
              nationalIdImagePicker(),
            ],
          ],
          Gap(40.h),
          loginOrSignUpOrPasswordButton(context),
          Gap(20.h),
        ],
      ),
    );
  }

  void _onUserTypeChanged(String? value) {
    setState(() {
      _selectedUserType = value!;
    });

    // Fetch students if the user type is "parent"
    if (_selectedUserType == 'parent') {
      context.read<AuthCubit>().fetchStudents();
    }
  }

  Widget userTypeDropdown() {
    return DropdownButtonFormField<String>(
      dropdownColor: Colors.white,
      style: TextStyles.font14Hint500Weight,
      value: _selectedUserType,
      items: const [
        DropdownMenuItem(value: 'student', child: Text("Student")),
        DropdownMenuItem(value: 'teacher', child: Text("Teacher")),
        DropdownMenuItem(value: 'parent', child: Text("Parent")),
      ],
      onChanged: _onUserTypeChanged, // Use the helper method
      decoration: InputDecoration(
        hintText: 'User Type',
        hintStyle: TextStyles.font14Hint500Weight,
        filled: true,
        fillColor: ColorsManager.textFieldFillColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 17.h),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorsManager.gray93Color,
            width: 1.3.w,
          ),
          borderRadius: BorderRadius.circular(7),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorsManager.mainBlue,
            width: 1.3.w,
          ),
          borderRadius: BorderRadius.circular(7),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorsManager.coralRed,
            width: 1.3.w,
          ),
          borderRadius: BorderRadius.circular(7.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorsManager.coralRed,
            width: 1.3.w,
          ),
          borderRadius: BorderRadius.circular(7.0),
        ),
        suffixIcon: const Icon(Icons.arrow_drop_down),
      ),
    );
  }

  // Multi-select dropdown for choosing students
  Widget selectStudentDropdown() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is StudentsFetched) {
          return MultiSelectDialogField(
            checkColor: Colors.white,
            chipDisplay: MultiSelectChipDisplay(
              height: 40.h,
              chipColor: Colors.blue,
              textStyle: const TextStyle(color: Colors.white),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(7),
              ),
              onTap: (value) {
                setState(() {
                  selectedStudents.remove(value);
                });
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            ),
            backgroundColor: ColorsManager.textFieldFillColor,
            items: state.students
                .map((student) => MultiSelectItem(student['email'], student['name']))
                .toList(),
            title: const Text("Select Students", style: TextStyle(color: Colors.black)),
            selectedColor: Colors.blue,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: Colors.blue, width: 1.3.w),
            ),
            buttonText: const Text(
              "Choose Students",
              style: TextStyle(color: Colors.blue),
            ),
            onConfirm: (values) {
              setState(() {
                selectedStudents = values.cast<String>();
              });
            },
          );
        } else if (state is AuthError) {
          return Text(state.message, style: const TextStyle(color: Colors.red));
        }
        return const SizedBox.shrink();
      },
    );
  }



  Widget nameField() {
    return AppTextFormField(
      hint: 'Name',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a name';
        }
        return null;
      },
      controller: nameController,
      keyboardType: TextInputType.text,
    );
  }

  Widget emailField() {
    return AppTextFormField(
      hint: 'Email',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter an email';
        }
        if (!AppRegex.isEmailValid(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget passwordField() {
    return AppTextFormField(
      keyboardType: TextInputType.text,
      hint: 'Password',
      controller: passwordController,
      focusNode: passwordFocusNode,
      isObscureText: isObscureText,
      suffixIcon: GestureDetector(
        onTap: () {
          setState(() {
            isObscureText = !isObscureText;
          });
        },
        child: Icon(
          isObscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty || value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget nationalIdField() {
    return AppTextFormField(
      hint: 'National ID',
      controller: nationalIdController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a national ID';
        }
        return null;
      },
      keyboardType: TextInputType.number,
    );
  }

  Widget studentIdField() {
    return AppTextFormField(
      hint: 'Student ID',
      controller: studentIdController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a student ID';
        }
        return null;
      },
      keyboardType: TextInputType.number,
    );
  }

  Widget jobIdField() {
    return AppTextFormField(
      hint: 'Job ID',
      controller: jobIdController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a job ID';
        }
        return null;
      },
      keyboardType: TextInputType.text,
    );
  }

  Widget relationField() {
    return AppTextFormField(
      hint: 'Relation with Student',
      controller: relationController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please specify your relation with the student';
        }
        return null;
      },
      keyboardType: TextInputType.text,
    );
  }

  Widget nationalIdImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Upload National ID Image"),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
              backgroundColor: Colors.green,
          ),
          onPressed: () async {
            final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
            if (pickedFile != null) {
              setState(() {
                nationalIdImage = File(pickedFile.path);
              });
            }
          },
          child: const Text("Choose File",style: TextStyle(color: Colors.white),),
        ),
        if (nationalIdImage != null) Text("File selected: ${nationalIdImage!.path}"),
      ],
    );
  }

  Widget loginOrSignUpOrPasswordButton(BuildContext context) {
    return widget.isSignUpPage == true ? signUpButton(context) : loginButton(context);
  }

  Widget loginButton(BuildContext context) {
    return AppTextButton(
      buttonText: "Sign In",
      textStyle: TextStyles.font16White600Weight,
      onPressed: () async {
        passwordFocusNode.unfocus();
        if (formKey.currentState!.validate()) {
          // Only email and password needed for login
          context.read<AuthCubit>().signInWithEmail(
            emailController.text.trim(),
            passwordController.text.trim(),
          );

        }
      },
    );
  }

  Widget signUpButton(BuildContext context) {
    return AppTextButton(
      buttonText: "Sign Up",
      textStyle: TextStyles.font16White600Weight,
      onPressed: () async {
        passwordFocusNode.unfocus();
        if (formKey.currentState!.validate()) {
          context.read<AuthCubit>().signUp(
            userType: _selectedUserType,
            name: nameController.text.trim(),
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
            nationalId: _selectedUserType == 'student' || _selectedUserType == 'parent'
                ? nationalIdController.text.trim()
                : null,
            studentId: _selectedUserType == 'student' ? studentIdController.text.trim() : null,
            jobId: _selectedUserType == 'teacher' ? jobIdController.text.trim() : null,
            relationWithStudent: _selectedUserType == 'parent' ? relationController.text.trim() : null,
            selectedStudent: _selectedUserType == 'parent'
                ? {'studentIds': selectedStudents}
                : null,
            nationalIdImage: nationalIdImage,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    nationalIdController.dispose();
    studentIdController.dispose();
    jobIdController.dispose();
    relationController.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }
}
