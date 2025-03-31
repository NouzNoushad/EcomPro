import 'package:ecom_pro/features/presentation/screens/cart/components/cart_item.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/colors.dart';
import 'components/cart_total.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
        title: Text('Cart'),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
              child: ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  itemBuilder: (context, index) {
                    return CartItem();
                  },
                  separatorBuilder: (context, index) => SizedBox(
                        height: 8,
                      ),
                  itemCount: 5)),
          CartTotal(),
        ],
      )),
    );
  }
}
