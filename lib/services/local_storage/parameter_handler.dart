import 'package:shared_preferences/shared_preferences.dart';
import '../../app/auth/sign_in/sign_in_viewmodel.dart';
import '../../../parameters.dart';

enum ParameterType {
  string,
  int,
  double,
  bool,
  signInMethod,
}

class ParameterHandler {
  late final SharedPreferences sharedPreferences;
  late Map<ParameterType, BaseCache> parameterTypeToHandler;

  ParameterHandler(this.sharedPreferences) {
    parameterTypeToHandler = {
      ParameterType.string: StringCache(sharedPreferences),
      ParameterType.int: IntCache(sharedPreferences),
      ParameterType.double: DoubleCache(sharedPreferences),
      ParameterType.bool: BoolCache(sharedPreferences),
      ParameterType.signInMethod: EnumCache<LastSignInMethodStatus>(
          sharedPreferences,
          LastSignInMethodStatus.values),
    };
  }

  dynamic get(ParameterKey key, {void Function(String)? byName}) {
    ParameterType parameterType;
    dynamic defaultValue;
    (parameterType, defaultValue) = parameters[key]!;
    BaseCache cache = parameterTypeToHandler[parameterType]!;
    return cache.get(key) ?? defaultValue;
  }

  Future<bool> set(ParameterKey key, dynamic value) {
    ParameterType parameterType;
    dynamic unusedDefaultValue;
    (parameterType, unusedDefaultValue) = parameters[key]!;
    BaseCache cache = parameterTypeToHandler[parameterType]!;
    return cache.set(key, value);
  }

  Future<bool> clear(ParameterKey key) {
    ParameterType parameterType;
    dynamic unusedDefaultValue;
    (parameterType, unusedDefaultValue) = parameters[key]!;
    BaseCache cache = parameterTypeToHandler[parameterType]!;
    return cache.clear(key);
  }
}

class BaseCache {
  final SharedPreferences sharedPreferences;
  BaseCache(this.sharedPreferences);

  dynamic get(ParameterKey key) {
    throw UnimplementedError();
  }

  Future<bool> set(ParameterKey key, dynamic value) {
    throw UnimplementedError();
  }

  Future<bool> clear(ParameterKey key) {
    return sharedPreferences.remove(key.toString());
  }
}

class IntCache extends BaseCache {
  IntCache(super.sharedPreferences);

  @override
  int? get(ParameterKey key) {
    return sharedPreferences.getInt(key.toString());
  }

  @override
  Future<bool> set(ParameterKey key, value) {
    return sharedPreferences.setInt(key.toString(), value as int);
  }
}

class DoubleCache extends BaseCache {
  DoubleCache(super.sharedPreferences);

  @override
  double? get(ParameterKey key) {
    return sharedPreferences.getDouble(key.toString());
  }

  @override
  Future<bool> set(ParameterKey key, value) {
    return sharedPreferences.setDouble(key.toString(), value as double);
  }
}

class StringCache extends BaseCache {
  StringCache(super.sharedPreferences);

  @override
  String? get(ParameterKey key) {
    return sharedPreferences.getString(key.toString());
  }

  @override
  Future<bool> set(ParameterKey key, value) {
    return sharedPreferences.setString(key.toString(), value as String);
  }
}

class BoolCache extends BaseCache {
  BoolCache(super.sharedPreferences);

  @override
  bool? get(ParameterKey key) {
    return sharedPreferences.getBool(key.toString());
  }

  @override
  Future<bool> set(ParameterKey key, value) {
    return sharedPreferences.setBool(key.toString(), value as bool);
  }
}

class EnumCache<T> extends BaseCache {
  final List<T> values;
  EnumCache(super.sharedPreferences, this.values);

  @override
  T? get(ParameterKey key) {
    String? stringValue = sharedPreferences.getString(key.toString());
    if (stringValue == null) {
      return null;
    }
    return values.where((value) => value.toString() == stringValue).first;
  }

  @override
  Future<bool> set(ParameterKey key, value) {
    return sharedPreferences.setString(key.toString(), value.toString());
  }
}
