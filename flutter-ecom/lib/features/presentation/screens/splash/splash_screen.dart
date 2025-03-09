import 'package:ecom_pro/core/utils/colors.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.primaryLightColor,
              child: Text(
                "EP",
                style: TextStyle(
                  fontSize: 25,
                  color: AppColors.whiteColor,
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              "Ecom Products",
              style: TextStyle(
                fontSize: 25,
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
