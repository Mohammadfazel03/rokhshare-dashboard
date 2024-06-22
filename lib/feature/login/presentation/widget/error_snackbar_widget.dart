
import 'package:dashboard/config/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ErrorSnackBarWidget extends StatelessWidget {
  final String title;
  final String message;
  final ToastificationItem item;

  const ErrorSnackBarWidget({super.key,
    required this.item,
    required this.title,
    required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
      clipBehavior: Clip.hardEdge,
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: Colors.transparent,
        shape: LinearBorder.start(
          side: BorderSide(
            color: CustomColor.errorBadgeTextColor.getColor(context),
            width: 5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Text(title,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Text(message,
              style: Theme.of(context).textTheme.labelSmall),
            ),
            const SizedBox(height: 8),
            ToastTimerAnimationBuilder(
              item: item,
              builder: (context, value, _) {
                return LinearProgressIndicator(value: value);
              },
            )
          ],
        ),
      ),
    );
  }
}
