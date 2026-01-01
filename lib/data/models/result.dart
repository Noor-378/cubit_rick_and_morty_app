import 'charecters.dart';

class CharactersPageResult {
  final List<Character> characters;
  final bool hasNextPage;

  CharactersPageResult({
    required this.characters,
    required this.hasNextPage,
  });
}
