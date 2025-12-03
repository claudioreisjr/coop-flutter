import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../services/clima_service.dart';

class ClimaPage extends StatefulWidget {
  const ClimaPage({super.key});

  @override
  State<ClimaPage> createState() => _ClimaPageState();
}

class _ClimaPageState extends State<ClimaPage> {
  final ClimaService service = ClimaService();
  Map<String, dynamic>? dados;
  bool carregando = true;
  String cidade = "Localizando...";

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    // ▼ PERMISSÃO DE LOCALIZAÇÃO
    Position pos = await Geolocator.getCurrentPosition();

    // ▼ CLIMA
    final clima = await service.buscarClima(pos.latitude, pos.longitude);

    // ▼ GEOCODIFICAÇÃO (pega a cidade)
    final cidadeNome = await obterCidade(pos.latitude, pos.longitude);

    setState(() {
      dados = clima;
      cidade = cidadeNome;
      carregando = false;
    });
  }

  // Pega nome da cidade automaticamente
  Future<String> obterCidade(double lat, double lon) async {
    final url =
        "https://geocode.maps.co/reverse?lat=$lat&lon=$lon";
    final r = await http.get(Uri.parse(url));

    if (r.statusCode != 200) return "Sua Cidade";

    final json = jsonDecode(r.body);

    return json["address"]?["city"] ??
           json["address"]?["town"] ??
           json["address"]?["village"] ??
           "Sua Cidade";
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    List<dynamic> dias = dados!["daily"]["time"];
    List<dynamic> temps = dados!["daily"]["temperature_2m_max"];


    return Scaffold(
      appBar: AppBar(
        title: const Text("Clima"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              cidade,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            const Text(
              "Previsão Próximos 7 dias",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 6,
                  minY: temps.reduce((a, b) => a < b ? a : b) - 2,
                  maxY: temps.reduce((a, b) => a > b ? a : b) + 2,
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int i = value.toInt();
                          if (i >= dias.length) return Container();
                          String dia = dias[i].substring(8, 10);
                          return Text(dia);
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      isCurved: true,
                      dotData: const FlDotData(show: true),
                      spots: [
                        for (int i = 0; i < temps.length; i++)
                          FlSpot(i.toDouble(), temps[i].toDouble()),
                      ],
                      barWidth: 3,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
