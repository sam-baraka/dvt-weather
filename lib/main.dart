import 'package:dvt_weather/favorites/favorites_screen.dart';
import 'package:dvt_weather/firebase_options.dart';
import 'package:dvt_weather/weather/cubit/weather_cubit.dart';
import 'package:dvt_weather/weather/weather_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  await Hive.openBox('favorites');
  runApp(BlocProvider(
    create: (context) => WeatherCubit()..getWeather(),
    child: const WeatherApp(),
  ));
}

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const WeatherScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/favorites',
          builder: (context, state) {
            return FavoritesScreen();
          },
        )
      ],
    ),
  ],
);

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}


