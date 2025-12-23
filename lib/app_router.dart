import 'package:cubit_rick_and_morty_app/constants/strings.dart';
import 'package:cubit_rick_and_morty_app/presentation/screens/charecter_details_screen.dart';
import 'package:cubit_rick_and_morty_app/presentation/screens/charecters_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case charectersScreen:
        return MaterialPageRoute(builder: (context) => CharectersScreen());
      case charecterDetailsScreen:
        return MaterialPageRoute(builder: (context) => CharecterDetailsScreen());
    }
  }
}
