import 'package:dashboard/feature/movie/presentation/widget/poster_section_widget/bloc/poster_section_cubit.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PosterSectionWidget extends StatelessWidget {
  final bool readOnly;
  final Color textBackgroundColor;

  const PosterSectionWidget(
      {super.key, this.readOnly = false, required this.textBackgroundColor});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PosterSectionCubit, PosterSectionState>(
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
                        decoration: BoxDecoration(color: textBackgroundColor),
                        child: const Text(" ریز عکس ")),
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
                    errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide.none),
                    focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide.none),
                    filled: false,
                  ),
                  isFocused: state.isFocused,
                  isEmpty: state.file == null && state.networkUrl == null,
                  isHovering: state.isHovering,
                  child: state.file != null || state.networkUrl != null
                      ? fileSelected(state, context)
                      : selectFile(context)),
            ),
            if (state.error != null) ...[
              Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
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
              BlocProvider.of<PosterSectionCubit>(context).focus(true);
              FilePickerResult? result =
                  await FilePicker.platform.pickFiles(type: FileType.image);
              BlocProvider.of<PosterSectionCubit>(context).focus(false);
              if (result != null) {
                BlocProvider.of<PosterSectionCubit>(context).selectFile(
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

  Widget fileSelected(PosterSectionState state, context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (state.file != null)
          Image.memory(
            state.file!,
            height: 56,
            width: 56,
            fit: BoxFit.fill,
          ),
        if (state.networkUrl != null)
          Image.network(
            state.networkUrl!,
            height: 56,
            width: 56,
            fit: BoxFit.fill,
          ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(state.filename ?? "",
              style: Theme.of(context).textTheme.labelLarge,
              maxLines: 3,
              overflow: TextOverflow.ellipsis),
        ),
        const SizedBox(width: 8),
        if (!readOnly) ...[
          IconButton(
              onPressed: () {
                BlocProvider.of<PosterSectionCubit>(context).removeFile();
              },
              icon: const Icon(Icons.close, color: Colors.red))
        ]
      ],
    );
  }
}
