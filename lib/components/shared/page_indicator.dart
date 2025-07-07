import 'package:flight_search/utils/mediaquery.dart';
import 'package:flutter/material.dart';

class PageViewIndicator extends StatelessWidget {
  const PageViewIndicator({
    required this.itemCount,
    required this.currentPage,
    super.key,
  });

  final int itemCount;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: fullHeight(context),
        minWidth: 100,
        maxHeight: 50,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: buildPageIndicator(),
      ),
    );
  }

  // indicates current page
  List<Widget> buildPageIndicator() {
    final list = <Widget>[];

    /// Creating a list of 3 PageIndicator widgets.
    for (var i = 0; i < itemCount; i++) {
      list.add(
        i == currentPage
            ? const PageIndicator(isActive: true)
            : PageIndicator(isActive: false, isMainPage: i == 0),
      );
    }
    return list.toList();
  }
}

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    required this.isActive,
    this.isMainPage = false,
    super.key,
  });

  final bool isActive;
  final bool isMainPage;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      height: 7,
      width: isActive ? 20 : 10,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey.shade400,
        borderRadius: const BorderRadius.all(Radius.circular(100)),
      ),
    );
  }
}
