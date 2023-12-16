class Observer {
  List<void Function(List<dynamic>)> callbacks = [];

  void registerCallback(void Function(List<dynamic>) callback) {
    callbacks.add(callback);
  }

  void clear() {
    callbacks = [];
  }

  void emit(List<dynamic> args) {
    for (void Function(List<dynamic>) callback in callbacks) {
      try {
        callback(args);
      } catch (e) {
        // TODO
      }
    }
  }
}
