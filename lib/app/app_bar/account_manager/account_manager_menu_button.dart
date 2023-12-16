import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../const/paths.dart';
import '../../../services/auth/auth_service.dart';
import '../../../services/routing/route_navigator.dart';
import '../../../utils/show_alert_dialog.dart';
import '../../auth/auth_app_providers.dart';
import 'account_manager_provider.dart';
import 'account_manager_viewmodel.dart';

enum AccountManagerMenuItemValue {
  none,
  signIn,
  signUp,
  signOut,
}

class AccountManagerMenuButton extends ConsumerWidget {
  const AccountManagerMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    RouteNavigator navigator = RouteNavigator(context: context, ref: ref);
    AccountManagerViewModel accountManagerViewModel = ref.watch(accountManagerViewModelProvider);
    SloppyUser? currentUser = accountManagerViewModel.getCurrentUser();
    // TODO: accountManagerViewModelを実装する
    return PopupMenuButton(
      icon: const Icon(Icons.account_circle_rounded),
      itemBuilder: (BuildContext context) =>
          <PopupMenuEntry<AccountManagerMenuItemValue>>[
        if (currentUser == null || currentUser.needEmailVerified)
          const PopupMenuItem<AccountManagerMenuItemValue>(
            value: AccountManagerMenuItemValue.signIn,
            child: Text('ログイン'),
          ),
        if (currentUser == null || currentUser.needEmailVerified)
          const PopupMenuItem<AccountManagerMenuItemValue>(
            value: AccountManagerMenuItemValue.signUp,
            child: Text('ユーザー登録'),
          ),
        if (currentUser is SloppyUser && !currentUser.needEmailVerified)
          const PopupMenuItem<AccountManagerMenuItemValue>(
            value: AccountManagerMenuItemValue.signOut,
            child: Text('サインアウト'),
          ),
      ],
      onSelected: (AccountManagerMenuItemValue selectedItem) async {
        if (selectedItem == AccountManagerMenuItemValue.signOut) {
          bool? doSignOut = await showAlertDialog(
            context: context,
            navigator: navigator,
            title: 'サインアウト',
            content: 'サインアウトを実行しますか？',
            defaultActionText: 'サインアウト',
            cancelActionText: 'キャンセル',
          );
          if (doSignOut == true) {
            await accountManagerViewModel.submit();
          }
        }
        else if (selectedItem == AccountManagerMenuItemValue.signIn) {
          if (currentUser is SloppyUser && currentUser.emailVerified){
            navigator.pushNamed(nextPagePath: Paths.signUpVerifyEmail);
          }
          navigator.pushNamed(nextPagePath: Paths.signIn);
        }
        else if (selectedItem == AccountManagerMenuItemValue.signUp) {
          navigator.pushNamed(nextPagePath: Paths.signUp);
        }
      }
    );
  }
}
