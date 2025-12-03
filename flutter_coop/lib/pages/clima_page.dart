import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/clima_service.dart';

class ClimaPage extends StatefulWidget {
  const ClimaPage({super.key});

  @override
  State<ClimaPage> createState() => _ClimaPageState();
}

class _ClimaPageState extends State<ClimaPage> {
  final ClimaService _service = ClimaService();
  
  bool _carregando = true;
  String? _erro;
  
  // Dados do clima
  double? _tempAtual;
  int? _codigoClima;
  double? _umidade;
  double? _vento;
  List<double> _tempsMax = [];
  List<double> _tempsMin = [];
  List<String> _dias = [];
  
  // Localização
  String _localizacao = "";

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      // 1. Pega localização
      final pos = await _service.obterLocalizacao();
      
      // 2. Busca clima
      final clima = await _service.buscarClima(pos.latitude, pos.longitude);
      
      // 3. Extrai dados
      final current = clima['current'];
      final daily = clima['daily'];
      
      setState(() {
        // Dados atuais
        _tempAtual = current['temperature_2m']?.toDouble();
        _codigoClima = current['weather_code'];
        _umidade = current['relative_humidity_2m']?.toDouble();
        _vento = current['wind_speed_10m']?.toDouble();
        
        // Previsão 7 dias
        _tempsMax = List<double>.from(
          daily['temperature_2m_max'].map((t) => t.toDouble())
        );
        _tempsMin = List<double>.from(
          daily['temperature_2m_min'].map((t) => t.toDouble())
        );
        _dias = List<String>.from(daily['time']);
        
        // Localização (apenas lat/lon)
        _localizacao = "${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)}";
        
        _carregando = false;
      });
      
    } catch (e) {
      setState(() {
        _erro = e.toString().replaceAll('Exception: ', '');
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Clima"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarDados,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_carregando) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_erro != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 20),
              Text(
                _erro!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _carregarDados,
                child: const Text("Tentar novamente"),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildClimaAtual(),
          const SizedBox(height: 30),
          _buildGrafico(),
        ],
      ),
    );
  }

  Widget _buildClimaAtual() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              _service.obterEmojiClima(_codigoClima ?? 0),
              style: const TextStyle(fontSize: 80),
            ),
            const SizedBox(height: 10),
            Text(
              "${_tempAtual?.toStringAsFixed(1) ?? '--'}°C",
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _service.obterDescricaoClima(_codigoClima ?? 0),
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoCard("💧", "${_umidade?.toStringAsFixed(0) ?? '--'}%", "Umidade"),
                _buildInfoCard("💨", "${_vento?.toStringAsFixed(1) ?? '--'} km/h", "Vento"),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              _localizacao,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String emoji, String valor, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 30)),
        const SizedBox(height: 5),
        Text(
          valor,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildGrafico() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Próximos 7 dias",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 250,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: 6,
              minY: _tempsMin.reduce((a, b) => a < b ? a : b) - 2,
              maxY: _tempsMax.reduce((a, b) => a > b ? a : b) + 2,
              gridData: const FlGridData(show: true),
              titlesData: FlTitlesData(
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      int i = value.toInt();
                      if (i >= _dias.length) return const SizedBox();
                      
                      // Pega apenas dia (ex: 05/12 -> 05)
                      String dia = _dias[i].substring(8, 10);
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(dia, style: const TextStyle(fontSize: 12)),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        "${value.toInt()}°",
                        style: const TextStyle(fontSize: 12),
                      );
                    },
                  ),
                ),
              ),
              lineBarsData: [
                // Linha de temperatura máxima
                LineChartBarData(
                  isCurved: true,
                  color: Colors.red,
                  barWidth: 3,
                  dotData: const FlDotData(show: true),
                  spots: [
                    for (int i = 0; i < _tempsMax.length; i++)
                      FlSpot(i.toDouble(), _tempsMax[i]),
                  ],
                ),
                // Linha de temperatura mínima
                LineChartBarData(
                  isCurved: true,
                  color: Colors.blue,
                  barWidth: 3,
                  dotData: const FlDotData(show: true),
                  spots: [
                    for (int i = 0; i < _tempsMin.length; i++)
                      FlSpot(i.toDouble(), _tempsMin[i]),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegenda(Colors.red, "Máxima"),
            const SizedBox(width: 20),
            _buildLegenda(Colors.blue, "Mínima"),
          ],
        ),
      ],
    );
  }

  Widget _buildLegenda(Color cor, String label) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 3,
          color: cor,
        ),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}