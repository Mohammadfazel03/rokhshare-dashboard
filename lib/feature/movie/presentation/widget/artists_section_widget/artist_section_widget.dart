import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/feature/movie/presentation/widget/artists_autocomplete_widget/artists_autocomplete_widget.dart';
import 'package:dashboard/feature/movie/presentation/widget/artists_autocomplete_widget/bloc/artists_autocomplete_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/artists_section_widget/bloc/artist_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/artists_section_widget/entity/cast.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArtistSectionWidget extends StatelessWidget {
  final ArtistsAutocompleteController _controller;
  final double width;

  ArtistSectionWidget(
      {super.key,
      required this.width,
      ArtistsAutocompleteController? controller})
      : _controller = controller ?? ArtistsAutocompleteController();

  @override
  Widget build(BuildContext mainContext) {
    return BlocBuilder<ArtistSectionCubit, ArtistSectionState>(
      buildWhen: (p, c) {
        return p.error != c.error;
      },
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpansionTile(
              maintainState: true,
              collapsedBackgroundColor:
                  Theme.of(mainContext).colorScheme.surfaceContainerHighest,
              backgroundColor:
                  Theme.of(mainContext).colorScheme.surfaceContainer,
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: state.error == null
                          ? Theme.of(mainContext).colorScheme.primary
                          : Theme.of(mainContext).colorScheme.error,
                      width: 2),
                  borderRadius: BorderRadius.circular(4)),
              collapsedShape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: state.error == null
                          ? Theme.of(mainContext).colorScheme.outline
                          : Theme.of(mainContext).colorScheme.error),
                  borderRadius: BorderRadius.circular(4)),
              tilePadding: const EdgeInsets.symmetric(horizontal: 8),
              textColor: state.error == null
                  ? Theme.of(mainContext).colorScheme.primary
                  : Theme.of(mainContext).colorScheme.error,
              collapsedTextColor: state.error == null
                  ? Theme.of(mainContext).colorScheme.onSurfaceVariant
                  : Theme.of(mainContext).colorScheme.error,
              title: const Text(
                "هنرمندان",
              ),
              childrenPadding: const EdgeInsets.all(8),
              clipBehavior: Clip.hardEdge,
              children: [
                if (width >= 700) ...[
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 6,
                        child: BlocProvider(
                            create: (context) => ArtistsAutocompleteCubit(
                                repository: getIt.get()),
                            child: ArtistsAutocompleteWidget(
                                controller: _controller)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                          flex: 4,
                          child: BlocBuilder<ArtistSectionCubit,
                              ArtistSectionState>(
                            buildWhen: (p, c) {
                              return p.selectedRole != c.selectedRole;
                            },
                            builder: (context, state) {
                              return Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: selectRole(
                                          mainContext, state.selectedRole)),
                                  const SizedBox(width: 8),
                                  IconButton(
                                      onPressed: () {
                                        if (state.selectedRole != null &&
                                            _controller.value != null) {
                                          BlocProvider.of<ArtistSectionCubit>(
                                                  context)
                                              .addCast(Cast(
                                                  artist: _controller.value!,
                                                  position:
                                                      state.selectedRole!));
                                          _controller.clear();
                                        }
                                      },
                                      icon: const Icon(Icons.add))
                                ],
                              );
                            },
                          )),
                    ],
                  )
                ] else ...[
                  BlocProvider(
                      create: (context) =>
                          ArtistsAutocompleteCubit(repository: getIt.get()),
                      child:
                          ArtistsAutocompleteWidget(controller: _controller)),
                  const SizedBox(height: 8),
                  BlocBuilder<ArtistSectionCubit, ArtistSectionState>(
                    buildWhen: (p, c) {
                      return p.selectedRole != c.selectedRole;
                    },
                    builder: (context, state) {
                      return Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child:
                                  selectRole(mainContext, state.selectedRole)),
                          const SizedBox(width: 8),
                          IconButton(
                              onPressed: () {
                                if (state.selectedRole != null &&
                                    _controller.value != null) {
                                  BlocProvider.of<ArtistSectionCubit>(context)
                                      .addCast(Cast(
                                          artist: _controller.value!,
                                          position: state.selectedRole!));
                                  _controller.clear();
                                }
                              },
                              icon: const Icon(Icons.add))
                        ],
                      );
                    },
                  )
                ],
                const SizedBox(height: 8),
                BlocBuilder<ArtistSectionCubit, ArtistSectionState>(
                  buildWhen: (p, c) {
                    return !listEquals(p.casts, c.casts);
                  },
                  builder: (context, state) {
                    return ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: state.casts.length > 3
                              ? 216
                              : state.casts.length * 72),
                      child: ListView.builder(
                          itemCount: state.casts.length,
                          itemBuilder: (context, index) {
                            return Card(
                                clipBehavior: Clip.hardEdge,
                                child: ListTile(
                                  style: ListTileStyle.list,
                                  title: Text(
                                      state.casts[index].artist?.name ?? ""),
                                  subtitle: Text(state.casts[index].position
                                          ?.persianTitle ??
                                      ""),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Image.network(
                                        "${state.casts[index].artist?.image}",
                                        fit: BoxFit.cover,
                                        height: 40,
                                        width: 40),
                                  ),
                                  trailing: IconButton(
                                      onPressed: () {
                                        BlocProvider.of<ArtistSectionCubit>(
                                                context)
                                            .removeCast(index);
                                      },
                                      icon: const Icon(Icons.close,
                                          color: Colors.red)),
                                  tileColor:
                                      Theme.of(context).colorScheme.surface,
                                  minTileHeight: 72,
                                  titleTextStyle: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface),
                                  subtitleTextStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant),
                                ));
                          }),
                    );
                  },
                )
              ],
            ),
            if (state.error != null) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Text(
                  state.error!,
                  style: Theme.of(mainContext).textTheme.bodySmall?.copyWith(
                      color: Theme.of(mainContext).colorScheme.error),
                ),
              )
            ]
          ],
        );
      },
    );
  }

  Widget selectRole(BuildContext context, selectedRole) {
    return DropdownButtonFormField2<Position>(
      isExpanded: true,
      decoration: const InputDecoration(
        label: Text("نقش"),
      ),
      items: Position.values
          .map((item) => DropdownMenuItem(
                value: item,
                child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(item.persianTitle,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(
                                color:
                                    Theme.of(context).colorScheme.onSurface))),
              ))
          .toList(),
      selectedItemBuilder: (c) => Position.values
          .map((e) => Text(e.persianTitle,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurface)))
          .toList(),
      onChanged: (item) {
        BlocProvider.of<ArtistSectionCubit>(context).selectRole(item);
      },
      value: selectedRole,
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          boxShadow: const [],
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(4),
          // color:
        ),
      ),
    );
  }
}
