import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sloppy/services/routing/route_navigator.dart';


class GoPreviousPageButton extends ConsumerWidget {
  const GoPreviousPageButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    RouteNavigator navigator = RouteNavigator(context: context, ref: ref);
    return IconButton(
        onPressed: () {
          navigator.goPrevious();
        },
        icon: const Icon(Icons.arrow_back));
  }
}
