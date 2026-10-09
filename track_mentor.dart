import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'api.dart';

class TrackMentorScreen extends StatefulWidget {
  const TrackMentorScreen({super.key});

  @override
  State<TrackMentorScreen> createState() => _TrackMentorScreenState();
}

class _TrackMentorScreenState extends State<TrackMentorScreen> {
  List<RailwayDivision> divisions = [];

  RailwayDivision? selectedDivision;

  TrackSection? selectedSection;

  bool isLoading = true;

  String? errorMessage;

  double viewAngle = 0;

  double inspectedKm = 42.4;

  @override
  void initState() {
    super.initState();

    loadTrackSections();
  }

  // =========================================================
  // LOAD API
  // =========================================================

  Future<void> loadTrackSections() async {
    setState(() {
      isLoading = true;

      errorMessage = null;
    });

    try {
      final response = await ApiService.getTrackSections();

      final List<dynamic> jsonDivisions = response['divisions'] ?? [];

      final loadedDivisions = jsonDivisions
          .map((item) {
            return RailwayDivision.fromJson(item as Map<String, dynamic>);
          })
          .where((division) => division.sections.isNotEmpty)
          .toList();

      if (loadedDivisions.isEmpty) {
        throw Exception('No railway sections found.');
      }

      setState(() {
        divisions = loadedDivisions;

        selectedDivision = divisions.first;

        selectedSection = divisions.first.sections.first;

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
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),

        foregroundColor: Colors.white,

        title: const Text(
          'Track Mentor',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        actions: [
          IconButton(
            onPressed: loadTrackSections,

            icon: const Icon(Icons.refresh),
          ),
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
                  _buildSelection(),

                  const SizedBox(height: 16),

                  if (selectedSection != null) _buildTrackInformation(),

                  const SizedBox(height: 16),

                  if (selectedSection != null) _buildCostHistory(),

                  const SizedBox(height: 16),

                  _build3DTrack(),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          const Icon(Icons.cloud_off, size: 60, color: Colors.red),

          const SizedBox(height: 15),

          const Text(
            'Unable to load Track Mentor data',

            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.all(20),

            child: Text(errorMessage ?? '', textAlign: TextAlign.center),
          ),

          ElevatedButton.icon(
            onPressed: loadTrackSections,

            icon: const Icon(Icons.refresh),

            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // DIVISION / SECTION SELECTION
  // =========================================================

  Widget _buildSelection() {
    if (selectedDivision == null || selectedSection == null) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Railway Division',

              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<RailwayDivision>(
              initialValue: selectedDivision,

              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_on),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              items: divisions.map((division) {
                return DropdownMenuItem(
                  value: division,

                  child: Text('${division.name} (${division.code})'),
                );
              }).toList(),

              onChanged: (division) {
                if (division != null) {
                  setState(() {
                    selectedDivision = division;

                    selectedSection = division.sections.first;
                  });
                }
              },
            ),

            const SizedBox(height: 15),

            const Text(
              'Track Section',

              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<TrackSection>(
              initialValue: selectedSection,

              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.train),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              items: selectedDivision!.sections.map((section) {
                return DropdownMenuItem(
                  value: section,

                  child: Text(section.name),
                );
              }).toList(),

              onChanged: (section) {
                setState(() {
                  selectedSection = section;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // TRACK INFORMATION
  // =========================================================

  Widget _buildTrackInformation() {
    final track = selectedSection!;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _infoCard(
                'Track Age',

                '${track.ageYears} Years',

                'Laid ${track.laidYear}',

                Icons.history,

                Colors.blue,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _infoCard(
                'Health',

                '${track.healthScore}%',

                'Track condition',

                Icons.health_and_safety,

                Colors.green,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _infoCard(
                'Daily Traffic',

                '${track.dailyTrainCount}',

                '${track.passengerTrains} passenger / '
                    '${track.freightTrains} freight',

                Icons.train,

                Colors.orange,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _infoCard(
                'Usage',

                '${track.annualUsageGmt} GMT',

                'Annual usage',

                Icons.speed,

                Colors.purple,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Text(
                  'Rail Infrastructure',

                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                _detailRow('Rail Type', track.railType),

                _detailRow('Sleeper Type', track.sleeperType),

                _detailRow('Sub Section', track.subSection),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _infoCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Icon(icon, color: color),

            const SizedBox(height: 8),

            Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),

            const SizedBox(height: 3),

            Text(
              value,

              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),

            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,

              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          SizedBox(
            width: 110,

            child: Text(title, style: const TextStyle(color: Colors.grey)),
          ),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // COST HISTORY
  // =========================================================

  Widget _buildCostHistory() {
    final history = selectedSection!.maintenanceCostHistory;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Maintenance Cost History',

              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 180,

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,

                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: history.map((item) {
                  double capex = (item.buildingCapexCr / 10) * 120;

                  double repair = (item.repairCostCr / 10) * 120;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,

                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,

                        children: [
                          Container(
                            width: 12,

                            height: capex.clamp(5, 120),

                            color: Colors.blue,
                          ),

                          const SizedBox(width: 3),

                          Container(
                            width: 12,

                            height: repair.clamp(5, 120),

                            color: Colors.orange,
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      Text(item.year, style: const TextStyle(fontSize: 9)),
                    ],
                  );
                }).toList(),
              ),
            ),

            const Divider(),

            const Text(
              'Maintenance Logs',

              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            ...selectedSection!.maintenanceLogs.map((log) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),

                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.green,
                    ),

                    const SizedBox(width: 8),

                    Expanded(child: Text(log)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // 3D TRACK
  // =========================================================

  Widget _build3DTrack() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              '3D Track Perspective',

              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Container(
              height: 240,

              width: double.infinity,

              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),

                borderRadius: BorderRadius.circular(12),
              ),

              child: CustomPaint(
                painter: TrackPainter(angle: viewAngle, km: inspectedKm),
              ),
            ),

            Slider(
              value: viewAngle,

              min: -0.5,

              max: 0.5,

              onChanged: (value) {
                setState(() {
                  viewAngle = value;
                });
              },
            ),

            Row(
              children: [
                const Text('Inspection KM'),

                Expanded(
                  child: Slider(
                    value: inspectedKm,

                    min: 0,

                    max: 100,

                    onChanged: (value) {
                      setState(() {
                        inspectedKm = value;
                      });
                    },
                  ),
                ),

                Text(inspectedKm.toStringAsFixed(1)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================
// DATA MODELS
// =========================================================

class RailwayDivision {
  final String name;

  final String code;

  final List<TrackSection> sections;

  RailwayDivision({
    required this.name,

    required this.code,

    required this.sections,
  });

  factory RailwayDivision.fromJson(Map<String, dynamic> json) {
    final List<dynamic> sectionData = json['sections'] ?? [];

    return RailwayDivision(
      name: json['name'] ?? 'Unknown',

      code: json['code'] ?? '',

      sections: sectionData.map((item) {
        return TrackSection.fromJson(item as Map<String, dynamic>);
      }).toList(),
    );
  }
}

class TrackSection {
  final String id;

  final String name;

  final String subSection;

  final int laidYear;

  final int ageYears;

  final String railType;

  final String sleeperType;

  final double annualUsageGmt;

  final int dailyTrainCount;

  final int passengerTrains;

  final int freightTrains;

  final int healthScore;

  final List<YearCost> maintenanceCostHistory;

  final List<String> maintenanceLogs;

  TrackSection({
    required this.id,

    required this.name,

    required this.subSection,

    required this.laidYear,

    required this.ageYears,

    required this.railType,

    required this.sleeperType,

    required this.annualUsageGmt,

    required this.dailyTrainCount,

    required this.passengerTrains,

    required this.freightTrains,

    required this.healthScore,

    required this.maintenanceCostHistory,

    required this.maintenanceLogs,
  });

  factory TrackSection.fromJson(Map<String, dynamic> json) {
    final history = json['maintenance_cost_history'] as List? ?? [];

    final logs = json['maintenance_logs'] as List? ?? [];

    return TrackSection(
      id: json['id'] ?? '',

      name: json['name'] ?? '',

      subSection: json['sub_section'] ?? '',

      laidYear: json['laid_year'] ?? 0,

      ageYears: json['age_years'] ?? 0,

      railType: json['rail_type'] ?? '',

      sleeperType: json['sleeper_type'] ?? '',

      annualUsageGmt: (json['annual_usage_gmt'] ?? 0).toDouble(),

      dailyTrainCount: json['daily_train_count'] ?? 0,

      passengerTrains: json['passenger_trains'] ?? 0,

      freightTrains: json['freight_trains'] ?? 0,

      healthScore: json['health_score'] ?? 0,

      maintenanceCostHistory: history.map((item) {
        return YearCost.fromJson(item as Map<String, dynamic>);
      }).toList(),

      maintenanceLogs: logs.map((item) => item.toString()).toList(),
    );
  }
}

class YearCost {
  final String year;

  final double buildingCapexCr;

  final double repairCostCr;

  YearCost({
    required this.year,

    required this.buildingCapexCr,

    required this.repairCostCr,
  });

  factory YearCost.fromJson(Map<String, dynamic> json) {
    return YearCost(
      year: json['year'].toString(),

      buildingCapexCr: (json['building_capex_cr'] ?? 0).toDouble(),

      repairCostCr: (json['repair_cost_cr'] ?? 0).toDouble(),
    );
  }
}

// =========================================================
// 3D PAINTER
// =========================================================

class TrackPainter extends CustomPainter {
  final double angle;

  final double km;

  TrackPainter({required this.angle, required this.km});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2 + angle * 80;

    final horizon = size.height * 0.25;

    final ballast = Path();

    ballast.moveTo(centerX - 30, horizon);

    ballast.lineTo(centerX + 30, horizon);

    ballast.lineTo(size.width + 50, size.height);

    ballast.lineTo(-50, size.height);

    ballast.close();

    final ballastPaint = Paint()..color = const Color(0xFF334155);

    canvas.drawPath(ballast, ballastPaint);

    final sleeperPaint = Paint()..color = const Color(0xFFCBD5E1);

    for (int i = 1; i <= 18; i++) {
      final t = math.pow(i / 18, 2).toDouble();

      final y = horizon + (size.height - horizon) * t;

      final width = 30 + size.width * 0.75 * t;

      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(centerX, y),

          width: width,

          height: 3 + 8 * t,
        ),

        sleeperPaint,
      );
    }

    final railPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6;

    canvas.drawLine(
      Offset(centerX - 15, horizon),

      Offset(size.width * 0.15 + angle * 40, size.height),

      railPaint,
    );

    canvas.drawLine(
      Offset(centerX + 15, horizon),

      Offset(size.width * 0.85 + angle * 40, size.height),

      railPaint,
    );

    final text = TextPainter(
      text: TextSpan(
        text: '3D SCAN  |  KM ${km.toStringAsFixed(1)}',

        style: const TextStyle(
          color: Colors.cyanAccent,

          fontWeight: FontWeight.bold,

          fontSize: 12,
        ),
      ),

      textDirection: TextDirection.ltr,
    );

    text.layout();

    text.paint(
      canvas,

      Offset(size.width / 2 - text.width / 2, size.height * 0.75),
    );
  }

  @override
  bool shouldRepaint(covariant TrackPainter oldDelegate) {
    return oldDelegate.angle != angle || oldDelegate.km != km;
  }
}
