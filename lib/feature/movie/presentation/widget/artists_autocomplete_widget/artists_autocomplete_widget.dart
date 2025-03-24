import 'package:dashboard/feature/media/data/remote/model/artist.dart';
import 'package:dashboard/feature/movie/presentation/widget/artists_autocomplete_widget/bloc/artists_autocomplete_cubit.dart';
import 'package:dashboard/feature/movie/presentation/widget/dynamic_autocomplete.dart';
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

  @override
  Widget build(BuildContext context) {
    return DynamicAutocomplete<Artist>(
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(width: 15),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
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
                                  icon: const Icon(Icons.clear,
                                      color: Colors.red),
                                  padding: const EdgeInsets.all(4),
                                )
                              : null),
                    );
                  }));
        },
        optionsBuilder: (TextEditingValue textEditingValue) {
          BlocProvider.of<ArtistsAutocompleteCubit>(context).refresh();
          return [Artist()];
        },
        optionsViewBuilder:
            (context, AutocompleteOnSelected<Artist> onSelected, options) {
          return BlocBuilder<ArtistsAutocompleteCubit,
              PagingState<int, Artist>>(
            builder: (context, state) {
              return PagedListView<int, Artist>(
                state: state,
                fetchNextPage: () {
                  BlocProvider.of<ArtistsAutocompleteCubit>(context)
                      .getData(search: widget._controller.inputController.text);
                },
                builderDelegate: PagedChildBuilderDelegate<Artist>(
                    itemBuilder: (context, item, index) => ListTile(
                          title: Text(item.name ?? ""),
                          onTap: () {
                            widget._controller.value = item;
                          },
                        )),
              );
            },
          );
        });
  }
}
