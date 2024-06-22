import 'package:dashboard/config/theme/colors.dart';
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
              child: Text(
                "قبلی",
              ),
              style: ButtonStyle(
                  minimumSize: WidgetStateProperty.all(Size(36, 36)),
                  foregroundColor: WidgetStateProperty.resolveWith((state) {
                    if (state.contains(WidgetState.disabled)) {
                      return CustomColor.disablePaginationButtonColor
                          .getColor(context);
                    }
                    return Theme.of(context).textTheme.labelSmall?.color;
                  }),
                  textStyle: WidgetStateProperty.resolveWith((state) {
                    return Theme.of(context).textTheme.labelSmall;
                  }),
                  padding: WidgetStateProperty.all(EdgeInsets.all(16)),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
                  side: WidgetStateProperty.resolveWith((state) {
                    if (state.contains(WidgetState.disabled)) {
                      return BorderSide(
                          color:
                              Theme.of(context).dividerColor.withOpacity(0.5));
                    }
                    return BorderSide(color: Theme.of(context).dividerColor);
                  })),
            ),
            ..._generateButtonList(context),
            OutlinedButton(
              onPressed: widget.currentPage < widget.totalPages
                  ? () {
                      widget.onChangePage(widget.currentPage + 1);
                    }
                  : null,
              child: Text(
                "بعدی",
              ),
              style: ButtonStyle(
                  minimumSize: WidgetStateProperty.all(Size(36, 36)),
                  foregroundColor: WidgetStateProperty.resolveWith((state) {
                    if (state.contains(WidgetState.disabled)) {
                      return CustomColor.disablePaginationButtonColor
                          .getColor(context);
                    }
                    return Theme.of(context).textTheme.labelSmall?.color;
                  }),
                  textStyle: WidgetStateProperty.resolveWith((state) {
                    return Theme.of(context).textTheme.labelSmall;
                  }),
                  padding: WidgetStateProperty.all(EdgeInsets.all(16)),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
                  side: WidgetStateProperty.resolveWith((state) {
                    if (state.contains(WidgetState.disabled)) {
                      return BorderSide(
                          color:
                              Theme.of(context).dividerColor.withOpacity(0.5));
                    }
                    return BorderSide(color: Theme.of(context).dividerColor);
                  })),
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
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: OutlinedButton(
          onPressed: () {
            widget.onChangePage(index);
          },
          child: Text(
            "$index",
          ),
          style: ButtonStyle(
              minimumSize: WidgetStateProperty.all(Size(24, 36)),
              backgroundColor: WidgetStateProperty.all(
                  widget.currentPage == index
                      ? CustomColor.loginBackgroundColor.getColor(context)
                      : Colors.transparent),
              foregroundColor: WidgetStateProperty.all(
                  widget.currentPage == index
                      ? Colors.white
                      : Theme.of(context).textTheme.labelSmall?.color),
              textStyle: WidgetStateProperty.all(
                  Theme.of(context).textTheme.labelSmall),
              padding: WidgetStateProperty.all(
                  EdgeInsets.symmetric(horizontal: 12, vertical: 16)),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4))),
              side: WidgetStateProperty.resolveWith((state) {
                if (widget.currentPage == index) {
                  return BorderSide(
                      color: CustomColor.loginBackgroundColor.getColor(context),
                      width: 0);
                }
                return BorderSide(color: Theme.of(context).dividerColor);
              })),
        ),
      );

  Widget _buildDots(BuildContext context, int index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: OutlinedButton(
          onPressed: () {
            widget.onChangePage(index);
          },
          child: Text(
            "...",
            style: Theme.of(context).textTheme.labelSmall,
          ),
          style: ButtonStyle(
              minimumSize: WidgetStateProperty.all(Size(24, 36)),
              foregroundColor: WidgetStateProperty.resolveWith((state) {
                if (state.contains(WidgetState.disabled)) {
                  return CustomColor.disablePaginationButtonColor
                      .getColor(context);
                }
                return Theme.of(context).textTheme.labelSmall?.color;
              }),
              textStyle: WidgetStateProperty.resolveWith((state) {
                return Theme.of(context).textTheme.labelSmall;
              }),
              padding: WidgetStateProperty.all(
                  EdgeInsets.symmetric(horizontal: 12, vertical: 16)),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4))),
              side: WidgetStateProperty.resolveWith((state) {
                if (state.contains(WidgetState.disabled)) {
                  return BorderSide(
                      color: Theme.of(context).dividerColor.withOpacity(0.5));
                }
                return BorderSide(color: Theme.of(context).dividerColor);
              })),
        ),
      );
}
