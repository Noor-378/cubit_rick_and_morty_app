import 'dart:developer';

import 'package:cubit_rick_and_morty_app/data/models/charecters.dart';
import 'package:cubit_rick_and_morty_app/data/repository/charecters_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'charecters_state.dart';

class CharectersCubit extends Cubit<CharectersState> {
  CharectersCubit(this.charectersRepository) : super(CharectersInitial());

  final CharectersRepository charectersRepository;
  List<Character>? characters;

  List<Character> getAllCharacters() {
    charectersRepository.getAllCharecters().then((characters) {
      emit(CharectersLoaded(characters));
      this.characters = characters;
    });
    return characters ?? [];
  }
}
