import 'dart:math';

import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/local_storage_service.dart';
import 'package:dashboard/config/router_config.dart';
import 'package:dashboard/feature/dashboard/data/remote/model/header_information.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import 'bloc/header_information_bloc.dart';

class HeaderInformationWidget extends StatefulWidget {
  final int width;

  const HeaderInformationWidget({super.key, required this.width});

  @override
  State<HeaderInformationWidget> createState() =>
      _HeaderInformationWidgetState();
}

class _HeaderInformationWidgetState extends State<HeaderInformationWidget> {
  @override
  void initState() {
    BlocProvider.of<HeaderInformationBloc>(context)
        .add(HeaderInformationEventGetData());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HeaderInformationBloc, HeaderInformationState>(
      listener: (context, state) {
        if (state is HeaderInformationError) {
          if (state.code == 403) {
            getIt.get<LocalStorageService>().logout();
            context.go(RoutePath.login.path);
          }
        }
      },
      builder: (context, state) {
        if (state is HeaderInformationLoading) {
          return _loading();
        } else if (state is HeaderInformationSuccess) {
          return _success(state.data);
        } else if (state is HeaderInformationError) {
          return _error(state.error);
        }
        return _error(null);
      },
    );
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
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor,
              blurRadius: 1,
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
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FittedBox(
                      child: Icon(icon),
                    ),
                  )),
            ),
            const SizedBox(width: 16),
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
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.labelSmall,
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
                              .labelSmall
                              ?.copyWith(
                                  color: isProfit ? Colors.green : Colors.red),
                        ),
                        Icon(
                          isProfit
                              ? Icons.arrow_drop_up_rounded
                              : Icons.arrow_drop_down_rounded,
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

  Widget _loading() {
    return Shimmer(
        gradient: LinearGradient(colors: [
          if (Theme.of(context).brightness == Brightness.dark) ...[
            const Color.fromRGBO(30, 47, 87, 1),
            const Color.fromRGBO(35, 52, 92, 1),
            const Color.fromRGBO(45, 62, 102, 1),
            const Color.fromRGBO(35, 52, 92, 1),
            const Color.fromRGBO(30, 47, 87, 1),
          ] else ...[
            const Color.fromRGBO(170, 170, 170, 1.0),
            const Color.fromRGBO(175, 175, 175, 1.0),
            const Color.fromRGBO(186, 186, 186, 1.0),
            const Color.fromRGBO(175, 175, 175, 1.0),
            const Color.fromRGBO(170, 170, 170, 1.0),
          ]
        ], stops: [
          0.0,
          0.40,
          0.5,
          0.60,
          1.0
        ]),
        period: const Duration(milliseconds: 1000),
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: min(4, widget.width ~/ 250),
          scrollDirection: Axis.vertical,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio:
              1 / (100 / (widget.width / min(4, widget.width ~/ 250))),
          padding: const EdgeInsets.all(16),
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ));
  }

  Widget _error(String? error) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor,
                blurRadius: 1,
                spreadRadius: 0.1,
              )
            ]),
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  error ?? "خطا در دریافت اطلاعات!",
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                SizedBox(height: 8),
                OutlinedButton(
                    onPressed: () {
                      BlocProvider.of<HeaderInformationBloc>(context)
                          .add(HeaderInformationEventGetData());
                    },
                    child: Text(
                      "تلاش مجدد",
                      style: Theme.of(context).textTheme.labelSmall,
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _success(HeaderInformation data) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: min(4, widget.width ~/ 250),
      scrollDirection: Axis.vertical,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio:
          1 / (100 / (widget.width / min(4, widget.width ~/ 250))),
      padding: const EdgeInsets.all(16),
      children: [
        informationCard(
            icon: CupertinoIcons.person_crop_circle_fill,
            title: (data.users ?? 0).toString(),
            subtitle: "کاربران",
            percent: (data.userRatio ?? 0.0).toString(),
            isProfit: (data.userRatio ?? 0) >= 0),
        informationCard(
            icon: CupertinoIcons.videocam_circle_fill,
            title: (data.movies ?? 0).toString(),
            subtitle: "فیلم و سریال",
            percent: (data.movieRatio ?? 0.0).toString(),
            isProfit: (data.movieRatio ?? 0) >= 0),
        informationCard(
            icon: Elusive.basket_circled,
            title: (data.vip ?? 0).toString(),
            subtitle: "مشترکین",
            percent: (data.vipRatio ?? 0.0).toString(),
            isProfit: (data.vipRatio ?? 0) >= 0),
        informationCard(
            icon: CupertinoIcons.money_dollar_circle_fill,
            title: (data.ads ?? 0).toString(),
            subtitle: "تبلیغات",
            percent: (data.adsRatio ?? 0.0).toString(),
            isProfit: (data.adsRatio ?? 0) >= 0),
      ],
    );
  }
}
