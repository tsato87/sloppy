import 'package:flutter/material.dart';
import 'package:sloppy/utils/observer.dart';

abstract class ChangeNotifierWithAppLifecycleObserver extends ChangeNotifier
    with WidgetsBindingObserver {
  final appLifecycleStateChanged = Observer();
  final resumed = Observer();
  final inactive = Observer();
  final paused = Observer();
  final detached = Observer();

  ChangeNotifierWithAppLifecycleObserver() {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    /* Notify specific observer */
    Observer? observer = <AppLifecycleState, Observer>{
      AppLifecycleState.resumed: resumed,
      AppLifecycleState.inactive: inactive,
      AppLifecycleState.paused: paused,
      AppLifecycleState.detached: detached,
    }[state];
    if(observer==null){
      // TODO: Add log output
    }
    List<dynamic> emptyArgs = [];
    appLifecycleStateChanged.emit(emptyArgs);
    observer?.emit(emptyArgs);
  }
}