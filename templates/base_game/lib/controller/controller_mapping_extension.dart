import 'package:flutter/services.dart';

extension KeyboardMappingExtension<T> on Map<T, LogicalKeyboardKey> {
  T? findControl(LogicalKeyboardKey key) {
    final result = entries.where((element) => element.value == key);

    return result.isNotEmpty ? result.first.key : null;
  }
}
