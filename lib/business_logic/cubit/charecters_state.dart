part of 'charecters_cubit.dart';

@immutable
sealed class CharectersState {}

final class CharectersInitial extends CharectersState {}

final class CharectersLoading extends CharectersState {
  final List<Character> oldCharacters;
  final bool isFirstFetch;

  CharectersLoading({
    required this.oldCharacters,
    required this.isFirstFetch,
  });
}

final class CharectersLoaded extends CharectersState {
  final List<Character> characters;
  final bool hasNextPage;

  CharectersLoaded({
    required this.characters,
    required this.hasNextPage,
  });
}

final class CharectersError extends CharectersState {
  final String message;
  CharectersError(this.message);
}
