import 'package:cubit_rick_and_morty_app/data/models/charecters.dart';
import 'package:cubit_rick_and_morty_app/data/web_services/charecters_web_services.dart';

class CharectersRepository {
  final CharectersWebServices? charectersWebServices;

  CharectersRepository({required this.charectersWebServices});
  Future<List<Character>> getAllCharecters() async {
    final data = await charectersWebServices!.getAllCharecters();

    final List results = data['results'];

    return results.map((json) => Character.fromJson(json)).toList();
  }
}
