import 'package:flutter/material.dart';

class PaginationWidget extends StatefulWidget {
  final int totalPages;
  final int currentPage;
  final Function(int int) onChangePage;

  const PaginationWidget(
      {super.key,
      required this.totalPages,
      required this.currentPage,
      required this.onChangePage});

  @override
  State<PaginationWidget> createState() => _PaginationWidgetState();
}

class _PaginationWidgetState extends State<PaginationWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            OutlinedButton(
              onPressed: widget.currentPage > 1
                  ? () {
                      widget.onChangePage(widget.currentPage - 1);
                    }
                  : null,
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all(const Size(36, 36)),
                textStyle: WidgetStateProperty.resolveWith((state) {
                  return Theme.of(context).textTheme.labelSmall;
                }),
                padding: WidgetStateProperty.all(const EdgeInsets.all(16)),
                shape: WidgetStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4))),
              ),
              child: const Text(
                "قبلی",
              ),
            ),
            const SizedBox(width: 2),
            ..._generateButtonList(context),
            const SizedBox(width: 2),
            OutlinedButton(
              onPressed: widget.currentPage < widget.totalPages
                  ? () {
                      widget.onChangePage(widget.currentPage + 1);
                    }
                  : null,
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all(const Size(36, 36)),
                textStyle: WidgetStateProperty.resolveWith((state) {
                  return Theme.of(context).textTheme.labelSmall;
                }),
                padding: WidgetStateProperty.all(const EdgeInsets.all(16)),
                shape: WidgetStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4))),
              ),
              child: const Text(
                "بعدی",
              ),
            ),
          ],
        ));
  }

  List<Widget> _generateButtonList(BuildContext context) {
    List<Widget> children = [];
    if (widget.totalPages > 5) {
      if (widget.currentPage - 1 > 2) {
        children.add(_buildPageButton(context, 1));
        children
            .add(_buildDots(context, ((2 + widget.currentPage) / 2).round()));
      } else {
        for (int i = 1; i <= 3; i++) {
          children.add(_buildPageButton(context, i));
        }
      }

      if (widget.totalPages - widget.currentPage > 2) {
        children.add(_buildDots(
            context, ((widget.totalPages + widget.currentPage) / 2).round()));
        children.add(_buildPageButton(context, widget.totalPages));
      } else {
        for (int i = widget.totalPages - 2; i <= widget.totalPages; i++) {
          children.add(_buildPageButton(context, i));
        }
      }

      if (children.length < 5) {
        children.insert(2, _buildPageButton(context, widget.currentPage));
      }
    } else {
      for (int i = 1; i <= widget.totalPages; i++) {
        children.add(_buildPageButton(context, i));
      }
    }
    return children;
  }

  Widget _buildPageButton(BuildContext context, int index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: OutlinedButton(
          onPressed: () {
            widget.onChangePage(index);
          },
          style: ButtonStyle(
              minimumSize: WidgetStateProperty.all(const Size(24, 36)),
              backgroundColor: WidgetStateProperty.all(
                  widget.currentPage == index
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent),
              foregroundColor: WidgetStateProperty.all(
                  widget.currentPage == index
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.primary),
              textStyle: WidgetStateProperty.resolveWith((state) {
                return Theme.of(context).textTheme.labelSmall;
              }),
              padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 16)),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4))),
              side: WidgetStateProperty.resolveWith((state) {
                if (widget.currentPage == index) {
                  return BorderSide(
                      color: Theme.of(context).colorScheme.primary);
                }
                return BorderSide(color: Theme.of(context).colorScheme.outline);
              })),
          child: Text(
            "$index",
          ),
        ),
      );

  Widget _buildDots(BuildContext context, int index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: OutlinedButton(
            onPressed: () {
              widget.onChangePage(index);
            },
            style: ButtonStyle(
              minimumSize: WidgetStateProperty.all(const Size(24, 36)),
              foregroundColor: WidgetStateProperty.all(
                  Theme.of(context).colorScheme.primary),
              textStyle: WidgetStateProperty.all(
                  Theme.of(context).textTheme.labelSmall),
              padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 16)),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4))),
            ),
            child: const Text(
              "...",
            )),
      );
}
