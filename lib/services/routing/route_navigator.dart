import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'routing_service.dart';
import 'routing_service_provider.dart';


enum NavigateRequest {
  none,
  pop,
  removeUntil,
  goPrevious,
  goNext,
  pushNamed,
  pushReplacementNamed,
  pushNamedAndRemoveUntil,
}

final routeNavigatorStateProvider =
    ChangeNotifierProvider.autoDispose<NavigateRequestState>(
        (ref) => NavigateRequestState());

class RouteNavigator {
  /*
  『Do not use BuildContexts across async gaps』を出さないために、
  魔法を実行するNavigatorのラッパークラス.

  Notes:
    NavigateRequestState.updateWith()をコールして、ページ遷移のリクエストを登録
    NavigateRequestState.updateWith()のnotifyListeners()コール後に、refのWidgetが再buildされる
    build後に、CustomNavigator._checkNavigateRequestが実行される
    _checkNavigateRequestは、NavigateRequestStateにページ遷移のリクエストがあれば実行する
  */

  final BuildContext context;
  final WidgetRef ref;
  late final RoutingService routingService;
  NavigateRequestState? state;

  RouteNavigator({required this.context, required this.ref}) {
    // 魔法
    state = ref.watch(routeNavigatorStateProvider);
    routingService = ref.watch(routingServiceProvider);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _checkNavigateRequest());
  }

  void _checkNavigateRequest() {
    if (state == null) {
      return;
    }
    if (state!.lastRequest == NavigateRequest.none) {
      return;
    }
    void Function()? navigateFunction = <NavigateRequest, void Function()>{
      NavigateRequest.pop: _pop,
      NavigateRequest.removeUntil: _removeUntil,
      NavigateRequest.goPrevious: _goPrevious,
      NavigateRequest.goNext: _goNext,
      NavigateRequest.pushNamed: _pushNamed,
      NavigateRequest.pushReplacementNamed: _pushReplacementNamed,
      NavigateRequest.pushNamedAndRemoveUntil: _pushNamedAndRemoveUntil,
    }[state!.lastRequest];
    if (navigateFunction != null) {
      navigateFunction();
      state?.clear();
    }
  }

  void pop([bool popResult = false]) {
    state?.acceptPopRequest(popResult);
  }

  void removeUntil({required List<String> removeUntil}) {
    state?.acceptRemoveUntilRequest(removeUntil);
  }

  void goPrevious() {
    state?.acceptGoPreviousRequest();
  }

  void goNext() {
    state?.acceptGoPreviousRequest();
  }

  void pushNamed({required String nextPagePath}) {
    state?.acceptPushNamedRequest(nextPagePath);
  }

  void pushReplacementNamed({required String nextPagePath}) {
    state?.acceptPushReplacementNamedRequest(nextPagePath);
  }

  void pushNamedAndRemoveUntil(
      {required String nextPagePath, required List<String> removeUntil}) {
    state?.acceptPushNamedAndRemoveUntilRequest(nextPagePath, removeUntil);
  }

  void _pop() {
    Navigator.of(context).pop(state!.popResult);
  }

  void _removeUntil() {
    routingService.removeUntil(state!.removeUntil!);
  }

  void _goPrevious() {
    routingService.switchToPreviousPage();
  }

  void _goNext() {
    routingService.switchToPreviousPage();
  }

  void _pushNamed() {
    if (state == null || state!.nextPagePath == null) {
      return;
    }
    routingService.switchToPageFromPath(state!.nextPagePath!);
  }

  void _pushReplacementNamed() {
    if (state == null || state!.nextPagePath == null) {
      return;
    }
    routingService.switchToPageFromPath(state!.nextPagePath!, removeAll: true);
  }

  void _pushNamedAndRemoveUntil() {
    if (state == null ||
        state!.nextPagePath == null ||
        state!.removeUntil == null) {
      return;
    }
    routingService.switchToPageFromPath(state!.nextPagePath!,
        removeUntil: state?.removeUntil!);
  }
}

class NavigateRequestState extends ChangeNotifier {
  NavigateRequest lastRequest = NavigateRequest.none;
  String? nextPagePath;
  List<String>? removeUntil;
  bool? popResult;

  void updateWith({
    required NavigateRequest lastRequest,
    String? nextPagePath,
    List<String>? removeUntil,
    bool? popResult,
  }) {
    this.lastRequest = lastRequest;
    this.nextPagePath = nextPagePath;
    this.removeUntil = removeUntil;
    this.popResult = popResult;
    notifyListeners();
  }

  void clear() {
    lastRequest = NavigateRequest.none;
    removeUntil = null;
    nextPagePath = null;
    popResult = null;
  }

  void acceptPopRequest(
    bool popResult,
  ) {
    updateWith(popResult: popResult, lastRequest: NavigateRequest.pop);
  }

  void acceptRemoveUntilRequest(List<String> removeUntil) {
    updateWith(removeUntil: removeUntil, lastRequest: NavigateRequest.removeUntil);
  }

  void acceptGoPreviousRequest() {
    updateWith(lastRequest: NavigateRequest.goPrevious);
  }

  void acceptGoNextRequest() {
    updateWith(lastRequest: NavigateRequest.goNext);
  }

  void acceptPushNamedRequest(
    String nextPagePath,
  ) {
    updateWith(
      lastRequest: NavigateRequest.pushNamed,
      nextPagePath: nextPagePath,
    );
  }

  void acceptPushReplacementNamedRequest(
    String nextPagePath,
  ) {
    updateWith(
      lastRequest: NavigateRequest.pushReplacementNamed,
      nextPagePath: nextPagePath,
    );
  }

  void acceptPushNamedAndRemoveUntilRequest(
    String nextPagePath,
    List<String> removeUntil,
  ) {
    updateWith(
      lastRequest: NavigateRequest.pushNamedAndRemoveUntil,
      nextPagePath: nextPagePath,
      removeUntil: removeUntil,
    );
  }
}
