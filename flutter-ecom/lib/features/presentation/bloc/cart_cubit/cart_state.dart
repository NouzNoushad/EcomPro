part of 'cart_cubit.dart';

class CartState {
  CartState({
    required this.cartItems,
  });

  final List<CartItemModel> cartItems;

  CartState copyWith({
    List<CartItemModel>? cartItems,
  }){
    return CartState(
      cartItems: cartItems ?? this.cartItems,
    );
  }
}
