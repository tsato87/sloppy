import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'parameter_handler.dart';
import 'secure_storage_service.dart';


final flutterSecureStorageServiceProvider = Provider<FlutterSecureStorageService>((ref) {
  return FlutterSecureStorageService();
});

final parameterHandlerProvider =
Provider<ParameterHandler>((ref) => throw UnimplementedError());