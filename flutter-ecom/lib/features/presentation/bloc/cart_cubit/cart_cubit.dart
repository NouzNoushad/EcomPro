import 'package:bloc/bloc.dart';
import 'package:ecom_pro/features/models/cart_item.dart';
import 'package:flutter/material.dart';

import '../../../../core/api/base_client.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/utils/constants.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit()
      : super(CartState(
          cartItems: [],
        ));

  final List<CartItemModel> _cartItems = [];

  // add cart item
  void addCartItem(CartItemModel cartItem) {
    _cartItems.add(cartItem);

    emit(state.copyWith(cartItems: _cartItems));
  }

  // add to cart
  void addToCart({
    required BuildContext context,
    required String userID,
  }) async {
    String url = '${EndPoints.baseUrl}/${EndPoints.cart}';

    CartModel cartModel = CartModel(userID: userID, cartItems: _cartItems);

    logger(
        '//////////// user id: ${cartModel.userID}, items: ${cartModel.cartItems},,');

    await BaseClient.addToCart(context, url, cartModel);
  }
}
