import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../models/weather_model.dart';
import '../service/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService('(Your API key)');
  Weather? _weather;

  // fetch weather
  _fetchWeather() async {
    // get the currrent city
    String cityName = await _weatherService.getCurrentCity();

    // get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }

    // any errors
    catch (e) {
      print(e);
    }
  }

  // weather animations
  String getWeatherAnimation(String? mainCondition) {
    switch (mainCondition?.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'Assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'Assets/rain.json';
      case 'thunderstorm':
        return 'Assets/thunderstorm.json';
      case 'clear':
        return 'Assets/sunny.json';
      default:
        return 'Assets/sunny.json';
    }
  }

  // init state
  @override
  void initState() {
    super.initState();

    // fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 56, 94, 183),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // logo
            Lottie.asset('Assets/logo.json', height: 100),

            // city name
            Text(_weather?.cityName ?? "loading city..",
                style: const TextStyle(color: Colors.white, fontSize: 30)),

            // weather animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),

            // temperature
            Text('${_weather?.temperature.round()} °C',
                style: const TextStyle(color: Colors.white, fontSize: 20)),

            // weather condition
            Text(_weather?.mainCondition ?? "",
                style: const TextStyle(color: Colors.white, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
