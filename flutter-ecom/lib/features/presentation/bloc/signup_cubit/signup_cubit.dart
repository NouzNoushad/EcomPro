import 'package:bloc/bloc.dart';
import 'package:ecom_pro/core/helpers/image_picker.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/helpers/validator_helper.dart';
import '../../../../core/utils/constants.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupState(selectedImage: ''));

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  TextEditingController get nameController => _nameController;
  TextEditingController get emailController => _emailController;
  TextEditingController get phoneController => _phoneController;
  TextEditingController get passwordController => _passwordController;

  String _selectedImage = '';

   final ValidatorHelper _validatorHelper = ValidatorHelper();

  String? nameValidator(String? value) {
    return _validatorHelper.nameValidator(_nameController.text);
  }

  String? emailValidator(String? value) {
    return _validatorHelper.emailValidator(_emailController.text);
  }

  String? phoneValidator(String? value) {
    return _validatorHelper.phoneValidator(_phoneController.text);
  }

  String? passwordValidator(String? value) {
    return _validatorHelper.passwordValidator(_passwordController.text);
  }

  void onChangeSelectedImage({
    required BuildContext context,
    required ImageSource source,
  }) async {
    Navigator.pop(context);
    ImagePickerHelper imagePickerHelper = ImagePickerHelper();
    String path =
        await imagePickerHelper.imagePicker(context: context, source: source);
    logger('////////// camera path: $path');
    _selectedImage = path;
    emit(state.copyWith(selectedImage: _selectedImage));
  }
}
