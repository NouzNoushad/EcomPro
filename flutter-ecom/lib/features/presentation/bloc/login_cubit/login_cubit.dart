import 'package:bloc/bloc.dart';
import 'package:ecom_pro/core/utils/extensions.dart';
import 'package:ecom_pro/features/models/response/login_response.dart';
import 'package:ecom_pro/features/models/user_model.dart';
import 'package:ecom_pro/features/presentation/screens/home/home_screen.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/api/base_client.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/helpers/validator_helper.dart';
import '../../../../core/utils/constants.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState());

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;

  final ValidatorHelper _validatorHelper = ValidatorHelper();

  String? emailValidator(String? value) {
    return _validatorHelper.emailValidator(_emailController.text);
  }

  String? passwordValidator(String? value) {
    return _validatorHelper.passwordValidator(_passwordController.text);
  }

  // reset login
  void resetLogin() {
    _emailController.text = "";
    _passwordController.text = "";
  }

  // create account
  void loginAccount({
    required BuildContext context,
  }) async {
    String url = '${EndPoints.baseUrl}/${EndPoints.login}';

    LoginModel loginModel = LoginModel(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    logger(
        '//////////// login user  email: ${loginModel.email}, pass: ${loginModel.password}');

    LoginResponse? response = await BaseClient.loginAccount(url, loginModel);
    if (response != null) {
      if (!context.mounted) return;
      context.showToast(response.message ?? "");
      context.pushReplacementNavigation(HomeScreen());
      Future.delayed(Duration(seconds: 1), () {
        resetLogin();
      });
    }
  }
}
