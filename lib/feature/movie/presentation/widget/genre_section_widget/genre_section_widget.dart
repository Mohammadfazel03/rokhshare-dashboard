import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:dashboard/feature/media/data/remote/model/genre.dart';
import 'package:dashboard/feature/movie/presentation/widget/genre_section_widget/bloc/genre_section_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/multi_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

class GenreSectionWidget extends StatefulWidget {
  final bool readOnly;

  const GenreSectionWidget({super.key, this.readOnly = false});

  @override
  State<GenreSectionWidget> createState() => _GenreSectionWidgetState();
}

class _GenreSectionWidgetState extends State<GenreSectionWidget> {
  late final TextEditingController searchController;
  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GenreSectionCubit, GenreSectionState>(
      listener: (context, state) {
        if (state.status == GenreSectionStatus.fail) {
          toastification.showCustom(
              animationDuration: const Duration(milliseconds: 300),
              context: context,
              alignment: Alignment.bottomRight,
              autoCloseDuration: const Duration(seconds: 4),
              direction: TextDirection.rtl,
              builder: (BuildContext context, ToastificationItem holder) {
                return ErrorSnackBarWidget(
                  item: holder,
                  title: state.titleError ?? "خطا در دریافت ژانر",
                  message: state.error ?? "در دریافت ژانر ها مشکلی پیش آمده.",
                );
              });
        }
      },
      builder: (context, state) {
        List<Genre>? genres;
        bool isLoading = true;
        bool disable = true;
        Widget? error;
        if (state.status == GenreSectionStatus.loading) {
          genres = null;
          isLoading = true;
          disable = true;
          error = null;
        } else if (state.status == GenreSectionStatus.fail) {
          genres = null;
          isLoading = false;
          disable = true;
          error = MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                BlocProvider.of<GenreSectionCubit>(context).getData();
              },
              child: Text(
                "تلاش دوباره",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).colorScheme.error),
              ),
            ),
          );
        } else if (state.status == GenreSectionStatus.success) {
          genres = state.data;
          isLoading = false;
          disable = false;
          error = null;
          if (state.error != null) {
            error = Text(state.error!,style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Theme.of(context).colorScheme.error));
          }
        }
        return MultiSelectorWidget<Genre>(
          controller: searchController,
          errorWidget: error,
          items: genres,
          isLoading: isLoading,
          disabled: disable,
          readOnly: widget.readOnly,
          selectedItemWidget: (Genre item) {
            return Text(item.title ?? "",
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.onPrimary));
          },
          labelText: 'ژانر ها',
          selectItem: (Genre? item) {
            BlocProvider.of<GenreSectionCubit>(context).selectItem(item);
          },
          unselectedItemWidget: (Genre item) {
            return Text(item.title ?? "",
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurface));
          },
          selectedItemBuilder: (Genre item) {
            return RawChip(
                selectedColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                side: BorderSide.none,
                elevation: 1,
                pressElevation: 2,
                showCheckmark: false,
                selected: true,
                onSelected: (s) {},
                label: Text(item.title ?? "",
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary)));
          },
          selectedValues: state.status == GenreSectionStatus.success
              ? state.selectedItem
              : [],
          searchMatchFn: (DropdownMenuItem<Genre> item, String searchValue) {
            return item.value?.title?.contains(searchValue) ?? false;
          },
        );
      },
    );
  }
}
