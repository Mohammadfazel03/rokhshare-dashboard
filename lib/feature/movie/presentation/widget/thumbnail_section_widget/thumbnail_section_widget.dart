import 'package:dashboard/feature/movie/presentation/widget/thumbnail_section_widget/bloc/thumbnail_section_cubit.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThumbnailSectionWidget extends StatelessWidget {
  const ThumbnailSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThumbnailSectionCubit, ThumbnailSectionState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DottedBorder(
              dashPattern: const [3, 2],
              radius: const Radius.circular(4),
              color: state.error != null
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.outline,
              child: InputDecorator(
                  decoration: InputDecoration(
                    label: DecoratedBox(
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerLow),
                        child: const Text(" تصویر شاخص ")),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide.none),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide.none),
                    focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide.none),
                    errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide.none),
                    filled: false,
                  ),
                  isFocused: state.isFocused,
                  isEmpty: state.file == null,
                  isHovering: state.isHovering,
                  child:
                      state.file != null ? fileSelected(state, context) : selectFile(context)),
            ),
            if (state.error != null) ...[
              Padding(
                  padding: const EdgeInsets.fromLTRB(8,8,8,0),
                  child: Text(
                    state.error!,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Theme.of(context).colorScheme.error),
                  ))
            ]
          ],
        );
      },
    );
  }

  Widget selectFile(context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton.icon(
            onPressed: () async {
              BlocProvider.of<ThumbnailSectionCubit>(context).focus(true);
              FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
              BlocProvider.of<ThumbnailSectionCubit>(context).focus(false);
              if (result != null) {
                  BlocProvider.of<ThumbnailSectionCubit>(context).selectFile(
                      file: await result.files.single.xFile.readAsBytes(),
                      filename: result.files.single.name);

              }
            },
            label: Text("بارگذاری",
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.primary)),
            icon: const Icon(Icons.upload_rounded)),
      ],
    );
  }

  Widget fileSelected(ThumbnailSectionState state, context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.memory(
          state.file!,
          height: 56,
          width: 56,
          fit: BoxFit.fill,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(state.filename ?? "",
              style: Theme.of(context).textTheme.labelLarge),
        ),
        const SizedBox(width: 8),
        IconButton(
            onPressed: () {
              BlocProvider.of<ThumbnailSectionCubit>(context).removeFile();
            },
            icon: const Icon(Icons.close, color: Colors.red))
      ],
    );
  }
}
