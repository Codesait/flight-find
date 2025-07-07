import 'package:flight_search/components/smartAnimatedMenu/controller.dart';
import 'package:flight_search/components/shared/custom_text.dart';
import 'package:flight_search/features/flight_search/presentation/pages/search_flights.dart';
import 'package:flight_search/utils/mediaquery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';

class SmartMenuWidget extends ConsumerStatefulWidget {
  const SmartMenuWidget({super.key});

  @override
  CreateMenuWidgetState createState() => CreateMenuWidgetState();
}

class CreateMenuWidgetState extends ConsumerState<SmartMenuWidget>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    ref.read(createMenuController).animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controllerProvider = ref.watch(createMenuController);

    return AnimatedBuilder(
      animation: controllerProvider.animationController,
      builder: (context, _) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () => controllerProvider.toggleModalStatus(context),
              child: Container(
                width: fullWidth(context),
                height: fullHeight(context),
                color: Colors.black.withValues(alpha: 0.1),
              ),
            ),
            Positioned(
              bottom: controllerProvider.bottomPosition(),
              left: controllerProvider.horizontalPosition(),
              right: controllerProvider.horizontalPosition(),
              child: Column(
                spacing: 20,
                children: [
                  //* Expanded state close button
                  Visibility(
                    visible: !controllerProvider.isModalCollapsed,
                    child: Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: IconButton(
                        onPressed: controllerProvider.fullyCollapseModal,
                        icon: const Icon(Icons.clear),
                        color: Colors.white,
                      ),
                    ).animate().scale(duration: 200.ms),
                  ),

                  //* Expanded state menu items
                  Container(
                        height: controllerProvider.modalHeight(),
                        width: controllerProvider.modalWidth(),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: .1),
                              blurRadius: 10,
                              spreadRadius: 5,
                            ),
                          ],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                              controllerProvider.isModalCollapsed ? 10 : 25,
                            ),
                            topRight: Radius.circular(
                              controllerProvider.isModalCollapsed ? 10 : 25,
                            ),
                            bottomLeft: Radius.circular(
                              controllerProvider.isModalCollapsed ? 10 : 0,
                            ),
                            bottomRight: Radius.circular(
                              controllerProvider.isModalCollapsed ? 10 : 0,
                            ),
                          ),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Visibility(
                          visible: controllerProvider.isModalCollapsed,
                          replacement: controllerProvider.getSmartMenuSubPages,
                          child: _MenuList(
                            getLoopAnimation:
                                controllerProvider.isModalCollapsed,
                            key: UniqueKey(),
                          ),
                        ),
                      )
                      .animate(target: controllerProvider.isModalOpen ? 1 : 0)
                      .scale(
                        duration: 300.ms,
                        curve:
                            controllerProvider.isModalOpen
                                ? Curves.bounceInOut
                                : null,
                      ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MenuList extends StatefulWidget {
  const _MenuList({required this.getLoopAnimation, super.key});
  final bool getLoopAnimation;

  @override
  State<_MenuList> createState() => _MenuListState();
}

class _MenuListState extends State<_MenuList> {
  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {
        'icon': RiveIcon.search,
        'title': 'Search for flights',
        'menuType': MenuPageState.flights,
        'screen': SearchFlights.route,
      },
      {
        'icon': RiveIcon.home2,
        'title': 'Book a hotel',
        'menuType': MenuPageState.hotels,
        'screen': null,
      },
      {
        'icon': RiveIcon.gallery,
        'title': 'Explore',
        'menuType': MenuPageState.explore,
        'screen': null,
      },
    ];

    return Material(
      color: Colors.transparent,
      child: Column(
        children: menuItems
            .map((item) {
              return Consumer(
                builder: (context, ref, _) {
                  final controllerProvider = ref.read(createMenuController);
                  return ListTile(
                    leading: RiveAnimatedIcon(
                      key: ValueKey(item['title']),
                      height: 30,
                      width: 30,
                      loopAnimation: widget.getLoopAnimation,
                      riveIcon: item['icon']! as RiveIcon,
                      color: Colors.blue,
                      strokeWidth: 3,
                    ),
                    title: TextView(text: item['title']! as String),
                    onTap: () {
                      if (item['screen'] != null) {
                        context.pushNamed(item['screen'] as String);
                        controllerProvider.toggleModalStatus(context);
                        return;
                      }

                      controllerProvider.setPage(
                        item['menuType']! as MenuPageState,
                      );
                    },
                  );
                },
              );
            })
            .toList()
            .animate(interval: 100.ms)
            .fade(duration: 50.ms),
      ),
    );
  }
}
