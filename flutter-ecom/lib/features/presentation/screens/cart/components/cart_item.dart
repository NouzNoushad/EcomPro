import 'package:ecom_pro/features/models/response/get_carts.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/colors.dart';

class CartItem extends StatefulWidget {
  const CartItem({super.key, required this.cart});
  final Cart? cart;

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 8,
          top: 8,
          child: GestureDetector(
              onTap: () {},
              child: CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.primaryColor,
                child: Icon(
                  Icons.close,
                  size: 20,
                  color: AppColors.whiteColor,
                ),
              )),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(),
          ),
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              SizedBox(
                height: 100,
                width: 100,
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Product One",
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Electronics',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '\$40.0',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
