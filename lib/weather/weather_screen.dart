import 'package:dvt_weather/utils/app_colors.dart';
import 'package:dvt_weather/weather/cubit/weather_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_weather_api/open_weather_api.dart';
import 'package:intl/intl.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<WeatherCubit, WeatherState>(
        listener: (context, state) {
          state.whenOrNull(
            error: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            },
          );
        },
        builder: (context, state) {
          return state.maybeWhen(fetched: (weather) {
            return WeatherView(weather: weather);
          }, fetching: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }, orElse: () {
            return Center(
              child: MaterialButton(
                  child: const Text('Something Happened,Tap to Try Again'),
                  onPressed: () {
                    context.read<WeatherCubit>().getWeather();
                  }),
            );
          });
        },
      ),
    );
  }
}

class WeatherView extends StatelessWidget {
  final WeatherData weather;
  const WeatherView({super.key, required this.weather});

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

getWeatherType(String input) {
  if (input.toLowerCase().contains('cloud')) {
    return 'cloudy';
  }
  if (input.toLowerCase().contains('rain')) {
    return 'rainy';
  }
  if (input.toLowerCase().contains('clear')) {
    return 'sunny';
  }
}
