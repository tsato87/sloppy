import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sloppy/app/app_bar/go_previous_page_button.dart';
import 'package:sloppy/services/routing/routing_service_provider.dart';

import '../../const/colors.dart';
import '../../services/routing/routing_service.dart';
import 'account_manager/account_manager_menu_button.dart';

class SloppyAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const SloppyAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    RoutingService routingService = ref.read(routingServiceProvider);
    List<Widget> leftButtons = [];
    if (routingService.canGoPrevious){
      leftButtons.add(const GoPreviousPageButton());
    }
    return AppBar(
      title: const Text(
        'Sloppy',
        style: TextStyle(
          color: SloppyColors.sloppyTheme,
        ),
      ),
      automaticallyImplyLeading: false,
      leading: leftButtons.isEmpty ? null : Row(children: leftButtons),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.meeting_room)),
        const AccountManagerMenuButton(),
        IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
      ],
    );
  }
}
