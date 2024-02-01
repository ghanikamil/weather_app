import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String _weather = 'Loading...';
  String _city = 'Loading...';
  String _lat = 'Loading...';
  String _long = 'Loading...';
  String _mapurl = '';
  @override
  void initState() {
    super.initState();
    _updateWeather();
  }

  Future<void> _updateWeather() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final response = await http.get(
        Uri.parse('http://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=c36d00a1ade6f97e5f7d9861c3dff92c'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      String weather = data['weather'][0]['description'];
      String city = data['name'];
      String apiGoogle = '';
      String mapUrl =
          'https://maps.googleapis.com/maps/api/staticmap?center=${position.latitude},${position.longitude}&zoom=14&size=900x900&maptype=roadmap&markers=color:red%7Clabel:A%7C${position.latitude},${position.longitude}&key=${apiGoogle}';
      setState(() {
        _weather = weather;
        _city =city;
        _lat = '${position.latitude}';
        _long = '${position.longitude}';
        _mapurl = mapUrl;
      });
    } else {
      setState(() {
        _weather = 'Failed to load weather data.';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Current Weather: $_weather'),
            Text('Current City : $_city'),
            Text('Latitude: $_lat Longitude: $_long'),
            Image.network(
              _mapurl,
              width: 400,
              height: 300,
            ),
          ],
        ),
      ),
    );
  }
}

// git init
// git add README.md
// git commit -m "first commit"
// git branch -M main
// git remote add origin https://github.com/ghanikamil/weather_app.git
// git push -u origin main