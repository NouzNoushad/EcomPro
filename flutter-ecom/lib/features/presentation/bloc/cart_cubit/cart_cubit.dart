import 'package:bloc/bloc.dart';
import 'package:ecom_pro/features/models/cart_item.dart';
import 'package:flutter/material.dart';

import '../../../../core/api/end_points.dart';
import '../../../../core/utils/constants.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState());

  // add to cart
  void addToCart({
    required BuildContext context,
  }) async {
    String url = '${EndPoints.baseUrl}/${EndPoints.cart}';

    // CartModel cartModel = CartModel(userID: userID, cartItems: cartItems);

    // logger(
    //     '//////////// user name: ${userModel.name}, email: ${userModel.email}, phone: ${userModel.phone}, pass: ${userModel.password}, imgPath: ${userModel.image?.imagePath}, imgName: ${userModel.image?.imageName},');

    // await BaseClient.createAccount(url, userModel);
  }
}
