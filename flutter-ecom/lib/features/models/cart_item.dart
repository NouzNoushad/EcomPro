class CartModel {
  final String userID;
  final List<CartItemModel> cartItems;

  CartModel({
    required this.userID,
    required this.cartItems,
  });
}


class CartItemModel {
  final String productID;
  final double price;
  final double quantity;

  CartItemModel({
    required this.productID,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productID,
      'price': price,
      'quantity': quantity,
    };
  }
}