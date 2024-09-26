import 'dart:math';

import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/advertise/presentation/widget/advertise_table/advertise_table_widget.dart';
import 'package:dashboard/feature/advertise/presentation/widget/advertise_table/bloc/advertise_table_cubit.dart';
import 'package:dashboard/feature/advertise/presentation/widget/plan_table/bloc/plan_table_cubit.dart';
import 'package:dashboard/feature/advertise/presentation/widget/plan_table/plan_table_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdvertisePage extends StatelessWidget {
  const AdvertisePage({super.key});

  @override
  Widget build(BuildContext context) {
    int height = MediaQuery.sizeOf(context).height.round();

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          sliver: SliverToBoxAdapter(
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text("تبلیغات و طرح ها / ",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: CustomColor.navRailTextColorDisable
                            .getColor(context)))
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverToBoxAdapter(
            child: SizedBox(
              height: max(410, height / 2),
              child: Card(
                  child: BlocProvider(
                create: (context) => PlanTableCubit(repository: getIt.get()),
                child: const PlanTableWidget(),
              )),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          sliver: SliverToBoxAdapter(
            child: SizedBox(
              height: max(410, height / 2),
              child: Card(
                  child: BlocProvider(
                create: (context) =>
                    AdvertiseTableCubit(repository: getIt.get()),
                child: const AdvertiseTableWidget(),
              )),
            ),
          ),
        ),
      ],
    );
  }
}
