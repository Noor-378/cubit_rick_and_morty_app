import 'package:cubit_rick_and_morty_app/data/models/charecters.dart';

class CharactersPageResult {
  final List<Character> characters;
  final bool hasNextPage;

  CharactersPageResult({
    required this.characters,
    required this.hasNextPage,
  });
}
