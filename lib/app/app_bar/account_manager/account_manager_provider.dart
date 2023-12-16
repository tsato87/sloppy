import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/auth/auth_service.dart';
import '../../../services/auth/auth_service_provider.dart';
import 'account_manager_viewmodel.dart';

final accountManagerViewModelProvider = ChangeNotifierProvider.autoDispose<AccountManagerViewModel>((ref) {
  AuthService authService = ref.watch(authServiceProvider);
  return AccountManagerViewModel(authService);
});