import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../core/helpers/validator_helper.dart';

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
}
