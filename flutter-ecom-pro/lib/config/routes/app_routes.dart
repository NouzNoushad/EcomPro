import 'package:flutter/material.dart';

import '../../core/utils/strings.dart';
import '../../features/presentation/screens/home/home_screen.dart';
import 'app_constants.dart';

class AppRoutes {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteConstants.homeScreen:
        return MaterialPageRoute(
            settings: const RouteSettings(name: RouteConstants.homeScreen),
            builder: (context) => const HomeScreen());
      default:
        return MaterialPageRoute(
            builder: (context) => const Scaffold(
                  body: Center(
                    child: Text(AppStrings.pageNotFound),
                  ),
                ));
    }
  }
}
