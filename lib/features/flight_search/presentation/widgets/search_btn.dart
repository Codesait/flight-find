import 'package:flight_search/components/smartAnimatedMenu/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchButton extends ConsumerWidget {
  const SearchButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllerProvider = ref.watch(createMenuController);

    return Container(
      height: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withValues(alpha: .5),
            Colors.white.withValues(alpha: .7),
            Colors.white,
            Colors.white,
          ],
        ),
      ),
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: IconButton.outlined(
            onPressed: () {
              controllerProvider.toggleModalStatus(context);
            },
            icon: Icon(
              controllerProvider.isModalOpen ? Icons.close : Icons.search,
              size: 30,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
