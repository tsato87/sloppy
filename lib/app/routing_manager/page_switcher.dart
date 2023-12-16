import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/routing/routing_service.dart';
import 'page_switcher_app_provider.dart';
import 'page_switcher_view_model.dart';


class PageSwitcher extends ConsumerStatefulWidget {
  const PageSwitcher({super.key});

  @override
  ConsumerState<PageSwitcher> createState() {
    return PageSwitcherState();
  }
}

class PageSwitcherState extends ConsumerState<PageSwitcher> {
  Map<String, Widget> pathAndPages = {};
  Map<String, PageBuilder>? routes;

  @override
  void initState() {
    super.initState();
    PageSwitcherViewModel viewModel = ref.read(pageSwitcherViewModelProvider);
    routes = viewModel.pageRoutes;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void updatePages(
      BuildContext context, List<String> pagePathsToInstantiation) {
    Set<String> instantiatedPagePath = pathAndPages.keys.toSet();
    Set<String> pagePathsToRemove =
        instantiatedPagePath.difference(pagePathsToInstantiation.toSet());
    pathAndPages.removeWhere(
        (String key, Widget unusedValue) => pagePathsToRemove.contains(key));
    Set<String> pagePathsToAdd =
        pagePathsToInstantiation.toSet().difference(instantiatedPagePath);
    for (String pagePath in pagePathsToAdd) {
      PageBuilder pageBuilder = routes![pagePath]!;
      Widget page = pageBuilder(context);
      pathAndPages[pagePath] = page;
      pathAndPages = {
        for (String key in pagePathsToInstantiation) key: pathAndPages[key]!
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    PageSwitcherViewModel viewModel = ref.watch(pageSwitcherViewModelProvider);
    updatePages(context, viewModel.instantiatedPagePaths);
    return IndexedStack(
        index: viewModel.currentPageIndex,
        children: pathAndPages.values.toList());
  }
}
