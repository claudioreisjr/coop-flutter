import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

class ClimaPage extends StatefulWidget {
  const ClimaPage({super.key});

  @override
  State<ClimaPage> createState() => _ClimaPageState();
}

class _ClimaPageState extends State<ClimaPage> {
  String cidade = "";
  double temperatura = 0;
  double vento = 0;
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    buscarClima();
  }

  Future<void> buscarClima() async {
    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> place = await placemarkFromCoordinates(pos.latitude, pos.longitude);
    cidade = place.first.subAdministrativeArea ?? "Sua Cidade";

    final url =
        "https://api.open-meteo.com/v1/forecast?latitude=${pos.latitude}&longitude=${pos.longitude}&current=temperature_2m,wind_speed_10m";

    final response = await http.get(Uri.parse(url));
    final dados = jsonDecode(response.body);

    setState(() {
      temperatura = dados["current"]["temperature_2m"];
      vento = dados["current"]["wind_speed_10m"];
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Clima"),
        backgroundColor: Colors.green,
      ),

      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    cidade,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text("🌡️ Temperatura: $temperatura°C", style: const TextStyle(fontSize: 20)),
                  Text("💨 Vento: $vento km/h", style: const TextStyle(fontSize: 20)),
                ],
              ),
            ),
    );
  }
}
