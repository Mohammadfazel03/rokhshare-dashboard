import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/linearicons_free_icons.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      int width = constraints.constrainWidth().round();
      int height = constraints.constrainHeight().round();
      return GridView.count(
        crossAxisCount: min(4, width ~/ 250),
        scrollDirection: Axis.vertical,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1 / (100 / (width / min(4, width ~/ 250))),
        padding: EdgeInsets.all(16),
        children: [
          informationCard(
              icon: CupertinoIcons.person_crop_circle_fill,
              title: "256K",
              subtitle: "کاربران",
          percent: "2.1",
          isProfit: true),
          informationCard(
              icon: CupertinoIcons.videocam_circle_fill,
              title: "1M",
              subtitle: "فیلم و سریال",
          percent: "0.0",
          isProfit: false),
          informationCard(
              icon: Elusive.basket_circled, title: "456", subtitle: "مشترکین",
            percent: "0.5",
            isProfit: false
          ),
          informationCard(
              icon: CupertinoIcons.money_dollar_circle_fill,
              title: "10",
              subtitle: "تبلیغات",
            percent: "5.0",
            isProfit: true
          ),
        ],
      );
    });
  }

  Widget informationCard(
      {required IconData icon,
      required String title,
      required String subtitle,
      String? percent,
      bool? isProfit}) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor,
              blurRadius: 5,
              spreadRadius: 0.1,
            )
          ]),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FittedBox(
                      child: Icon(icon),
                    ),
                  )),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (isProfit != null && percent != null) ...[
                        Text(
                          "${percent}%",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: isProfit ? Colors.green : Colors.red),
                        ),
                        Icon(
                          isProfit ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                          color: isProfit ? Colors.green : Colors.red,
                        )
                      ]
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
