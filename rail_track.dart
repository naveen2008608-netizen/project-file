import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MaterialApp(
    home: TrackDefectScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class TrackDefectScreen extends StatefulWidget {
  const TrackDefectScreen({super.key});

  @override
  State<TrackDefectScreen> createState() => _TrackDefectScreenState();
}

class _TrackDefectScreenState extends State<TrackDefectScreen> {
  // Region Selection
  String selectedRegion = 'Southern Region';
  final List<String> regions = [
    'Southern Region',
    'Northern Region',
    'Eastern Region',
    'Western Region'
  ];

  // Track Parameters
  int trackAgeYears = 14;
  double repairCostLakhs = 18.5;
  int internalFlawCount = 7; // Triggers warning if > 3
  bool isDangerLevel = true; // Danger level switch based on ultrasonic severity

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: const Text(
          'Track Defect Monitor',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRegionSelector(),
            const SizedBox(height: 16),
            if (internalFlawCount > 3) _buildWarningBanner(),
            const SizedBox(height: 16),
            _buildUltrasonicGraphCard(),
            const SizedBox(height: 16),
            _buildMetricsBar(),
            const SizedBox(height: 16),
            _buildProfileAndReportBars(),
          ],
        ),
      ),
    );
  }

  // Region Selector Dropdown
  Widget _buildRegionSelector() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Select Region:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            DropdownButton<String>(
              value: selectedRegion,
              underline: const SizedBox(),
              items: regions.map((String region) {
                return DropdownMenuItem<String>(
                  value: region,
                  child: Text(region),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedRegion = newValue;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Warning Banner for Internal Flaws
  Widget _buildWarningBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        border: Border.all(color: Colors.amber.shade800),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.amber.shade900, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FLAW WARNING DETECTED',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade900,
                  ),
                ),
                Text(
                  '$internalFlawCount internal flaws found in $selectedRegion. Immediate ultrasonic scan re-check advised.',
                  style: TextStyle(fontSize: 12, color: Colors.amber.shade900),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Ultrasonic Track Monitor Line Chart
  Widget _buildUltrasonicGraphCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ultrasonic Track Monitor',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: const Text('Live Signal (dB)'),
                  backgroundColor: Colors.blue.shade50,
                  labelStyle: const TextStyle(fontSize: 10, color: Colors.blue),
                )
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true, drawVerticalLine: false),
                  titlesData: const FlTitlesData(
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 1.2),
                        FlSpot(2, 1.5),
                        FlSpot(4, 1.1),
                        FlSpot(6, 4.8), // Defect spike
                        FlSpot(8, 2.0),
                        FlSpot(10, 5.5), // High severity flaw spike
                      ],
                      isCurved: true,
                      color: Colors.redAccent,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.redAccent.withOpacity(0.15),
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

  // Metrics: Track Age & Maintenance Cost
  Widget _buildMetricsBar() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricTile(
            title: 'Track Age',
            value: '$trackAgeYears Years',
            icon: Icons.history,
            color: Colors.indigo,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricTile(
            title: 'Repair Cost',
            value: '₹$repairCostLakhs L',
            icon: Icons.payments_outlined,
            color: Colors.teal,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricTile({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }

  // Profile Bar & Report Status Bar
  Widget _buildProfileAndReportBars() {
    return Column(
      children: [
        // Track Profile Health Bar
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Track Structural Profile Bar',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('68% Integrity', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: const LinearProgressIndicator(
                    value: 0.68,
                    minHeight: 12,
                    backgroundColor: Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Report Level Status Bar (Danger Indicator)
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Report Severity Level',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDangerLevel ? Colors.red : Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isDangerLevel ? 'DANGER LEVEL' : 'SAFE LEVEL',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  isDangerLevel
                      ? 'Critical internal cracks detected via Ultrasonic sensor. Immediate speed restriction required.'
                      : 'Track condition within acceptable risk tolerance.',
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
