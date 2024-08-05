import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  final String errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          errorMessage,
          style: TextStyle(fontSize: 15.sp),
        ),
        SizedBox(height: 10.h),
        ElevatedButton(
          onPressed: onRetry,
          child: Text(
            'Retry',
            style: TextStyle(fontSize: 15.sp),
          ),
        ),
      ],
    );
  }
}
