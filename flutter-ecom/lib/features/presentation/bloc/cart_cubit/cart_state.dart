part of 'cart_cubit.dart';

class CartState {
  CartState({
    required this.isStorageLoading,
    required this.carts,
  });

   final bool isStorageLoading;
  final List<Cart>? carts;

  CartState copyWith({
    bool? isStorageLoading,
    List<Cart>? carts,
  }) {
    return CartState(
      isStorageLoading: isStorageLoading ?? this.isStorageLoading,
      carts: carts ?? this.carts,
    );
  }
}
