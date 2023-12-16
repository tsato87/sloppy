import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'root.dart';
import 'services/local_storage/local_storage_service_provider.dart';
import 'services/local_storage/parameter_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final sharedPreferences = await SharedPreferences.getInstance();
  runApp(ProviderScope(
      overrides: [
        parameterHandlerProvider.overrideWithValue(
          ParameterHandler(sharedPreferences),
        ),
      ],
      child: const Sloppy())
  );
}