import 'dart:math';

import 'package:dashboard/feature/dashboard/data/remote/model/header_information.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:shimmer/shimmer.dart';

import 'bloc/header_information_cubit.dart';

class HeaderInformationWidget extends StatelessWidget {
  final int width;

  const HeaderInformationWidget({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HeaderInformationCubit, HeaderInformationState>(
      builder: (context, state) {
        if (state is HeaderInformationLoading) {
          return _loadingSliver(context);
        } else if (state is HeaderInformationSuccess) {
          return _successSliver(state.data, context);
        } else if (state is HeaderInformationError) {
          return _errorSliver(state.error, context);
        }
        return _errorSliver(null, context);
      },
    );
  }

  Widget informationCard(
      {required IconData icon,
      required String title,
      required String subtitle,
      required BuildContext context,
      String? percent,
      bool? isProfit}) {
    return Card(
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
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FittedBox(
                      child: Icon(icon, color: Theme.of(context).colorScheme.primary),
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
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall,
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
                          "$percent%",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
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

  Widget informationCardSliver(
      {required IconData icon,
      required String title,
      required String subtitle,
      required BuildContext context,
      String? percent,
      bool? isProfit}) {
    return SliverToBoxAdapter(
      child: Card(
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
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        child: Icon(icon, color: Theme.of(context).colorScheme.primary),
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
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodySmall,
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
                            "$percent%",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
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
      ),
    );
  }

  Widget _loading(context) {
    return Shimmer(
        gradient: LinearGradient(colors: [
          if (Theme.of(context).brightness == Brightness.dark) ...[
            const Color.fromRGBO(28, 27, 30, 1),
            const Color.fromRGBO(30, 29, 33, 1),
            const Color.fromRGBO(36, 34, 38, 1),
            const Color.fromRGBO(30, 29, 33, 1),
            const Color.fromRGBO(28, 27, 30, 1),
          ] else ...[
            const Color.fromRGBO(246, 242, 247, 1.0),
            const Color.fromRGBO(241, 237, 242, 1.0),
            const Color.fromRGBO(231, 227, 232, 1.0),
            const Color.fromRGBO(241, 237, 242, 1.0),
            const Color.fromRGBO(246, 242, 247, 1.0),
          ]
        ], stops: const [
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
          crossAxisCount: min(4, width ~/ 250),
          scrollDirection: Axis.vertical,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1 / (100 / (width / min(4, width ~/ 250))),
          padding: const EdgeInsets.all(16),
          children: const [
            Card(),
            Card(),
            Card(),
            Card(),
          ],
        ));
  }

  Widget _error(String? error, context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                  const SizedBox(height: 8),
                  OutlinedButton(
                      onPressed: () {
                        BlocProvider.of<HeaderInformationCubit>(context)
                            .getData();
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
      ),
    );
  }

  Widget _success(HeaderInformation data, context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: min(4, width ~/ 250),
      scrollDirection: Axis.vertical,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1 / (100 / (width / min(4, width ~/ 250))),
      padding: const EdgeInsets.all(16),
      children: [
        informationCard(
            context: context,
            icon: CupertinoIcons.person_crop_circle_fill,
            title: (data.users ?? 0).toString(),
            subtitle: "کاربران",
            percent: (data.userRatio ?? 0.0).toString(),
            isProfit: (data.userRatio ?? 0) >= 0),
        informationCard(
            context: context,
            icon: CupertinoIcons.videocam_circle_fill,
            title: (data.movies ?? 0).toString(),
            subtitle: "فیلم و سریال",
            percent: (data.movieRatio ?? 0.0).toString(),
            isProfit: (data.movieRatio ?? 0) >= 0),
        informationCard(
            context: context,
            icon: Elusive.basket_circled,
            title: (data.vip ?? 0).toString(),
            subtitle: "مشترکین",
            percent: (data.vipRatio ?? 0.0).toString(),
            isProfit: (data.vipRatio ?? 0) >= 0),
        informationCard(
            context: context,
            icon: CupertinoIcons.money_dollar_circle_fill,
            title: (data.ads ?? 0).toString(),
            subtitle: "تبلیغات",
            percent: (data.adsRatio ?? 0.0).toString(),
            isProfit: (data.adsRatio ?? 0) >= 0),
      ],
    );
  }

  Widget _successSliver(HeaderInformation data, context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid.count(
          crossAxisCount: min(4, width ~/ 250),
          mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1 / (100 / (width / min(4, width ~/ 250))),
          children: [
          informationCard(
                context: context,
                icon: CupertinoIcons.person_crop_circle_fill,
              title: (data.users ?? 0).toString(),
              subtitle: "کاربران",
              percent: (data.userRatio ?? 0.0).toString(),
              isProfit: (data.userRatio ?? 0) >= 0),
          informationCard(
                context: context,
                icon: CupertinoIcons.videocam_circle_fill,
              title: (data.movies ?? 0).toString(),
              subtitle: "فیلم و سریال",
              percent: (data.movieRatio ?? 0.0).toString(),
              isProfit: (data.movieRatio ?? 0) >= 0),
          informationCard(
                context: context,
                icon: Elusive.basket_circled,
              title: (data.vip ?? 0).toString(),
              subtitle: "مشترکین",
              percent: (data.vipRatio ?? 0.0).toString(),
              isProfit: (data.vipRatio ?? 0) >= 0),
          informationCard(
                context: context,
                icon: CupertinoIcons.money_dollar_circle_fill,
              title: (data.ads ?? 0).toString(),
              subtitle: "تبلیغات",
              percent: (data.adsRatio ?? 0.0).toString(),
              isProfit: (data.adsRatio ?? 0) >= 0),
        ]
      ),
    );
  }

  Widget _errorSliver(String? error, context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverToBoxAdapter(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                    const SizedBox(height: 8),
                    OutlinedButton(
                        onPressed: () {
                          BlocProvider.of<HeaderInformationCubit>(context)
                              .getData();
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
        ),
      ),
    );
  }

  Widget _loadingSliver(context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid.count(
        crossAxisCount: min(4, width ~/ 250),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1 / (100 / (width / min(4, width ~/ 250))),
        children: [
          Shimmer(
              gradient: LinearGradient(colors: [
                if (Theme.of(context).brightness == Brightness.dark) ...[
                  const Color.fromRGBO(28, 27, 30, 1),
                  const Color.fromRGBO(30, 29, 33, 1),
                  const Color.fromRGBO(36, 34, 38, 1),
                  const Color.fromRGBO(30, 29, 33, 1),
                  const Color.fromRGBO(28, 27, 30, 1),
                ] else ...[
                  const Color.fromRGBO(246, 242, 247, 1.0),
                  const Color.fromRGBO(241, 237, 242, 1.0),
                  const Color.fromRGBO(231, 227, 232, 1.0),
                  const Color.fromRGBO(241, 237, 242, 1.0),
                  const Color.fromRGBO(246, 242, 247, 1.0),
                ]
              ], stops: const [
                0.0,
                0.40,
                0.5,
                0.60,
                1.0
              ]),
              period: const Duration(milliseconds: 1000),
              child: const Card()),
          Shimmer(
              gradient: LinearGradient(colors: [
                if (Theme.of(context).brightness == Brightness.dark) ...[
                  const Color.fromRGBO(28, 27, 30, 1),
                  const Color.fromRGBO(30, 29, 33, 1),
                  const Color.fromRGBO(36, 34, 38, 1),
                  const Color.fromRGBO(30, 29, 33, 1),
                  const Color.fromRGBO(28, 27, 30, 1),
                ] else ...[
                  const Color.fromRGBO(246, 242, 247, 1.0),
                  const Color.fromRGBO(241, 237, 242, 1.0),
                  const Color.fromRGBO(231, 227, 232, 1.0),
                  const Color.fromRGBO(241, 237, 242, 1.0),
                  const Color.fromRGBO(246, 242, 247, 1.0),
                ]
              ], stops: const [
                0.0,
                0.40,
                0.5,
                0.60,
                1.0
              ]),
              period: const Duration(milliseconds: 1000),
              child: const Card()),
          Shimmer(
              gradient: LinearGradient(colors: [
                if (Theme.of(context).brightness == Brightness.dark) ...[
                  const Color.fromRGBO(28, 27, 30, 1),
                  const Color.fromRGBO(30, 29, 33, 1),
                  const Color.fromRGBO(36, 34, 38, 1),
                  const Color.fromRGBO(30, 29, 33, 1),
                  const Color.fromRGBO(28, 27, 30, 1),
                ] else ...[
                  const Color.fromRGBO(246, 242, 247, 1.0),
                  const Color.fromRGBO(241, 237, 242, 1.0),
                  const Color.fromRGBO(231, 227, 232, 1.0),
                  const Color.fromRGBO(241, 237, 242, 1.0),
                  const Color.fromRGBO(246, 242, 247, 1.0),
                ]
              ], stops: const [
                0.0,
                0.40,
                0.5,
                0.60,
                1.0
              ]),
              period: const Duration(milliseconds: 1000),
              child: const Card()),
          Shimmer(
              gradient: LinearGradient(colors: [
                if (Theme.of(context).brightness == Brightness.dark) ...[
                  const Color.fromRGBO(28, 27, 30, 1),
                  const Color.fromRGBO(30, 29, 33, 1),
                  const Color.fromRGBO(36, 34, 38, 1),
                  const Color.fromRGBO(30, 29, 33, 1),
                  const Color.fromRGBO(28, 27, 30, 1),
                ] else ...[
                  const Color.fromRGBO(246, 242, 247, 1.0),
                  const Color.fromRGBO(241, 237, 242, 1.0),
                  const Color.fromRGBO(231, 227, 232, 1.0),
                  const Color.fromRGBO(241, 237, 242, 1.0),
                  const Color.fromRGBO(246, 242, 247, 1.0),
                ]
              ], stops: const [
                0.0,
                0.40,
                0.5,
                0.60,
                1.0
              ]),
              period: const Duration(milliseconds: 1000),
              child: const Card()),
        ],
      ),
    );
  }
}
