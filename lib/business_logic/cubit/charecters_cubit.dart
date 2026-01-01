import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/charecters.dart';
import '../../data/repository/charecters_repository.dart';

part 'charecters_state.dart';

class CharectersCubit extends Cubit<CharectersState> {
  CharectersCubit(this.repository) : super(CharectersInitial());

  final CharectersRepository repository;

  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isLoading = false;

  final List<Character> _characters = [];

  Future<void> fetchCharacters() async {
    if (_isLoading || !_hasNextPage) return;

    _isLoading = true;

    emit(
      CharectersLoading(
        oldCharacters: List.from(_characters),
        isFirstFetch: _currentPage == 1,
      ),
    );

    try {
      final result = await repository.getAllCharecters(_currentPage);

      _characters.addAll(result.characters);
      _hasNextPage = result.hasNextPage;
      _currentPage++;

      emit(
        CharectersLoaded(
          characters: List.from(_characters),
          hasNextPage: _hasNextPage,
        ),
      );
    } catch (e) {
      emit(CharectersError(e.toString()));
    }

    _isLoading = false;
  }

  void refresh() {
    _currentPage = 1;
    _hasNextPage = true;
    _characters.clear();
    fetchCharacters();
  }
}
