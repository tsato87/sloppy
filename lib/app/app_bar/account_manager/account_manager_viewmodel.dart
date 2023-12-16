import 'package:flutter/cupertino.dart';

import '../../../services/auth/auth_service.dart';

class AccountManagerViewModel extends ChangeNotifier{
  final AuthService authService;

  AccountManagerViewModel(this.authService);

  SloppyUser? getCurrentUser() => authService.currentUser;

  Future<void> submit() async {
    await authService.signOut();
    // getCurrentUser の返り値が変化している。
    notifyListeners();
  }
}
