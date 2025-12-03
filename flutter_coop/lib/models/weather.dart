class CurrentWeather {
  final String time;
  final double temperature;
  final double windSpeed;

  CurrentWeather({
    required this.time,
    required this.temperature,
    required this.windSpeed,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      time: json["time"],
      temperature: json["temperature_2m"].toDouble(),
      windSpeed: json["wind_speed_10m"].toDouble(),
    );
  }
}

class HourlyWeather {
  final List<String> times;
  final List<double> temperatures;
  final List<int> humidity;
  final List<double> windSpeeds;

  HourlyWeather({
    required this.times,
    required this.temperatures,
    required this.humidity,
    required this.windSpeeds,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    return HourlyWeather(
      times: List<String>.from(json["time"]),
      temperatures: List<double>.from(json["temperature_2m"].map((v) => v.toDouble())),
      humidity: List<int>.from(json["relative_humidity_2m"]),
      windSpeeds: List<double>.from(json["wind_speed_10m"].map((v) => v.toDouble())),
    );
  }
}

class WeatherData {
  final CurrentWeather current;
  final HourlyWeather hourly;

  WeatherData({required this.current, required this.hourly});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      current: CurrentWeather.fromJson(json["current"]),
      hourly: HourlyWeather.fromJson(json["hourly"]),
    );
  }
}
