import 'package:dashboard/feature/media/data/remote/model/artist.dart';
import 'package:dashboard/feature/movie/presentation/widget/artists_autocomplete_widget/bloc/artists_autocomplete_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/dynamic_autocomplete.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ArtistsAutocompleteController extends ValueNotifier<Artist?> {
  final TextEditingController inputController;
  final FocusNode focusNode;

  ArtistsAutocompleteController(
      {TextEditingController? inputController, FocusNode? focusNode})
      : inputController = inputController ?? TextEditingController(),
        focusNode = focusNode ?? FocusNode(),
        super(null);

  void clear() {
    inputController.clear();
    focusNode.unfocus();
    value = null;
    notifyListeners();
  }

  @override
  set value(Artist? newValue) {
    inputController.clear();
    focusNode.unfocus();
    super.value = newValue;
  }

}

class ArtistsAutocompleteWidget extends StatefulWidget {
  final ArtistsAutocompleteController _controller;

  ArtistsAutocompleteWidget(
      {super.key, ArtistsAutocompleteController? controller})
      : _controller = controller ?? ArtistsAutocompleteController();

  @override
  State<ArtistsAutocompleteWidget> createState() =>
      _ArtistsAutocompleteWidgetState();
}

class _ArtistsAutocompleteWidgetState extends State<ArtistsAutocompleteWidget> {
  late final PagingController<int, Artist> _pagingController;

  @override
  void initState() {
    _pagingController = PagingController(firstPageKey: 1);
    _pagingController.addPageRequestListener(pageRequestListener);

    super.initState();
  }

  void pageRequestListener(nextPage) {
    BlocProvider.of<ArtistsAutocompleteCubit>(context).getData(
        page: nextPage, search: widget._controller.inputController.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ArtistsAutocompleteCubit, ArtistsAutocompleteState>(
        listenWhen: (previous, current) {
          if (previous is ArtistsAutocompleteSuccess &&
              current is ArtistsAutocompleteSuccess) {
            return previous.data.totalPages != current.data.totalPages ||
                previous.data.count != current.data.count ||
                !listEquals(previous.data.results, current.data.results);
          }
          return true;
        },
        listener: (BuildContext context, ArtistsAutocompleteState state) {
          if (state is ArtistsAutocompleteSuccess) {
            final isLastPage = state.numberPages == state.pageIndex;
            if (isLastPage) {
              _pagingController.appendLastPage(state.data.results ?? []);
            } else {
              final nextPageKey = state.pageIndex + 1;
              _pagingController.appendPage(
                  state.data.results ?? [], nextPageKey);
            }
          } else if (state is ArtistsAutocompleteError) {
            _pagingController.error = state.error;
          }
        },
        child: DynamicAutocomplete<Artist>(
            focusNode: widget._controller.focusNode,
            controller: widget._controller.inputController,
            fieldViewBuilder: (
              BuildContext context,
              TextEditingController textEditingController,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted,
            ) {
              return KeyboardListener(
                  focusNode: focusNode,
                  onKeyEvent: (k) {
                    if (k.logicalKey.keyLabel == "Backspace" &&
                        widget._controller.value != null &&
                        textEditingController.text.isEmpty) {
                      widget._controller.value = null;
                    }
                  },
                  child: ValueListenableBuilder<Artist?>(
                      valueListenable: widget._controller,
                      builder: (context, state, _) {
                        return TextField(
                          controller: textEditingController,
                          onSubmitted: (s) {
                            textEditingController.clear();
                          },
                          decoration: InputDecoration(
                              floatingLabelBehavior: state != null
                                  ? FloatingLabelBehavior.always
                                  : FloatingLabelBehavior.auto,
                              label: const Text("هنرمند"),
                              prefixIcon: state != null
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(width: 15),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          child: Image.network(
                                            "${state.image}",
                                            height: 24,
                                            width: 24,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          state.name ?? "",
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface),
                                        ),
                                      ],
                                    )
                                  : null,
                              suffixIcon: state != null ||
                                      widget._controller.inputController.text
                                          .isNotEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        widget._controller.value = null;
                                      },
                                      icon:
                                          const Icon(Icons.clear, color: Colors.red),
                                      padding: const EdgeInsets.all(4),
                                    )
                                  : null),
                        );
                      }));
            },
            optionsBuilder: (TextEditingValue textEditingValue) {
              _pagingController.refresh();
              return [Artist()];
            },
            optionsViewBuilder:
                (context, AutocompleteOnSelected<Artist> onSelected, options) {
              return PagedListView<int, Artist>(
                // shrinkWrap: true,
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<Artist>(
                    itemBuilder: (context, item, index) => ListTile(
                          title: Text(item.name ?? ""),
                          onTap: () {
                            widget._controller.value = item;
                          },
                        )),
              );
            }));
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
