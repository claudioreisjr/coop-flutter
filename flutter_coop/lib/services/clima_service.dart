import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class ClimaService {
  // Busca clima pela localização
  Future<Map<String, dynamic>> buscarClima(double lat, double lon) async {
    try {
      final url = "https://api.open-meteo.com/v1/forecast"
          "?latitude=$lat"
          "&longitude=$lon"
          "&current=temperature_2m,relative_humidity_2m,wind_speed_10m,weather_code"
          "&daily=temperature_2m_max,temperature_2m_min,weather_code"
          "&timezone=America%2FSao_Paulo";

      final r = await http.get(Uri.parse(url));

      if (r.statusCode != 200) {
        throw Exception("Erro na API de clima");
      }

      return jsonDecode(r.body);
    } catch (e) {
      print("Erro buscarClima: $e");
      rethrow;
    }
  }

  // Pega a localização do usuário
  Future<Position> obterLocalizacao() async {
    try {
      // Verifica se o serviço está ativo
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception("Serviço de localização desativado");
      }

      // Verifica permissão
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception("Permissão de localização negada");
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception("Permissão de localização negada permanentemente");
      }

      // Pega a posição
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print("Erro obterLocalizacao: $e");
      rethrow;
    }
  }

  // Converte código do clima em descrição
  String obterDescricaoClima(int code) {
    switch (code) {
      case 0:
        return "Céu limpo";
      case 1:
      case 2:
      case 3:
        return "Parcialmente nublado";
      case 45:
      case 48:
        return "Neblina";
      case 51:
      case 53:
      case 55:
        return "Garoa";
      case 61:
      case 63:
      case 65:
        return "Chuva";
      case 71:
      case 73:
      case 75:
        return "Neve";
      case 95:
        return "Tempestade";
      default:
        return "Não disponível";
    }
  }

  // Converte código em emoji
  String obterEmojiClima(int code) {
    if (code == 0) return "☀️";
    if (code >= 1 && code <= 3) return "⛅";
    if (code >= 45 && code <= 48) return "🌫️";
    if (code >= 51 && code <= 65) return "🌧️";
    if (code >= 71 && code <= 75) return "🌨️";
    if (code == 95) return "⛈️";
    return "🌤️";
  }
}