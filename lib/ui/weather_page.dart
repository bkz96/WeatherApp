import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/model/Weather_data.dart';

import '../bloc/weather_bloc.dart';

class WeatherPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    final WeatherBloc weatherBloc = BlocProvider.of<WeatherBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Enter city'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                weatherBloc.onTapWeather(weatherBloc, context, _controller);
                //_onTapWeather(weatherBloc, context);
              },
              child: const Text('Get Weather'),
            ),
            const SizedBox(height: 16),
            BlocBuilder<WeatherBloc, WeatherState>(
              builder: (context, state) {
                if (state is WeatherLoading) {
                  return const CircularProgressIndicator();
                } else if (state is WeatherLoaded) {
                  WeatherData weatherData = state.weatherData;
                  return Column(
                    children: [
                      Text(
                          'Current temprature: ${(weatherData.main!.temp! - 273.15).toStringAsFixed(2)}'),
                      const SizedBox(
                        height: 20,
                      ),
                      Text('Weather: ${weatherData.toJson().toString()}'),
                    ],
                  );
                } else if (state is WeatherError) {
                  return Text('Error: ${state.error}');
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
