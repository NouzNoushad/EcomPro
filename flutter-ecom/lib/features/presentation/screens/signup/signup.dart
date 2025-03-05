import 'package:ecom_pro/core/utils/colors.dart';
import 'package:ecom_pro/core/utils/extensions.dart';
import 'package:ecom_pro/features/presentation/screens/login/login.dart';
import 'package:flutter/material.dart';

import '../../widgets/input_button.dart';
import '../../widgets/input_textfield.dart';
import '../../widgets/redirect_to.dart';
import 'components/user_image.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: Column(
          children: [
            Spacer(),
            UserImage(),
            SizedBox(
              height: 20,
            ),
            InputTextFormField(
              hintText: 'Name',
              icon: Icons.person,
            ),
            SizedBox(
              height: 10,
            ),
            InputTextFormField(
              hintText: 'Email',
              icon: Icons.email,
            ),
            SizedBox(
              height: 10,
            ),
            InputTextFormField(
              hintText: 'Phone',
              icon: Icons.phone,
            ),
            SizedBox(
              height: 10,
            ),
            InputTextFormField(
              hintText: 'Password',
              icon: Icons.lock,
            ),
            SizedBox(
              height: 10,
            ),
            RedirectTo(
              message: 'Already have an account',
              label: 'Login',
              onTap: () {
                context.pushNavigation(LoginScreen());
              },
            ),
            Spacer(),
            InputButton(
              label: 'Sign up',
              onPressed: () {},
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
