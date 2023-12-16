import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sloppy/services/routing/routing_service.dart';
import 'package:sloppy/services/routing/routing_service_provider.dart';

import 'package:sloppy/app/routing_manager/page_switcher_view_model.dart';


final pageSwitcherViewModelProvider =
ChangeNotifierProvider<PageSwitcherViewModel>((ref) {
  RoutingService routingService = ref.watch(routingServiceProvider);
  return PageSwitcherViewModel(routingService);
});