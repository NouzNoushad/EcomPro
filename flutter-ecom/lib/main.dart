import 'package:ecom_pro/config/routes/app_constants.dart';
import 'package:ecom_pro/config/routes/app_routes.dart';
import 'package:ecom_pro/config/theme/app_theme.dart';
import 'package:ecom_pro/core/utils/strings.dart';
import 'package:ecom_pro/features/presentation/bloc/bloc_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocWidget(
      child: MaterialApp(
        title: AppStrings.appName,
        theme: AppTheme.theme,
        debugShowCheckedModeBanner: false,
        initialRoute: RouteConstants.homeScreen,
        onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
