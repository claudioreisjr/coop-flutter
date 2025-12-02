import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/commodity.dart';

class CommodityService {
  final String url =
      "https://api.tradingeconomics.com/markets/commodities?c=guest:guest";

  Future<List<Commodity>> fetchCommodities() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((item) => Commodity.fromJson(item)).toList();
    } else {
      throw Exception("Erro ao buscar dados da API");
    }
  }

  Future<List<Commodity>> fetchSelected() async {
  List<Commodity> all = await fetchCommodities();

  List<String> desejados = ["Corn", "Coffee", "Rice", "Milk", "Soybean"];

  return all.where((item) => desejados.contains(item.name)).toList();
  }

}
