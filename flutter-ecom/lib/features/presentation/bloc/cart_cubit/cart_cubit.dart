import 'package:bloc/bloc.dart';
import 'package:ecom_pro/features/models/cart_item.dart';
import 'package:flutter/material.dart';

import '../../../../core/api/base_client.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/utils/constants.dart';
import '../../../models/response/get_carts.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit()
      : super(CartState(
          isStorageLoading: false,
          carts: [],
        ));

  List<Cart>? _carts = [];

  // add to cart
  void addToCart({
    required BuildContext context,
    required String productID,
    required double price,
    required int quantity,
  }) async {
    String url = '${EndPoints.baseUrl}/${EndPoints.cart}';

    CartModel cartModel =
        CartModel(productID: productID, price: price, quantity: quantity);

    logger(
        '//////////// cart product id: ${cartModel.productID}, price: ${cartModel.price}, quantity: ${cartModel.quantity},,');

    await BaseClient.addToCart(context, url, cartModel);
  }

  // get carts
  void getCarts() async {
    emit(state.copyWith(isStorageLoading: true));
    String url = "${EndPoints.baseUrl}/${EndPoints.cart}";
    var cartResponse = await BaseClient.getCarts(url);
    if (cartResponse != null) {
      _carts = cartResponse.data;

      emit(state.copyWith(isStorageLoading: false, carts: _carts));
    } else {
      emit(state.copyWith(isStorageLoading: false));
    }
  }
}
