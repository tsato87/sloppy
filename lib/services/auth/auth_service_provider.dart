import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sloppy/services/local_storage/parameter_handler.dart';

import '../local_storage/local_storage_service_provider.dart';
import '../local_storage/secure_storage_service.dart';
import 'auth_service.dart';


final authServiceProvider = Provider<AuthService>((ref){
  ParameterHandler parameterHandler = ref.watch(parameterHandlerProvider);
  FlutterSecureStorageService secureStorageService = ref.watch(flutterSecureStorageServiceProvider);
  return AuthService(parameterHandler, secureStorageService);
});
