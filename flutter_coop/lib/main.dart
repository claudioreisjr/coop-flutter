import 'package:flutter/material.dart';
import 'services/commodity_service.dart';
import 'models/commodity.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CommodityPage(),
    );
  }
}

class CommodityPage extends StatelessWidget {
  final CommodityService service = CommodityService();

  CommodityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Commodities")),
      body: FutureBuilder<List<Commodity>>(
        future: service.fetchSelected(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Erro: ${snapshot.error}"));
          }

          List<Commodity> dados = snapshot.data!;

          if (dados.isEmpty) {
            return const Center(child: Text("Nenhum item encontrado"));
          }

          return ListView.builder(
            itemCount: dados.length,
            itemBuilder: (context, index) {
              final c = dados[index];
              return ListTile(
                title: Text(c.name),
                subtitle: Text("Último valor: ${c.last} ${c.unit}"),
              );
            },
          );
        },
      ),
    );
  }
}
