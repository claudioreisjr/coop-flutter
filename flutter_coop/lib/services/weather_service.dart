import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  final String baseUrl = "https://api.open-meteo.com/v1/forecast";

  Future<WeatherData> fetchWeather({
    required double latitude,
    required double longitude,
  }) async {
    final url = Uri.parse(
      "$baseUrl?latitude=$latitude&longitude=$longitude"
      "&current=temperature_2m,wind_speed_10m"
      "&hourly=temperature_2m,relative_humidity_2m,wind_speed_10m",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonBody = jsonDecode(response.body);
      return WeatherData.fromJson(jsonBody);
    } else {
      throw Exception("Erro ao buscar clima: ${response.statusCode}");
    }
  }
}
