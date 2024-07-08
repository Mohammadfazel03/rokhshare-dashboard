import 'dart:async';

import 'package:flutter/material.dart';

class Sidebar extends StatefulWidget {
  final StreamController<bool> controller;
  final SidebarMenu sidebarMenu;
  final Widget? child;

  const Sidebar({
    super.key,
    required this.controller,
    required this.sidebarMenu,
    this.child,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> with SingleTickerProviderStateMixin {
  late final OverlayPortalController _overlayPortalController;
  late final Animation<double> _animation;
  late final AnimationController _animationController;
  late final StreamSubscription _streamSubscription;

  @override
  void initState() {
    _overlayPortalController = OverlayPortalController();
    _streamSubscription = widget.controller.stream.listen((event) {
      if (event) {
        _animationController.forward();
        _overlayPortalController.show();
      } else {
        _animationController.reverse();
      }
    });

    _animationController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _animation =
        Tween<double>(begin: -300, end: 0).animate(_animationController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.dismissed) {
              _overlayPortalController.hide();
            }
          });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _overlayPortalController,
      overlayChildBuilder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 1,
          widthFactor: 1,
          child: GestureDetector(
            onTap: () {
              widget.controller.add(false);
            },
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.scrim.withOpacity(0.5),
              ),
              child: Stack(
                children: [
                  AnimatedBuilder(
                      animation: _animation,
                      builder: (BuildContext context, Widget? child) {
                        return Positioned(
                            top: 0, right: _animation.value, child: child!);
                      },
                      child: widget.sidebarMenu)
                ],
              ),
            ),
          ),
        );
      },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _streamSubscription.cancel();
    super.dispose();
  }
}

class SidebarMenu extends StatelessWidget {
  final double width;
  final ShapeBorder shape;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final Widget? child;

  const SidebarMenu(
      {super.key,
      required this.width,
      required this.backgroundColor,
      required this.shape,
      required this.padding,
      this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: padding,
        child: SizedBox(
          height: MediaQuery.of(context).size.height - padding.vertical,
          width: width,
          child: Material(
            shape: shape,
            color: backgroundColor,
            elevation: 1,
            child: child,
          ),
        ),
      ),
    );
  }
}
