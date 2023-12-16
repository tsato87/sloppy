import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../const/colors.dart';
import '../app_bar/account_manager/account_manager_menu_button.dart';


class GroupsPage extends ConsumerWidget {
  const GroupsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Sloppy',
            style: TextStyle(
              color: SloppyColors.sloppyTheme,
            ),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.meeting_room)),
            const AccountManagerMenuButton(),
            IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
          ],
        ),
        body: const Center(child: Text('groups page')));
  }
}
