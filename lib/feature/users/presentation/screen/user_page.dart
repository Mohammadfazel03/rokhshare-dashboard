import 'package:dashboard/config/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      int width = constraints.constrainWidth().round();
      int height = constraints.constrainHeight().round();
      return SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: SizedBox(
                width: width.toDouble(),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text("کاربران / ", style: TextStyle(
                        color: CustomColor.navRailTextColorDisable.getColor(context),
                        fontSize: 14
                    ))
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: StaggeredGrid.count(
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                crossAxisCount: 10,
                children: [
                  StaggeredGridTile.extent(
                      crossAxisCellCount: width / 10 >= 75 ? 6 : 10,
                      mainAxisExtent: 410,
                      child: Container(
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).shadowColor,
                                blurRadius: 1,
                                spreadRadius: 0.1,
                              )
                            ]),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                "کاربران فعال اخیر",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
