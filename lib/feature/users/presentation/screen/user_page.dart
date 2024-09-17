import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/theme/colors.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/recently_user/bloc/recently_user_cubit.dart';
import 'package:dashboard/feature/dashboard/presentation/widget/recently_user/recently_user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text("کاربران / ",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: CustomColor.navRailTextColorDisable
                          .getColor(context)))
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
                child: BlocProvider(
              create: (context) => RecentlyUserCubit(repository: getIt.get()),
              child: const RecentlyUserWidget(hasPagination: true),
            )),
          ),
        )
      ],
    );
  }
}
