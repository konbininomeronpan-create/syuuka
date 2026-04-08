import 'package:flutter/material.dart';

void main() {
  runApp(const ShippingApp());
}

class Region {
  int id;
  String name;
  String detail;
  double fee80;
  double fee100;
  double fee120;

  int qty80;
  int qty100;
  int qty120;

  Region({
    required this.id,
    required this.name,
    required this.detail,
    required this.fee80,
    required this.fee100,
    required this.fee120,
    this.qty80 = 0,
    this.qty100 = 0,
    this.qty120 = 0,
  });

  double get totalFee => qty80 * fee80 + qty100 * fee100 + qty120 * fee120;
  int get totalQty => qty80 + qty100 + qty120;
}

class ShippingApp extends StatelessWidget {
  const ShippingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '送料計算アプリ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 20),
        ),
      ),
      home: SummaryPage(),
    );
  }
}

class SummaryPage extends StatefulWidget {
  SummaryPage({super.key});

  final List<Region> regions = [
    Region(id: 1, name: '愛媛', detail: '愛媛県', fee80: 850, fee100: 900, fee120: 1150),
    Region(
      id: 2,
      name: '四国関西中国',
      detail:
          '徳島・香川・高知・大阪・兵庫・京都・奈良・和歌山・岡山・広島・鳥取・島根',
      fee80: 850,
      fee100: 900,
      fee120: 1200,
    ),
    Region(
      id: 3,
      name: '九州中部北陸',
      detail:
          '福岡・佐賀・長崎・熊本・大分・宮崎・鹿児島・愛知・岐阜・三重・石川・富山・福井',
      fee80: 900,
      fee100: 950,
      fee120: 1250,
    ),
    Region(
      id: 4,
      name: '関東信越',
      detail: '東京・神奈川・千葉・埼玉・茨城・栃木・群馬・新潟・長野',
      fee80: 950,
      fee100: 1000,
      fee120: 1350,
    ),
    Region(
      id: 5,
      name: '東北',
      detail: '青森・岩手・宮城・秋田・山形・福島',
      fee80: 1150,
      fee100: 1250,
      fee120: 1600,
    ),
    Region(id: 6, name: '沖縄', detail: '沖縄県全域', fee80: 1600, fee100: 1900, fee120: 2150),
    Region(id: 7, name: '北海道', detail: '北海道全域', fee80: 1750, fee100: 2050, fee120: 2200),
  ];

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  void _editQty(Region region) async {
    final qty80 = TextEditingController(text: region.qty80.toString());
    final qty100 = TextEditingController(text: region.qty100.toString());
    final qty120 = TextEditingController(text: region.qty120.toString());

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("${region.name} の数量入力", style: const TextStyle(fontSize: 24)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(region.detail, style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 16),
              TextField(
                controller: qty80,
                decoration: const InputDecoration(labelText: "80サイズ"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: qty100,
                decoration: const InputDecoration(labelText: "100サイズ"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: qty120,
                decoration: const InputDecoration(labelText: "120サイズ"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text("キャンセル", style: TextStyle(fontSize: 18)),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("保存", style: TextStyle(fontSize: 18)),
            onPressed: () {
              setState(() {
                region.qty80 = int.tryParse(qty80.text) ?? 0;
                region.qty100 = int.tryParse(qty100.text) ?? 0;
                region.qty120 = int.tryParse(qty120.text) ?? 0;
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _clearAll() {
    setState(() {
      for (var r in widget.regions) {
        r.qty80 = 0;
        r.qty100 = 0;
        r.qty120 = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalFee = widget.regions.fold(0, (sum, r) => sum + r.totalFee);
    int totalQty = widget.regions.fold(0, (sum, r) => sum + r.totalQty);

    return Scaffold(
      appBar: AppBar(
        title: const Text("送料集計", style: TextStyle(fontSize: 26)),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _clearAll,
        backgroundColor: Colors.grey.shade300,
        mini: true,
        child: const Icon(Icons.delete, color: Colors.black87),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ...widget.regions.map((r) {
            return GestureDetector(
              onTap: () => _editQty(r),
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1行目：地域名 + 金額
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            r.name,
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              "¥${r.totalFee.toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // 2行目：合計個数
                      Text(
                        "合計 ${r.totalQty} 個",
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 14),

                      // 3行目：サイズ別個数
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("80: ${r.qty80}個", style: const TextStyle(fontSize: 20)),
                          Text("100: ${r.qty100}個", style: const TextStyle(fontSize: 20)),
                          Text("120: ${r.qty120}個", style: const TextStyle(fontSize: 20)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),

          const Divider(height: 40),

          Text(
            "全地域の総合計個数: $totalQty 個",
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            "総合計送料: ¥${totalFee.toStringAsFixed(0)}",
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
