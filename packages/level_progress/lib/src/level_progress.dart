import 'package:hydrated_bloc/hydrated_bloc.dart';

/// {@template game_progress_cubit}
/// A [Cubit] that manages the player's progress through game levels.
/// It persists the current level using hydrated storage.
/// {@endtemplate}
class GameProgressCubit extends HydratedCubit<int> {
  /// {@macro game_progress_cubit}
  GameProgressCubit({
    required this.maxLevel,
  }) : super(0);

  /// The maximum level a player can reach.
  final int maxLevel;

  /// Advances the player to the next level if not already at max level.
  void advanceLevel() {
    if (state < maxLevel) {
      emit(state + 1);
    }
  }

  /// Resets the player's progress to level 0.
  void reset() {
    emit(0);
  }

  /// Returns the next level number, or null if at max level.
  int? get nextLevel => isMaxLevel ? null : state + 1;

  /// Checks if the player has reached the maximum level.
  bool get isMaxLevel => state >= maxLevel;

  @override
  int? fromJson(Map<String, dynamic> json) {
    return json['level'] as int?;
  }

  @override
  Map<String, dynamic>? toJson(int state) {
    return {'level': state};
  }
}
