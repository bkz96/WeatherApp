import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/model/Weather_data.dart';

// Events
abstract class WeatherEvent {}

class FetchWeather extends WeatherEvent {
  final String city;

  FetchWeather(this.city);
}

// States
abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherData weatherData;

  WeatherLoaded(this.weatherData);
}

class WeatherError extends WeatherState {
  final String error;

  WeatherError(this.error);
}

// BLoC (Weather Api Call)
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial());

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    if (event is FetchWeather) {
      yield WeatherLoading();
      try {
        final response = await http.get(
          Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=${event.city}&appid=1b28f349fb87541b2b89e6095157d0f9'),
        );
        WeatherData weatherData = WeatherData.fromJson(json.decode(response.body));
        yield WeatherLoaded(weatherData);
      } catch (e) {
        yield WeatherError('Failed to fetch weather data.');
      }
    }
  }

  onTapWeather(WeatherBloc weatherBloc, BuildContext context, TextEditingController controller){
    if(controller.text != "") {
      weatherBloc.add(FetchWeather(controller.text));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter City', style: TextStyle(
            color: Colors.red
        ),),
      ));
    }
  }
}