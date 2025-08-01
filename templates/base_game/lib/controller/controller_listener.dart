enum ControllerEventType { up, down }

typedef ControllerListenerFn<T> = void Function(T, ControllerEventType);

class ControllerListener<T> {
  final List<ControllerListenerFn<T>> _listeners = [];

  void addListener(ControllerListenerFn<T> listener) {
    _listeners.add(listener);
  }

  void removeListener(ControllerListenerFn<T> listener) {
    _listeners.remove(listener);
  }

  void removeAllListeners() {
    _listeners.clear();
  }

  void trigger(T key, ControllerEventType eventType) {
    if (_listeners.isEmpty) {
      return;
    }
    _listeners.last(key, eventType);
  }
}
