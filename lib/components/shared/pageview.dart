import 'dart:async';

import 'package:flutter/material.dart';

class CustomPageView extends StatefulWidget {
  const CustomPageView({
    required this.pageController,
    this.onPageChange,
    this.pages,
    this.height,
    this.width,
    this.scrollBehavior,
    this.pageSnapping = true,
    this.autoScroll = false,
    this.autoScrollDuration = const Duration(seconds: 3),
    super.key,
  });

  final List<Widget>? pages;
  final ValueChanged<int>? onPageChange;
  final PageController pageController;
  final double? height;
  final double? width;
  final ScrollBehavior? scrollBehavior;
  final bool pageSnapping;
  final bool autoScroll;
  final Duration autoScrollDuration;

  @override
  State<CustomPageView> createState() => _CustomPageViewState();
}

class _CustomPageViewState extends State<CustomPageView> {
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    if (widget.autoScroll && widget.pages != null && widget.pages!.length > 1) {
      _timer = Timer.periodic(widget.autoScrollDuration, (timer) {
        if (!mounted) return;
        _currentPage = (_currentPage + 1) % widget.pages!.length;
        widget.pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: widget.width,
      height: widget.height,
      alignment: Alignment.center,
      child: PageView(
        controller: widget.pageController,
        onPageChanged: (index) {
          _currentPage = index;
          if (widget.onPageChange != null) widget.onPageChange!(index);
        },
        padEnds: true,
        scrollBehavior: widget.scrollBehavior,
        pageSnapping: widget.pageSnapping,
        children: widget.pages!,
        
      ),
    );
  }
}
