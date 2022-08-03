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
