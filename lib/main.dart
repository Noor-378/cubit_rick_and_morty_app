import 'package:cubit_rick_and_morty_app/app_router.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp(appRouter: AppRouter()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.appRouter});

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(onGenerateRoute: appRouter.generateRoute);
  }
}







// ================================================================================
// ==================================/ BLOC \======================================
// ================================================================================

// Bloc is:
// - design pattern
// - state management // state mean data
// - architeture pattern
//
// =====================================
//
// Bloc stand for: Business Logic Component
// =====================================
//
// Bloc split the app to modules (layers):
//
// - Presentation Layer (UI) (send event/action)(take state)
// - Business Logic Layer (send request)(take response)
// - Data Layer (send response)(take request)
//
// ==============================================
// How the BLoC Pattern Works:
//
// UI
//  ↓ event
//  ↓
// Cubit
//  ↓ request
//  ↓
// Data
//  ↓ response
//  ↓
// Cubit
//  ↓ state
//  ↓
// UI
//
// ==============================================
//
// more about data layer:
//
// Cubit
//  ↓ request
//  ↓
// Repository
//  ↓ go to 
//  ↓
// Web Service
//  ↓ raw data
//  ↓
// Model
//  ↓
// Repository
//  ↓ response
//  ↓
// Cubit
//
//
// ================================================
//
// Widgets in Cubit (Concepts):
//
// BlocProvider:
// - Creates the Cubit / BLoC and provides it to all widgets
//   under it in the widget tree
// - Gives you a single instance of the Cubit
// - By default, it is lazy:
//   the Cubit is not created until the UI calls it
// - Access the Cubit using:
//   BlocProvider.of<CubitType>(context)
//
// --------------------------------------------
//
// BlocProvider.value:
// - Used when you already have an existing Cubit instance
// - Useful when passing the Cubit to another screen or widget
//   (similar to Get.find in GetX)
// - Does NOT create a new Cubit
// - Example usage:
//   BlocProvider.value(
//     value: cubit,
//     child: ChildWidget(),
//   )
//
// --------------------------------------------
//
// BlocBuilder:
// - Listens to the Cubit states
// - Rebuilds the UI when a new state is emitted
// - Can rebuild multiple times (on every state change)
// - Should be used only on the widget that needs rebuilding in the widget tree
//   to avoid unnecessary rebuilds
//
// --------------------------------------------
//
// BlocListener:
// - listens to the Cubit state changes
// - does NOT rebuild the UI
// - similar to BlocBuilder but without rebuild
// - listens on every state change, without rebuild
//
// --------------------------------------------
//
// BlocConsumer:
// - Combines BlocBuilder and BlocListener
// - Rebuilds the UI AND listens to state changes
// - Used when you need both build and listen in one widget