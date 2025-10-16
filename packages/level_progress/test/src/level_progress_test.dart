import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:level_progress/level_progress.dart';
import 'package:mocktail/mocktail.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  group('GameProgressCubit', () {
    late Storage storage;

    setUp(() {
      storage = MockStorage();
      when(
        () => storage.write(any(), any<dynamic>()),
      ).thenAnswer((_) async {});
      HydratedBloc.storage = storage;
    });
    test('can be instantiated', () {
      expect(GameProgressCubit(maxLevel: 5), isNotNull);
    });

    test('initial state is 0', () {
      expect(GameProgressCubit(maxLevel: 5).state, equals(0));
    });

    group('advanceLevel', () {
      test('increments state by 1 if below maxLevel', () {
        final cubit = GameProgressCubit(maxLevel: 3)..advanceLevel();
        expect(cubit.state, equals(1));
        cubit.advanceLevel();
        expect(cubit.state, equals(2));
      });

      test('does not increment state if at maxLevel', () {
        final cubit = GameProgressCubit(maxLevel: 2)
          ..advanceLevel()
          ..advanceLevel();
        expect(cubit.state, equals(2));
        cubit.advanceLevel();
        expect(cubit.state, equals(2));
      });
    });

    group('reset', () {
      test('resets state to 0', () {
        final cubit = GameProgressCubit(maxLevel: 5)
          ..advanceLevel()
          ..advanceLevel();
        expect(cubit.state, equals(2));
        cubit.reset();
        expect(cubit.state, equals(0));
      });
    });
  });
}
