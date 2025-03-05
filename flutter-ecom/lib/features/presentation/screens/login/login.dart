import 'package:ecom_pro/core/utils/colors.dart';
import 'package:ecom_pro/core/utils/extensions.dart';
import 'package:ecom_pro/features/presentation/screens/signup/signup.dart';
import 'package:flutter/material.dart';

import '../../widgets/input_button.dart';
import '../../widgets/input_textfield.dart';
import '../../widgets/redirect_to.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InputTextFormField(
                hintText: 'Email',
                icon: Icons.email,
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
                message: 'Not a member yet',
                label: 'Sign up',
                onTap: () {
                  context.pushNavigation(SignupScreen());
                },
              ),
              SizedBox(
                height: 30,
              ),
              InputButton(
                label: 'Login',
                onPressed: () {},
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
