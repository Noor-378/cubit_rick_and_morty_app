import '../models/charecters.dart';
import '../models/result.dart';
import '../web_services/charecters_web_services.dart';

class CharectersRepository {
  final CharectersWebServices charectersWebServices;

  CharectersRepository({required this.charectersWebServices});

  Future<CharactersPageResult> getAllCharecters(int page) async {
    final data = await charectersWebServices.getAllCharecters(page);

    final List results = data['results'];
    final bool hasNextPage = data['info']['next'] != null;

    return CharactersPageResult(
      characters: results
          .map((json) => Character.fromJson(json))
          .toList(),
      hasNextPage: hasNextPage,
    );
  }
}
