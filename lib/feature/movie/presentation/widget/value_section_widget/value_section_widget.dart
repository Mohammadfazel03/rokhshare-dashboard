import 'package:dashboard/feature/movie/presentation/widget/value_section_widget/bloc/value_section_cubit.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ValueSectionWidget extends StatelessWidget {
  const ValueSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ValueSectionCubit, ValueSectionState>(
      buildWhen: (p, c) {
        return p.error != c.error;
      },
      builder: (context, state) {
        return DropdownButtonFormField2<MediaValue>(
          isExpanded: true,
          decoration: InputDecoration(
            label: const Text("ارزش"),
            errorText: state.error
          ),
          items: MediaValue.values
              .map((item) => DropdownMenuItem(
            value: item,
            child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(item.persianTitle,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface))),
          ))
              .toList(),
          selectedItemBuilder: (c) => MediaValue.values
              .map((e) => Text(e.persianTitle,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface)))
              .toList(),
          onChanged: (item) {
            BlocProvider.of<ValueSectionCubit>(context).selectValue(item);
          },
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              boxShadow: const [],
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(4),
              // color:
            ),
          ),
        );
      },
    );
  }
}

