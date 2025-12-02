class Commodity {
  final String symbol;
  final String ticker;
  final String name;
  final double last;
  final String group;
  final String unit;

  Commodity({
    required this.symbol,
    required this.ticker,
    required this.name,
    required this.last,
    required this.group,
    required this.unit,
  });

  factory Commodity.fromJson(Map<String, dynamic> json) {
    return Commodity(
      symbol: json['Symbol'],
      ticker: json['Ticker'],
      name: json['Name'],
      last: (json['Last'] as num).toDouble(),
      group: json['Group'],
      unit: json['unit'],
    );
  }
}
