import 'dart:convert';
import 'package:http/http.dart' as http;

class ClimaService {
  Future<Map<String, dynamic>> buscarClima(double lat, double lon) async {
    final url =
        "https://api.open-meteo.com/v1/forecast"
        "?latitude=$lat"
        "&longitude=$lon"
        "&daily=temperature_2m_max"
        "&timezone=America%2FSao_Paulo";

    final r = await http.get(Uri.parse(url));

    if (r.statusCode != 200) {
      throw Exception("Erro ao buscar clima");
    }

    return jsonDecode(r.body);
  }
}
