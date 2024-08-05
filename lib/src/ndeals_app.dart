import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ndeals/src/constants/theme.dart';
import 'package:ndeals/src/features/deals/presentation/deals_screen.dart';

class NDealsApp extends StatelessWidget {
  const NDealsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: AppDesign.size,
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'NDeals App',
          theme: ThemeData(useMaterial3: true),
          home: child,
        );
      },
      child: const DealsScreen(),
    );
  }
}
