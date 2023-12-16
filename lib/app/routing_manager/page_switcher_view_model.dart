import 'package:flutter/material.dart';

import '../../services/routing/routing_service.dart';


class PageSwitcherViewModel extends ChangeNotifier {
  String? initialPagePath;
  List<String> instantiatedPagePaths = [];
  int currentPageIndex = -999;
  final RoutingService routingService;
  late final List<String> persistentPagePaths;
  late final Map<String, PageBuilder> pageRoutes;

  PageSwitcherViewModel(this.routingService) {
    persistentPagePaths = routingService.getPersistentPagePaths();
    pageRoutes = routingService.getPageRoutes();
    routingService.setRequestedChangePageCallback(_updatedRequestedPagePath);
    initialPagePath = routingService.getInitialPagePath();
    if (initialPagePath != null){
      instantiatedPagePaths.add(initialPagePath!);
      currentPageIndex = 0;
    }
  }

  bool _isPersistentPagePath(String path) {
    return persistentPagePaths.contains(path);
  }

  bool _isDisposablePagePath(String path) {
    return (pageRoutes.containsKey(path) && !_isPersistentPagePath(path));
  }

  String? _getInstantiatedDisposablePagePath() {
    for (String instantiatedPagePath in instantiatedPagePaths) {
      if (_isDisposablePagePath(instantiatedPagePath)) {
        return instantiatedPagePath;
      }
    }
    return null;
  }

  void _updatedRequestedPagePath(List<dynamic> args) {
    String path = args[0];
    String? instantiatedDisposablePagePath =
        _getInstantiatedDisposablePagePath();
    if ((instantiatedDisposablePagePath != null) &&
        (instantiatedDisposablePagePath != path)) {
      instantiatedPagePaths.remove(instantiatedDisposablePagePath);
    }
    if (!instantiatedPagePaths.contains(path)) {
      instantiatedPagePaths.add(path);
    }
    currentPageIndex = instantiatedPagePaths.indexOf(path);
    notifyListeners();
  }
}
