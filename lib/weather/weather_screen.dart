import 'package:dvt_weather/weather/cubit/weather_cubit.dart';
import 'package:dvt_weather/weather/weather_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<WeatherCubit, WeatherState>(
        listener: (context, state) {
          state.whenOrNull(
            searchedPlace: (place) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                          'Did you mean ${place.places[0].addressComponents[0].shortText}?'),
                      actions: [
                        MaterialButton(
                            onPressed: () {
                              context.read<WeatherCubit>().getWeather();
                              Navigator.pop(context);
                            },
                            child: const Text('Nope')),
                        MaterialButton(
                            onPressed: () {
                              context
                                  .read<WeatherCubit>()
                                  .getWeather(place: place);
                              Navigator.pop(context);
                            },
                            child: const Text('Yes'))
                      ],
                    );
                  });
            },
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
