import 'dart:convert';

import 'package:flutter_d11_weather_app/models.dart';
import 'package:http/http.dart' as http;

class DataService {
  Future<WeatherResponse> getWeather(String city) async {
    //https://api.openweathermap.org/data/2.5/weather?q=Yucaipa&appid=0b4be60a8797e131f49efc402fbbc0ed

    // final queryParameters = {"lat": "35", "lon":"139", "appid": "0b4be60a8797e131f49efc402fbbc0ed"};
    final queryParameters = {
      "q": city,
      "appid": "0b4be60a8797e131f49efc402fbbc0ed",
      "units": "imperial"
    };

    final uri = Uri.https(
        "api.openweathermap.org", "/data/2.5/weather", queryParameters);

    final response = await http.get(uri);

    print(response.body);

    final json = jsonDecode(response.body);
    return WeatherResponse.fromJson(json);
  }
}
