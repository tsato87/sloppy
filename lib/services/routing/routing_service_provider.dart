import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../route.dart';
import 'routing_service.dart';


final routingServiceProvider = Provider<RoutingService>((ref) {
  return RoutingService(
      initialPagePath: initialPagePath,
      persistentPagePaths: persistentPagePaths,
      pageRoutes: pageRoutes);
});
