import 'package:sloppy/app/auth/sign_in/sign_in_viewmodel.dart';

import 'services/local_storage/parameter_handler.dart';

enum ParameterKey {
  signInMethod,
  isDark,
  lastLat,
  lastLon,
}

const Map<ParameterKey, (ParameterType, dynamic)> parameters = {
  ParameterKey.signInMethod: (ParameterType.signInMethod, LastSignInMethodStatus.noCached),
  ParameterKey.isDark: (ParameterType.bool, true),
  ParameterKey.lastLat: (ParameterType.double, null),
  ParameterKey.lastLon: (ParameterType.double, null),
};
