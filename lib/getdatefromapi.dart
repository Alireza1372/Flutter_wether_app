import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weather/main.dart';

const myAPI = "221371ffe1d44f91ad1110024231511";

// ignore: must_be_immutable
class GetDataFromApi extends StatelessWidget {
  String API_KEY = "221371ffe1d44f91ad1110024231511";

  String location = '';

  String weatherIcon = '';

  int temperature = 0;

  int windSpeed = 0;

  int humidity = 0;

  int cloud = 0;
  int responseCode = 404;

  Map<dynamic, dynamic> weatherData = {};
  Map<dynamic, dynamic> locationData = {};
  Map<dynamic, dynamic> currentData = {};
  Map<dynamic, dynamic> forecastData = {};

  String currentDate = '';

  List hourlyWeatherForecast = [];

  List dailyWeatherForecast = [];

  String currentWeatherStatus = '';

  GetDataFromApi({super.key});
  // String searchApi ='http://api.weatherapi.com/v1/forecast.json?key=' + myAPI + '&q=';

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<Map<dynamic, dynamic>> fetchWeatherData(String keyWord) async {
    final String searchedKeyWord = keyWord == "" ? "london" : keyWord;

    String searchApi =
        'http://api.weatherapi.com/v1/forecast.json?key=$myAPI&q=$searchedKeyWord&days=3&aqi=yes&alerts=no';

    try {
      final uri = Uri.parse(searchApi);

      print("Search is ${searchedKeyWord}");

      print(searchApi);
      final response = await http.get(uri);
      responseStatusCode = response.statusCode;
      print("response is ${responseStatusCode}");

      if (response.statusCode == 200) {
        weatherData =
            await Map<String, dynamic>.from(json.decode(response.body));

        locationData = weatherData["location"];
        currentData = weatherData["current"];
        forecastData = weatherData["forecast"];
      }
    } catch (e) {
      debugPrint(e.toString());
      print("nok********");
    }
    return weatherData;
  }

  Map getLocationData() {
    return locationData;
  }

  Map getCurrentData() {
    return currentData;
  }

  Map getWeatherData() {
    return weatherData;
  }
}
