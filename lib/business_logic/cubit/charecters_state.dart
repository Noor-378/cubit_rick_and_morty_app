part of 'charecters_cubit.dart';

@immutable
sealed class CharectersState {}

final class CharectersInitial extends CharectersState {}
// final class CharectersErrorCase extends CharectersState {}

final class CharectersLoaded extends CharectersState {
  final List<Character> characters;
  CharectersLoaded(this.characters);
}
