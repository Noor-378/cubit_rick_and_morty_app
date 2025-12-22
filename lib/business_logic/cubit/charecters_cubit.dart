import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'charecters_state.dart';

class CharectersCubit extends Cubit<CharectersState> {
  CharectersCubit() : super(CharectersInitial());
}
