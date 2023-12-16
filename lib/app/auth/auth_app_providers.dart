import 'package:flutter/cupertino.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/auth/auth_service.dart';
import '../../services/auth/auth_service_provider.dart';
import '../../services/local_storage/local_storage_service_provider.dart';
import '../../services/local_storage/parameter_handler.dart';
import 'sign_in/sign_in_viewmodel.dart';
import '../app_bar/account_manager/account_manager_viewmodel.dart';
import 'sign_up/sign_up_viewmodel.dart';



final signInViewModelProvider = ChangeNotifierProvider.autoDispose<SignInViewModel>((ref) {
  AuthService authService = ref.watch(authServiceProvider);
  ParameterHandler parameterHandler = ref.watch(parameterHandlerProvider);
  final SignUpViewModel signUpViewModel = ref.watch(signUpViewModelProvider);
  return SignInViewModel(authService, signUpViewModel, parameterHandler);
});

final signUpViewModelProvider = ChangeNotifierProvider.autoDispose<SignUpViewModel>((ref) {
  AuthService authService = ref.watch(authServiceProvider);
  ParameterHandler parameterHandler = ref.watch(parameterHandlerProvider);
  return SignUpViewModel(authService, parameterHandler);
});

final signInPageArgumentsProvider = FutureProvider.autoDispose((ref) async {
  AuthService authService = ref.watch(authServiceProvider);
  List<String?> userNameOrEmailAndPassword = await authService.loadUserNameOrEmailAndPassword();
  String? userNameOrEmail = userNameOrEmailAndPassword.elementAt(0);
  String? password = userNameOrEmailAndPassword.elementAt(1);
  bool askSavePassword = (password == null);
  return [
    TextEditingController(text: userNameOrEmail ?? ''),
    TextEditingController(text: password ?? ''),
    askSavePassword,
  ];
});