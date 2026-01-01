import 'package:cubit_rick_and_morty_app/business_logic/cubit/charecters_cubit.dart';
import 'package:cubit_rick_and_morty_app/constants/strings.dart';
import 'package:cubit_rick_and_morty_app/data/models/charecters.dart';
import 'package:cubit_rick_and_morty_app/data/repository/charecters_repository.dart';
import 'package:cubit_rick_and_morty_app/data/web_services/charecters_web_services.dart';
import 'package:cubit_rick_and_morty_app/presentation/screens/charecter_details_screen.dart';
import 'package:cubit_rick_and_morty_app/presentation/screens/charecters_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  late CharectersRepository charectersRepository;
  late CharectersCubit charectersCubit;

  AppRouter() {
    charectersRepository = CharectersRepository(
      charectersWebServices: CharectersWebServices(),
    );
    charectersCubit = CharectersCubit(charectersRepository);
  }
  // ignore: body_might_complete_normally_nullable
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case charectersScreen:
        return MaterialPageRoute(
          builder:
              (BuildContext context) => BlocProvider(
                create: (BuildContext context) => charectersCubit,
                child: const CharectersScreen(),
              ),
        );
      case characterDetailsScreen:
        final character = settings.arguments as Character;
        return MaterialPageRoute(
          builder: (BuildContext context) =>  CharecterDetailsScreen(character: character),
        );
    }
  }
}
