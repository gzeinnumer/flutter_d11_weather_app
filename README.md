# flutter_d11_weather_app

- models.dart
```dart
/*
{
  "weather": [
    {
      "description": "clear sky",
      "icon": "01d"
    }
  ],
  "main": {
    "temp": 298.63
  },
  "name": "Yucaipa"
}
 */

class WeatherResponse{
  final String? cityName;
  final TemperatureInfo? tempInfo;
  final WeatherInfo? weatherInfo;

  String get iconUrl{
    return "https://openweathermap.org/img/wn/${weatherInfo!.icon}@2x.png";
  }

  WeatherResponse({this.cityName, this.tempInfo, this.weatherInfo});

  factory WeatherResponse.fromJson(Map<String, dynamic> json){
    final cityName = json['name'];

    final tempInfoJson = json['main'];
    final tempInfo = TemperatureInfo.fromJson(tempInfoJson);

    final weatherInfoJson = json['weather'][0];
    final weatherInfo = WeatherInfo.fromJson(weatherInfoJson);
    return WeatherResponse(cityName: cityName, tempInfo: tempInfo, weatherInfo: weatherInfo);
  }
}

//"main" : {}
class TemperatureInfo{
  final double? temperature;

  TemperatureInfo({this.temperature});

  factory TemperatureInfo.fromJson(Map<String, dynamic> json){
    final temperature = json['temp'];
    return TemperatureInfo(temperature: temperature);
  }
}

//"weather": []
class WeatherInfo{
  final String? description;
  final String? icon;

  WeatherInfo({this.description, this.icon});

  factory WeatherInfo.fromJson(Map<String, dynamic> json){
      final description = json['description'];
      final icon = json['icon'];
      return WeatherInfo(description: description, icon: icon);
  }
}
```

- data_service.dart
```dart
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
```

- main.dart
```dart
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_d11_weather_app/data_service.dart';
import 'package:flutter_d11_weather_app/models.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _cityTextController = TextEditingController();
  final _dataService = DataService();
  WeatherResponse? _response;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_response != null)
                Column(
                  children: [
                    Image.network(_response!.iconUrl),
                    Text(
                      '${_response!.tempInfo!.temperature}',
                      style: const TextStyle(fontSize: 40),
                    ),
                    Text('${_response!.weatherInfo!.description}'),
                  ],
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: SizedBox(
                  width: 150,
                  child: TextField(
                    controller: _cityTextController,
                    decoration: const InputDecoration(labelText: "City"),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _search,
                child: Text('Search'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _search() async {
    WeatherResponse response =
        await _dataService.getWeather(_cityTextController.text);
    // print(response.cityName);
    // print(response.tempInfo!.temperature);
    // print(response.weatherInfo!.description);
    setState(() {
      _response = response;
    });
  }
}
```

---

```
Copyright 2022 M. Fadli Zein
```