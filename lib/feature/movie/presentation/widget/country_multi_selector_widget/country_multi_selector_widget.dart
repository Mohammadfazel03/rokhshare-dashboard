import 'package:dashboard/config/dependency_injection.dart';
import 'package:dashboard/config/local_storage_service.dart';
import 'package:dashboard/config/router_config.dart';
import 'package:dashboard/feature/login/presentation/widget/error_snackbar_widget.dart';
import 'package:dashboard/feature/media/data/remote/model/country.dart';
import 'package:dashboard/feature/movie/presentation/widget/country_multi_selector_widget/bloc/country_multi_selector_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/multi_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

class CountryMultiSelectorWidget extends StatefulWidget {
  final bool readOnly;

  const CountryMultiSelectorWidget({super.key, this.readOnly = false});

  @override
  State<CountryMultiSelectorWidget> createState() =>
      _CountryMultiSelectorWidgetState();
}

class _CountryMultiSelectorWidgetState
    extends State<CountryMultiSelectorWidget> {
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
    return BlocConsumer<CountryMultiSelectorCubit, CountryMultiSelectorState>(
      listener: (context, state) {
        if (state.status == CountryMultiSelectorStatus.fail) {
          if (state.code == 403) {
            getIt.get<LocalStorageService>().logout().then((value){
                context.go(RoutePath.login.fullPath);
            });
          }
          toastification.showCustom(
              animationDuration: const Duration(milliseconds: 300),
              context: context,
              alignment: Alignment.bottomRight,
              autoCloseDuration: const Duration(seconds: 4),
              direction: TextDirection.rtl,
              builder: (BuildContext context, ToastificationItem holder) {
                return ErrorSnackBarWidget(
                  item: holder,
                  title: state.titleError ?? "خطا در دریافت کشور ها",
                  message: state.error ?? "در دریافت کشور ها مشکلی پیش آمده.",
                );
              });
        }
      },
      builder: (context, state) {
        List<Country>? countries;
        bool isLoading = true;
        bool disable = true;
        Widget? error;
        if (state.status == CountryMultiSelectorStatus.loading) {
          countries = null;
          isLoading = true;
          disable = true;
          error = null;
        } else if (state.status == CountryMultiSelectorStatus.fail) {
          countries = null;
          isLoading = false;
          disable = true;
          error = MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                BlocProvider.of<CountryMultiSelectorCubit>(context).getData();
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
        } else if (state.status == CountryMultiSelectorStatus.success) {
          countries = state.data;
          isLoading = false;
          disable = false;
          error = null;
          if (state.error != null) {
            error = Text(state.error!,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).colorScheme.error));
          }
        }
        return MultiSelectorWidget<Country>(
          controller: searchController,
          errorWidget: error,
          items: countries,
          isLoading: isLoading,
          disabled: disable,
          readOnly: widget.readOnly,
          selectedItemWidget: (Country item) {
            return Text(item.name ?? "",
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.onPrimary));
          },
          labelText: 'کشور ها',
          selectItem: (Country? item) {
            BlocProvider.of<CountryMultiSelectorCubit>(context)
                .selectItem(item);
          },
          unselectedItemWidget: (Country item) {
            return Text(item.name ?? "",
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurface));
          },
          selectedItemBuilder: (Country item) {
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
                label: Text(item.name ?? "",
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary)));
          },
          selectedValues: state.status == CountryMultiSelectorStatus.success
              ? state.selectedItem
              : [],
          searchMatchFn: (DropdownMenuItem<Country> item, String searchValue) {
            return item.value?.name?.contains(searchValue) ?? false;
          },
        );
      },
    );
  }
}
