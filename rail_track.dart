import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'api.dart';

class TrackDefectScreen extends StatefulWidget {
  const TrackDefectScreen({super.key});

  @override
  State<TrackDefectScreen> createState() => _TrackDefectScreenState();
}

class _TrackDefectScreenState extends State<TrackDefectScreen> {
  String selectedRegion = 'Southern Railway';

  int trackAgeYears = 0;

  double repairCostLakhs = 0;

  int internalFlawCount = 0;

  bool dangerLevel = false;

  bool isLoading = true;

  String? errorMessage;

  final List<FlSpot> ultrasonicData = [
    const FlSpot(0, 1.2),

    const FlSpot(2, 1.5),

    const FlSpot(4, 1.1),

    const FlSpot(6, 4.8),

    const FlSpot(8, 2.0),

    const FlSpot(10, 5.5),
  ];

  @override
  void initState() {
    super.initState();

    loadTrackData();
  }

  // =========================================================
  // GET TRACK DATA
  // =========================================================

  Future<void> loadTrackData() async {
    setState(() {
      isLoading = true;

      errorMessage = null;
    });

    try {
      final response = await ApiService.getTrackDefects();

      final data = response['data'] as Map<String, dynamic>;

      setState(() {
        selectedRegion = data['region'] ?? 'Southern Railway';

        trackAgeYears = data['track_age_years'] ?? 0;

        repairCostLakhs = (data['repair_cost_lakhs'] ?? 0).toDouble();

        internalFlawCount = data['internal_flaw_count'] ?? 0;

        dangerLevel = data['danger_level'] == true;

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
          'Track Defect Monitor',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        actions: [
          IconButton(onPressed: loadTrackData, icon: const Icon(Icons.refresh)),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? _buildError()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),

              child: Column(
                children: [
                  _buildRegionCard(),

                  const SizedBox(height: 16),

                  _buildWarningCard(),

                  const SizedBox(height: 16),

                  _buildUltrasonicCard(),

                  const SizedBox(height: 16),

                  _buildMetrics(),

                  const SizedBox(height: 16),

                  _buildDangerCard(),
                ],
              ),
            ),
    );
  }

  // =========================================================
  // ERROR
  // =========================================================

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            const Icon(Icons.cloud_off, size: 60, color: Colors.red),

            const SizedBox(height: 16),

            const Text(
              'Unable to load track data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(errorMessage ?? '', textAlign: TextAlign.center),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: loadTrackData,

              icon: const Icon(Icons.refresh),

              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // REGION
  // =========================================================

  Widget _buildRegionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.blue),

            const SizedBox(width: 10),

            const Text(
              'Region:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                selectedRegion,

                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // WARNING
  // =========================================================

  Widget _buildWarningCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: dangerLevel ? Colors.red.shade50 : Colors.green.shade50,

        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: dangerLevel ? Colors.red : Colors.green),
      ),

      child: Row(
        children: [
          Icon(
            dangerLevel ? Icons.warning : Icons.check_circle,

            color: dangerLevel ? Colors.red : Colors.green,

            size: 30,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  dangerLevel ? 'DEFECT WARNING' : 'TRACK CONDITION NORMAL',

                  style: TextStyle(
                    fontWeight: FontWeight.bold,

                    color: dangerLevel ? Colors.red : Colors.green,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  '$internalFlawCount internal '
                  'flaws detected.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // ULTRASONIC GRAPH
  // =========================================================

  Widget _buildUltrasonicCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Ultrasonic Rail Inspection',

              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            const Text(
              'Ultrasonic signal response',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 220,

              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),

                  titlesData: const FlTitlesData(
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),

                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),

                  borderData: FlBorderData(show: true),

                  lineBarsData: [
                    LineChartBarData(
                      spots: ultrasonicData,

                      isCurved: true,

                      color: Colors.red,

                      barWidth: 3,

                      dotData: const FlDotData(show: true),

                      belowBarData: BarAreaData(
                        show: true,

                        color: Colors.red.withValues(alpha: 0.12),
                      ),
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

  // =========================================================
  // METRICS
  // =========================================================

  Widget _buildMetrics() {
    return Row(
      children: [
        Expanded(
          child: _metricCard(
            title: 'Track Age',

            value: '$trackAgeYears Years',

            icon: Icons.history,

            color: Colors.blue,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _metricCard(
            title: 'Repair Cost',

            value: '₹${repairCostLakhs.toStringAsFixed(1)} L',

            icon: Icons.currency_rupee,

            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _metricCard({
    required String title,

    required String value,

    required IconData icon,

    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Icon(icon, color: color),

            const SizedBox(height: 10),

            Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),

            const SizedBox(height: 5),

            Text(
              value,

              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // DANGER
  // =========================================================

  Widget _buildDangerCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Automated Inspection Result',

              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Icon(
                  dangerLevel ? Icons.dangerous : Icons.verified,

                  color: dangerLevel ? Colors.red : Colors.green,

                  size: 30,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    dangerLevel
                        ? 'High-risk rail condition. '
                              'Inspection required.'
                        : 'Rail condition is within '
                              'normal operating limits.',

                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
