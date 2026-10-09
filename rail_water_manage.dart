import 'package:flutter/material.dart';
import 'api.dart';
class WaterManagementPage extends StatefulWidget {
  final bool isDarkMode;

  final VoidCallback onToggleTheme;

  const WaterManagementPage({
    super.key,

    required this.isDarkMode,

    required this.onToggleTheme,
  });

  @override
  State<WaterManagementPage> createState() => _WaterManagementPageState();
}

class _WaterManagementPageState extends State<WaterManagementPage> {
  List<BorewellData> borewells = [];

  int totalBorewells = 0;

  int normal = 0;

  int warning = 0;

  int critical = 0;

  int totalDailyUsage = 0;

  double averageWaterLevel = 0;

  bool isLoading = true;

  String? errorMessage;

  @override
  void initState() {
    super.initState();

    loadWaterData();
  }

  // =========================================================
  // LOAD WATER DATA
  // =========================================================

  Future<void> loadWaterData() async {
    setState(() {
      isLoading = true;

      errorMessage = null;
    });

    try {
      final results = await Future.wait([
        ApiService.getBorewells(),

        ApiService.getWaterSummary(),
      ]);

      final borewellResponse = results[0];

      final summaryResponse = results[1];

      final List<dynamic> list = borewellResponse['borewells'] ?? [];

      setState(() {
        borewells = list.map((item) {
          return BorewellData.fromJson(item as Map<String, dynamic>);
        }).toList();

        totalBorewells = summaryResponse['total_borewells'] ?? 0;

        normal = summaryResponse['normal'] ?? 0;

        warning = summaryResponse['warning'] ?? 0;

        critical = summaryResponse['critical'] ?? 0;

        totalDailyUsage = summaryResponse['total_daily_usage'] ?? 0;

        averageWaterLevel = (summaryResponse['average_water_level'] ?? 0)
            .toDouble();

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;

        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),

        foregroundColor: Colors.white,

        title: const Text(
          'Water Management',

          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        actions: [
          IconButton(
            onPressed: widget.onToggleTheme,

            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
          ),

          IconButton(onPressed: loadWaterData, icon: const Icon(Icons.refresh)),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? _buildError()
          : RefreshIndicator(
              onRefresh: loadWaterData,

              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),

                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    _buildSummary(),

                    const SizedBox(height: 18),

                    _buildOverview(),

                    const SizedBox(height: 20),

                    const Text(
                      'Railway Borewells',

                      style: TextStyle(
                        fontSize: 19,

                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    ...borewells.map(_buildBorewell),
                  ],
                ),
              ),
            ),
    );
  }

  // =========================================================
  // ERROR
  // =========================================================

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          const Icon(Icons.water_drop_outlined, size: 60, color: Colors.red),

          const SizedBox(height: 15),

          const Text(
            'Unable to load water data',

            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.all(20),

            child: Text(errorMessage ?? '', textAlign: TextAlign.center),
          ),

          ElevatedButton.icon(
            onPressed: loadWaterData,

            icon: const Icon(Icons.refresh),

            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // SUMMARY
  // =========================================================

  Widget _buildSummary() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _summaryCard(
                'Total',

                '$totalBorewells',

                Icons.water_drop,

                Colors.blue,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: _summaryCard(
                'Normal',

                '$normal',

                Icons.check_circle,

                Colors.green,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: _summaryCard(
                'Warning',

                '$warning',

                Icons.warning,

                Colors.orange,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: _summaryCard(
                'Critical',

                '$critical',

                Icons.error,

                Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _summaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Icon(icon, color: color, size: 28),

            const SizedBox(height: 8),

            Text(
              title,

              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),

            const SizedBox(height: 4),

            Text(
              value,

              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // OVERVIEW
  // =========================================================

  Widget _buildOverview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Groundwater Overview',

              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 18),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                const Text('Average Water Level'),

                Text(
                  '${averageWaterLevel.toStringAsFixed(2)} m',

                  style: const TextStyle(
                    fontSize: 18,

                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                const Text('Total Daily Usage'),

                Text(
                  '$totalDailyUsage L',

                  style: const TextStyle(
                    fontSize: 18,

                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // BOREWELL
  // =========================================================

  Widget _buildBorewell(BorewellData borewell) {
    final Color color = getStatusColor(borewell.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        borewell.id,

                        style: const TextStyle(
                          fontSize: 17,

                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        borewell.location,

                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,

                    vertical: 5,
                  ),

                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),

                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Text(
                    borewell.status,

                    style: TextStyle(
                      color: color,

                      fontWeight: FontWeight.bold,

                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: _smallMetric(
                    'Water Level',

                    '${borewell.waterLevel} m',

                    Icons.water_drop,
                  ),
                ),

                Expanded(
                  child: _smallMetric(
                    'Daily Usage',

                    '${borewell.dailyUsage} L',

                    Icons.water,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Icon(Icons.trending_down, color: color, size: 20),

                const SizedBox(width: 7),

                const Text(
                  'Groundwater Trend: ',

                  style: TextStyle(fontWeight: FontWeight.w600),
                ),

                Expanded(
                  child: Text(
                    borewell.groundwaterTrend,

                    style: TextStyle(color: color, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _smallMetric(String title, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue, size: 20),

        const SizedBox(width: 6),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              title,

              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),

            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  // =========================================================
  // STATUS COLOR
  // =========================================================

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'critical':
        return Colors.red;

      case 'warning':
        return Colors.orange;

      default:
        return Colors.green;
    }
  }
}

// =========================================================
// BOREWELL MODEL
// =========================================================

class BorewellData {
  final String id;

  final String location;

  final double waterLevel;

  final String status;

  final int dailyUsage;

  final String groundwaterTrend;

  BorewellData({
    required this.id,

    required this.location,

    required this.waterLevel,

    required this.status,

    required this.dailyUsage,

    required this.groundwaterTrend,
  });

  factory BorewellData.fromJson(Map<String, dynamic> json) {
    return BorewellData(
      id: json['id'] ?? '',

      location: json['location'] ?? '',

      waterLevel: (json['water_level'] ?? 0).toDouble(),

      status: json['status'] ?? 'Unknown',

      dailyUsage: json['daily_usage'] ?? 0,

      groundwaterTrend: json['groundwater_trend'] ?? 'Unknown',
    );
  }
}
