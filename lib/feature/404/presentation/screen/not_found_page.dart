import 'package:dashboard/config/router_config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class NotFoundPage extends StatefulWidget {
  const NotFoundPage({super.key});

  @override
  State<NotFoundPage> createState() => _NotFoundPageState();
}

class _NotFoundPageState extends State<NotFoundPage> {
  @override
  Widget build(BuildContext context) {
    int width = MediaQuery.of(context).size.width.round();
    int height = MediaQuery.of(context).size.height.round();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset("assets/lottie/not_found.json",
                repeat: true, width: width / 2, height: height / 2),
            Text(
              "صفحه مورد نظر یافت نشد.",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 4),
            Text(
              "برای مدیریت سایت و کاربران سایت، به صفحه اصلی بروید.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 16),
            OutlinedButton(
                onPressed: () {
                  context.go(RoutePath.dashboard.path);
                },
                child: Text(
                  "رفتن به صفجه اصلی",
                  style: Theme.of(context).textTheme.bodyMedium,
                ))
          ],
        ),
      ),
    );
  }
}
