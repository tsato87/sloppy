import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../const/paths.dart';
import '../../services/auth/auth_service.dart';
import '../../services/routing/route_navigator.dart';
import 'auth_app_providers.dart';
import 'sign_in/sign_in_viewmodel.dart';

class LandingPage extends ConsumerWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    RouteNavigator navigator = RouteNavigator(context: context, ref: ref);
    final SignInViewModel signInViewModel = ref.watch(signInViewModelProvider);

    return StreamBuilder<SloppyUser?>(
      builder: (BuildContext context, AsyncSnapshot<SloppyUser?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            navigator.pushReplacementNamed(nextPagePath: Paths.home);
          });
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      stream: signInViewModel.authStateChanges(),
    );
  }
}
