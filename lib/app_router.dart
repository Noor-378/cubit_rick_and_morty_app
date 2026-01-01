import 'business_logic/cubit/charecters_cubit.dart';
import 'constants/strings.dart';
import 'data/models/charecters.dart';
import 'data/repository/charecters_repository.dart';
import 'data/web_services/charecters_web_services.dart';
import 'presentation/screens/charecter_details_screen.dart';
import 'presentation/screens/charecters_screen.dart';
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
