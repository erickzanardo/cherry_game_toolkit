// Not required for test files
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:level_progress/level_progress.dart';

void main() {
  group('LevelProgress', () {
    test('can be instantiated', () {
      expect(LevelProgress(), isNotNull);
    });
  });
}
