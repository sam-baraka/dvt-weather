import 'package:dvt_weather/favorites/models/favorite.dart';
import 'package:dvt_weather/services/favorites_persistence_service.dart';
import 'package:dvt_weather/utils/app_colors.dart';
import 'package:dvt_weather/weather/cubit/weather_cubit.dart';
import 'package:dvt_weather/weather/weather_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:open_weather_api/open_weather_api.dart';

class WeatherView extends StatelessWidget {
  WeatherView(
      {super.key,
      required this.weather,
      FavoritesPersistenceService? favoritesPersistenceService})
      : favoritesPersistenceService =
            favoritesPersistenceService ?? FavoritesPersistenceService();

  final FavoritesPersistenceService favoritesPersistenceService;

  final formKey = GlobalKey<FormState>();
  final WeatherData weather;

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: getWeatherType(weather.current.weather[0].main) == 'sunny'
          ? AppColors.sunny
          : getWeatherType(weather.current.weather[0].main) == 'rainy'
              ? AppColors.rainy
              : AppColors.cloudy,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              Image.asset(
                getWeatherType(weather.current.weather[0].main) == 'sunny'
                    ? 'assets/images/forest_sunny.png'
                    : getWeatherType(weather.current.weather[0].main) == 'rainy'
                        ? 'assets/images/forest_rainy.png'
                        : 'assets/images/forest_cloudy.png',
                fit: BoxFit.fill,
                width: MediaQuery.of(context).size.width,
              ),
              Positioned(
                top: 16,
                right: 16,
                bottom: 16,
                left: 16,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(weather.timezone,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 24)),
                      Text(
                        '${weather.current.temp}°C',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 28),
                      ),
                      Text(
                        weather.current.weather[0].description.toUpperCase(),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CupertinoButton(
                        onPressed: () {
                          showAdaptiveDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Favorite'),
                                  content: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CupertinoButton(
                                          child: const Text('Like this place'),
                                          onPressed: () {
                                            favoritesPersistenceService
                                                .addFavorite(Favorite(
                                                    name: weather.timezone,
                                                    lat: weather.lat,
                                                    lon: weather.lon));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        '${weather.timezone} added to favorites')));
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                            }
                                          }),
                                      CupertinoButton(
                                          child:
                                              const Text('View Liked Places'),
                                          onPressed: () {
                                            context.go('/favorites');
                                          })
                                    ],
                                  ),
                                );
                              });
                        },
                        color: Colors.black38,
                        padding: EdgeInsets.zero,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Favorite',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Form(
                          key: formKey,
                          child: CupertinoTextFormFieldRow(
                            controller: searchController,
                            placeholder: 'Search place',
                            prefix: const Icon(
                              Icons.place,
                              color: Colors.white,
                            ),
                            onFieldSubmitted: (value) {
                              if (formKey.currentState!.validate()) {
                                context
                                    .read<WeatherCubit>()
                                    .searchPlace(name: value);
                              }
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please enter a location';
                              }
                              return null;
                            },
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${weather.current.temp}°C',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              )),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: weather.daily
                  .map((e) => InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(e.weather[0].main,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  content: Text(e.summary,
                                      style:
                                          const TextStyle(color: Colors.white)),
                                  backgroundColor: getWeatherType(weather
                                              .current.weather[0].main) ==
                                          'sunny'
                                      ? AppColors.sunny
                                      : getWeatherType(weather
                                                  .current.weather[0].main) ==
                                              'rainy'
                                          ? AppColors.rainy
                                          : AppColors.cloudy,
                                );
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  DateFormat('EEEE')
                                      .format(DateTime.parse(e.dt.toString())),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                              const Spacer(),
                              Image.asset(
                                getWeatherType(
                                            weather.current.weather[0].main) ==
                                        'sunny'
                                    ? 'assets/icons/clear.png'
                                    : getWeatherType(weather
                                                .current.weather[0].main) ==
                                            'rainy'
                                        ? 'assets/icons/rain.png'
                                        : 'assets/icons/partlysunny.png',
                                height: 40,
                              ),
                              const Spacer(),
                              Text('${e.temp.min}°C',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16)),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ))
        ],
      ),
    );
  }
}
