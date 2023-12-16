import 'package:flutter/material.dart';

import '../../utils/observer.dart';

typedef PageBuilder = Widget Function(BuildContext);

class RoutingService {
  final String? initialPagePath;
  final List<String> persistentPagePaths;
  final Map<String, PageBuilder> pageRoutes;

  List<String> history = [];
  int currentIndex = -1;
  int? indexStep;
  Observer requested = Observer();

  RoutingService(
      {required this.persistentPagePaths,
      required this.pageRoutes,
      this.initialPagePath});

  List<String> getPersistentPagePaths() => persistentPagePaths;
  Map<String, PageBuilder> getPageRoutes() => pageRoutes;

  String? getInitialPagePath() {
    if (initialPagePath != null) {
      history.add(initialPagePath!);
      currentIndex = 0;
    }
    return initialPagePath;
  }

  bool get canGoPrevious {
    return currentIndex < (history.length - 1);
  }

  void setRequestedChangePageCallback(void Function(List<dynamic>) callback) {
    requested.registerCallback(callback);
  }

  void _updateWithIndexStep(int indexStep) {
    currentIndex = currentIndex + indexStep;
    String localNextPagePath = history[currentIndex];
    String requestedPagePath = localNextPagePath;
    List<dynamic> args = [requestedPagePath];
    requested.emit(args);
  }

  void _updateWithNextPagePath(String nextPagePath,
      {bool removeAll = false, List<String>? removeUntil}) {
    String requestedPagePath = nextPagePath;
    if (history.isNotEmpty) {
      history = history.sublist(currentIndex);
    }
    if (removeAll) {
      history.clear();
    } else if (removeUntil != null) {
      int index =
          history.indexWhere((element) => removeUntil.contains(element));
      history = history.sublist(index);
    }
    history.insert(0, requestedPagePath);
    currentIndex = 0;
    List<dynamic> args = [requestedPagePath];
    requested.emit(args);
  }

  void removeUntil(List<String> removeUntil) {
    int index = history.indexWhere((element) => removeUntil.contains(element));
    history = history.sublist(index);
    currentIndex = 0;
    List<dynamic> args = [history[currentIndex]];
    requested.emit(args);
  }

  void switchToPageFromPath(path,
      {bool removeAll = false, List<String>? removeUntil}) {
    _updateWithNextPagePath(path,
        removeAll: removeAll, removeUntil: removeUntil);
  }

  void switchToNextPage() {
    assert(currentIndex != 0);
    _updateWithIndexStep(-1);
  }

  void switchToPreviousPage() {
    assert(currentIndex != (history.length - 1));
    _updateWithIndexStep(1);
  }
}
