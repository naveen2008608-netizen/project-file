import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() {
  runApp(const TrackMentorApp());
}

/// Root Application Widget
class TrackMentorApp extends StatelessWidget {
  const TrackMentorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Track Mentor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A8A), // Southern Railway Navy Blue
          primary: const Color(0xFF1E3A8A),
          secondary: const Color(0xFFD97706), // Maintenance Amber
          surface: Colors.white,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
        // FIX: Using CardThemeData instead of CardTheme
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
        ),
      ),
      home: const TrackMentorScreen(),
    );
  }
}

/// Main Screen for Track Mentor
class TrackMentorScreen extends StatefulWidget {
  const TrackMentorScreen({super.key});

  @override
  State<TrackMentorScreen> createState() => _TrackMentorScreenState();
}

class _TrackMentorScreenState extends State<TrackMentorScreen> {
  // Southern Railway Divisions Data
  final List<RailwayDivision> _divisions = [
    RailwayDivision(
      name: 'Chennai Division (MAS)',
      code: 'MAS',
      sections: [
        TrackSection(
          id: 'MAS-AJJ-01',
          name: 'Chennai Central (MAS) - Arakkonam (AJJ)',
          subSection: 'KM 24.50 to KM 68.20 (Quadruple Track)',
          laidYear: 2013,
          ageYears: 13,
          railType: '60 kg/m UIC 90 UTS',
          sleeperType: 'Prestressed Concrete (PSC-1660)',
          annualUsageGmt: 48.6,
          dailyTrainCount: 94,
          passengerTrains: 66,
          freightTrains: 28,
          healthScore: 84,
          maintenanceCostHistory: [
            YearCost(year: '2019', buildingCapexCr: 4.2, repairCostCr: 1.8),
            YearCost(year: '2020', buildingCapexCr: 1.1, repairCostCr: 2.2),
            YearCost(year: '2021', buildingCapexCr: 5.6, repairCostCr: 2.5),
            YearCost(year: '2022', buildingCapexCr: 2.8, repairCostCr: 3.1),
            YearCost(year: '2023', buildingCapexCr: 7.4, repairCostCr: 2.9),
            YearCost(year: '2024', buildingCapexCr: 3.0, repairCostCr: 3.6),
            YearCost(year: '2025', buildingCapexCr: 8.9, repairCostCr: 3.8),
            YearCost(year: '2026', buildingCapexCr: 2.2, repairCostCr: 1.4),
          ],
          maintenanceLogs: [
            'Deep Ballast Screening (BCM) - Nov 2025',
            'Ultrasonic Flaw Detection (USFD) - Jan 2026',
            'Flash Butt Welding & Rail Grinding - Feb 2026',
          ],
        ),
        TrackSection(
          id: 'MAS-GDR-02',
          name: 'Chennai Beach (MSB) - Gummidipundi (GPD)',
          subSection: 'KM 12.00 to KM 46.80',
          laidYear: 2016,
          ageYears: 10,
          railType: '60 kg/m 110 UTS Head Hardened',
          sleeperType: 'Heavy Axle PSC',
          annualUsageGmt: 38.2,
          dailyTrainCount: 78,
          passengerTrains: 52,
          freightTrains: 26,
          healthScore: 91,
          maintenanceCostHistory: [
            YearCost(year: '2021', buildingCapexCr: 3.2, repairCostCr: 1.2),
            YearCost(year: '2023', buildingCapexCr: 4.5, repairCostCr: 1.8),
            YearCost(year: '2025', buildingCapexCr: 2.1, repairCostCr: 2.4),
            YearCost(year: '2026', buildingCapexCr: 1.0, repairCostCr: 0.9),
          ],
          maintenanceLogs: [
            'Turnout Renewal with Fan-shaped Layout - Sep 2025',
            'Automated Track Tamping (CSM) - Dec 2025',
          ],
        ),
      ],
    ),
    RailwayDivision(
      name: 'Palakkad Division (PGT)',
      code: 'PGT',
      sections: [
        TrackSection(
          id: 'PGT-SRR-01',
          name: 'Palakkad Jn (PGT) - Shoranur Jn (SRR)',
          subSection: 'KM 520.00 to KM 568.50 (Double Electrified)',
          laidYear: 2010,
          ageYears: 16,
          railType: '52 kg/m 90 UTS',
          sleeperType: 'Mono-block Concrete Sleepers',
          annualUsageGmt: 32.4,
          dailyTrainCount: 62,
          passengerTrains: 44,
          freightTrains: 18,
          healthScore: 76,
          maintenanceCostHistory: [
            YearCost(year: '2020', buildingCapexCr: 3.0, repairCostCr: 2.1),
            YearCost(year: '2022', buildingCapexCr: 6.2, repairCostCr: 3.5),
            YearCost(year: '2024', buildingCapexCr: 4.8, repairCostCr: 4.2),
            YearCost(year: '2026', buildingCapexCr: 3.1, repairCostCr: 2.8),
          ],
          maintenanceLogs: [
            'Rail Stress Relieving & Destressing - Aug 2025',
            'Shoulder Ballast Cleaning - Jan 2026',
          ],
        ),
      ],
    ),
    RailwayDivision(
      name: 'Thiruvananthapuram Division (TVC)',
      code: 'TVC',
      sections: [
        TrackSection(
          id: 'TVC-ERS-01',
          name: 'Ernakulam Jn (ERS) - Kollam Jn (QLN) via ALLP',
          subSection: 'KM 60.10 to KM 142.00',
          laidYear: 2014,
          ageYears: 12,
          railType: '60 kg/m UIC',
          sleeperType: 'Prestressed Concrete Sleepers',
          annualUsageGmt: 29.5,
          dailyTrainCount: 56,
          passengerTrains: 46,
          freightTrains: 10,
          healthScore: 88,
          maintenanceCostHistory: [
            YearCost(year: '2021', buildingCapexCr: 5.1, repairCostCr: 1.6),
            YearCost(year: '2023', buildingCapexCr: 3.8, repairCostCr: 2.2),
            YearCost(year: '2025', buildingCapexCr: 6.0, repairCostCr: 2.7),
          ],
          maintenanceLogs: [
            'Corrosion Protection Spray Treatment - Oct 2025',
            'Track Geometry Car Recording Run - Jan 2026',
          ],
        ),
      ],
    ),
    RailwayDivision(
      name: 'Madurai Division (MDU)',
      code: 'MDU',
      sections: [
        TrackSection(
          id: 'MDU-DG-01',
          name: 'Madurai Jn (MDU) - Dindigul Jn (DG)',
          subSection: 'KM 430.00 to KM 492.00',
          laidYear: 2018,
          ageYears: 8,
          railType: '60 kg/m 90 UTS',
          sleeperType: 'PSC Wide Base',
          annualUsageGmt: 26.8,
          dailyTrainCount: 48,
          passengerTrains: 36,
          freightTrains: 12,
          healthScore: 94,
          maintenanceCostHistory: [
            YearCost(year: '2022', buildingCapexCr: 3.5, repairCostCr: 0.9),
            YearCost(year: '2024', buildingCapexCr: 2.2, repairCostCr: 1.4),
            YearCost(year: '2026', buildingCapexCr: 1.8, repairCostCr: 1.1),
          ],
          maintenanceLogs: [
            'Routine USFD Rail Flaw Testing - Dec 2025',
            'Point & Crossing Overhaul - Feb 2026',
          ],
        ),
      ],
    ),
    RailwayDivision(name: 'Salem Division (SA)', code: 'SA', sections: []),
    RailwayDivision(
      name: 'Tiruchirappalli Division (TPJ)',
      code: 'TPJ',
      sections: [],
    ),
  ];

  late RailwayDivision _selectedDivision;
  late TrackSection _selectedTrack;
  double _viewAngle = 0.0;
  double _inspectedKm = 42.4;

  @override
  void initState() {
    super.initState();
    _selectedDivision = _divisions[0];
    _selectedTrack = _divisions[0].sections[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                // FIX: withValues instead of withOpacity
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.alt_route_rounded,
                size: 22,
                color: Colors.amberAccent,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Track Mentor',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                    letterSpacing: -0.2,
                  ),
                ),
                Text(
                  'Southern Railway Track Health & Asset Intelligence',
                  style: TextStyle(fontSize: 11, color: Color(0xFFCBD5E1)),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRegionSelectionCard(),
            const SizedBox(height: 16),
            _buildTrackMapRouteCard(),
            const SizedBox(height: 16),
            _buildTrackMetricsRow(),
            const SizedBox(height: 16),
            _buildCostHistoryCard(),
            const SizedBox(height: 16),
            _build3DTrackViewerCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildRegionSelectionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.hub_outlined, color: Color(0xFF1E3A8A), size: 20),
                SizedBox(width: 8),
                Text(
                  'Southern Railway Region / Division',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // FIX: using initialValue instead of deprecated value
            DropdownButtonFormField<RailwayDivision>(
              key: ValueKey(_selectedDivision.code),
              initialValue: _selectedDivision,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                labelText: 'Select Southern Railway Division',
                prefixIcon: const Icon(
                  Icons.location_on_rounded,
                  color: Color(0xFF1E3A8A),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
              items: _divisions.map((division) {
                return DropdownMenuItem(
                  value: division,
                  child: Text(
                    division.name,
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
              onChanged: (RailwayDivision? division) {
                if (division != null && division.sections.isNotEmpty) {
                  setState(() {
                    _selectedDivision = division;
                    _selectedTrack = division.sections[0];
                  });
                }
              },
            ),
            if (_selectedDivision.sections.isNotEmpty) ...[
              const SizedBox(height: 12),
              // FIX: using initialValue instead of deprecated value
              DropdownButtonFormField<TrackSection>(
                key: ValueKey(_selectedTrack.id),
                initialValue: _selectedTrack,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  labelText: 'Select Rail Section / Block',
                  prefixIcon: const Icon(
                    Icons.train_rounded,
                    color: Color(0xFFD97706),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                items: _selectedDivision.sections.map((sec) {
                  return DropdownMenuItem(
                    value: sec,
                    child: Text(
                      sec.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
                onChanged: (TrackSection? section) {
                  if (section != null) {
                    setState(() {
                      _selectedTrack = section;
                    });
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTrackMapRouteCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Live Schematic Route & Chainage',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      _selectedTrack.subSection,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.health_and_safety_rounded,
                        color: Color(0xFF15803D),
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Health ${_selectedTrack.healthScore}%',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Color(0xFF15803D),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    left: 20,
                    right: 20,
                    top: 48,
                    child: Container(height: 4, color: const Color(0xFF475569)),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    top: 56,
                    child: Container(height: 4, color: const Color(0xFF475569)),
                  ),
                  Positioned(
                    left: 60,
                    right: 80,
                    top: 48,
                    child: Container(height: 4, color: const Color(0xFF38BDF8)),
                  ),
                  Positioned(
                    left: 60,
                    right: 80,
                    top: 56,
                    child: Container(height: 4, color: const Color(0xFF38BDF8)),
                  ),
                  Positioned(
                    left: 25,
                    child: _buildStationNode('Origin', 'KM 00'),
                  ),
                  Positioned(
                    left: 120,
                    child: _buildStationNode('Junction A', 'KM 24'),
                  ),
                  Positioned(
                    right: 110,
                    child: _buildStationNode(
                      'Yard / Loop',
                      'KM 48',
                      isActive: true,
                    ),
                  ),
                  Positioned(
                    right: 25,
                    child: _buildStationNode('Terminal', 'KM 68'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStationNode(String name, String km, {bool isActive = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 8,
          backgroundColor: isActive
              ? const Color(0xFF38BDF8)
              : const Color(0xFF94A3B8),
          child: CircleAvatar(
            radius: 4,
            backgroundColor: isActive ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.white : const Color(0xFF94A3B8),
          ),
        ),
        Text(km, style: const TextStyle(fontSize: 8, color: Color(0xFF64748B))),
      ],
    );
  }

  Widget _buildTrackMetricsRow() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'Track Age',
                value: '${_selectedTrack.ageYears} Years',
                subtitle:
                    'Laid: ${_selectedTrack.laidYear} (${_selectedTrack.railType})',
                icon: Icons.history_toggle_off_rounded,
                badgeColor: const Color(0xFF3B82F6),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                title: 'Annual Track Usage',
                value: '${_selectedTrack.annualUsageGmt} GMT',
                subtitle: 'Gross Million Tonnes/yr · High Density',
                icon: Icons.speed_rounded,
                badgeColor: const Color(0xFFD97706),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                title: 'Daily Train Traffic',
                value: '${_selectedTrack.dailyTrainCount} Trains',
                subtitle:
                    '${_selectedTrack.passengerTrains} Passenger | ${_selectedTrack.freightTrains} Freight',
                icon: Icons.directions_railway_filled_rounded,
                badgeColor: const Color(0xFF059669),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricCard(
                title: 'Sleeper Specification',
                value: 'PSC 1660',
                subtitle: _selectedTrack.sleeperType,
                icon: Icons.straighten_rounded,
                badgeColor: const Color(0xFF7C3AED),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color badgeColor,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    // FIX: withValues instead of withOpacity
                    color: badgeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: badgeColor, size: 18),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostHistoryCard() {
    final history = _selectedTrack.maintenanceCostHistory;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Track Building & Repair Cost Variations',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'Historical annual expenditure in ₹ Crores (INR)',
                      style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildLegendItem(
                      'Building (Capex)',
                      const Color(0xFF1E3A8A),
                    ),
                    const SizedBox(width: 10),
                    _buildLegendItem(
                      'Repair & Maintenance',
                      const Color(0xFFF59E0B),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 160,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: history.map((item) {
                  const double maxScale = 10.0;
                  final double capexHeight =
                      (item.buildingCapexCr / maxScale) * 120;
                  final double repairHeight =
                      (item.repairCostCr / maxScale) * 120;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 14,
                            height: capexHeight.clamp(8, 120),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E3A8A),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 3),
                          Container(
                            width: 14,
                            height: repairHeight.clamp(8, 120),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF59E0B),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.year,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            const Divider(height: 28),
            const Text(
              'Recent Track Maintenance Operations',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            ..._selectedTrack.maintenanceLogs.map(
              (log) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF10B981),
                      size: 15,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      log,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF334155),
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

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Color(0xFF475569)),
        ),
      ],
    );
  }

  Widget _build3DTrackViewerCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(
                      Icons.view_in_ar_rounded,
                      color: Color(0xFF1E3A8A),
                      size: 22,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '3D Track End Perspective & Cross-Section',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Interactive 3D View',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4338CA),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Perspective projection of selected track block, concrete sleepers, fasteners, and crushed ballast bed.',
              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 240,
                width: double.infinity,
                color: const Color(0xFF0F172A),
                child: CustomPaint(
                  painter: Track3DPainter(
                    yawAngle: _viewAngle,
                    inspectedKm: _inspectedKm,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.threesixty_rounded,
                  size: 18,
                  color: Color(0xFF64748B),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Perspective Angle:',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                Expanded(
                  child: Slider(
                    value: _viewAngle,
                    min: -0.6,
                    max: 0.6,
                    divisions: 20,
                    activeColor: const Color(0xFF1E3A8A),
                    onChanged: (val) {
                      setState(() {
                        _viewAngle = val;
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(
                  Icons.straighten_rounded,
                  size: 18,
                  color: Color(0xFF64748B),
                ),
                const SizedBox(width: 8),
                Text(
                  'Chainage: KM ${_inspectedKm.toStringAsFixed(1)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Expanded(
                  child: Slider(
                    value: _inspectedKm,
                    min: 24.0,
                    max: 68.0,
                    activeColor: const Color(0xFFD97706),
                    onChanged: (val) {
                      setState(() {
                        _inspectedKm = val;
                      });
                    },
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

/// Custom 3D Painter rendering the railway track perspective at the end of the section.
class Track3DPainter extends CustomPainter {
  final double yawAngle;
  final double inspectedKm;

  Track3DPainter({required this.yawAngle, required this.inspectedKm});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2 + (yawAngle * 100),
      size.height * 0.25,
    );
    final horizonY = size.height * 0.25;

    // 1. Draw Ballast Bed
    final ballastPath = Path();
    ballastPath.moveTo(center.dx - 40, horizonY);
    ballastPath.lineTo(center.dx + 40, horizonY);
    ballastPath.lineTo(size.width + 50, size.height);
    ballastPath.lineTo(-50, size.height);
    ballastPath.close();

    final ballastPaint = Paint()
      ..color = const Color(0xFF334155)
      ..style = PaintingStyle.fill;
    canvas.drawPath(ballastPath, ballastPaint);

    final ballastStonesPaint = Paint()
      // FIX: withValues instead of withOpacity
      ..color = const Color(0xFF475569).withValues(alpha: 0.4)
      ..strokeWidth = 1.0;
    for (int i = 0; i < 30; i++) {
      double py = horizonY + (size.height - horizonY) * (i / 30);
      double spread = (py - horizonY) * 1.5;
      canvas.drawLine(
        Offset(center.dx - spread, py),
        Offset(center.dx + spread, py),
        ballastStonesPaint,
      );
    }

    // 2. Concrete Sleepers
    final sleeperPaint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..style = PaintingStyle.fill;

    final sleeperEdgePaint = Paint()
      ..color = const Color(0xFF64748B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    const int totalSleepers = 18;
    for (int i = 1; i <= totalSleepers; i++) {
      final double t = math.pow(i / totalSleepers, 2.2).toDouble();
      final double y = horizonY + (size.height - horizonY) * t;
      final double width = 30 + (size.width * 0.72) * t;
      final double sleeperThickness = (3 + 9 * t);

      final Rect sleeperRect = Rect.fromCenter(
        center: Offset(center.dx, y),
        width: width,
        height: sleeperThickness,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(sleeperRect, const Radius.circular(2)),
        sleeperPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(sleeperRect, const Radius.circular(2)),
        sleeperEdgePaint,
      );

      if (t > 0.3) {
        final fastenerPaint = Paint()..color = const Color(0xFFD97706);
        final leftRailX = center.dx - (width * 0.36);
        final rightRailX = center.dx + (width * 0.36);
        canvas.drawCircle(Offset(leftRailX, y), 2.5 * t, fastenerPaint);
        canvas.drawCircle(Offset(rightRailX, y), 2.5 * t, fastenerPaint);
      }
    }

    // 3. Steel Rails
    final railHeadPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    final railFlangePaint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..strokeWidth = 9.0;

    final leftTop = Offset(center.dx - 18, horizonY);
    final leftBottom = Offset(size.width * 0.16 + (yawAngle * 30), size.height);

    final rightTop = Offset(center.dx + 18, horizonY);
    final rightBottom = Offset(
      size.width * 0.84 + (yawAngle * 30),
      size.height,
    );

    canvas.drawLine(leftTop, leftBottom, railFlangePaint);
    canvas.drawLine(rightTop, rightBottom, railFlangePaint);
    canvas.drawLine(leftTop, leftBottom, railHeadPaint);
    canvas.drawLine(rightTop, rightBottom, railHeadPaint);

    // 4. End HUD Overlay
    final hudPaint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final hudRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.72),
      width: 140,
      height: 40,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(hudRect, const Radius.circular(8)),
      hudPaint,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text:
            '3D SCAN: KM ${inspectedKm.toStringAsFixed(1)}\nRAIL WEAR: 0.14mm (NORMAL)',
        style: const TextStyle(
          color: Color(0xFF38BDF8),
          fontSize: 9,
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace',
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        size.width / 2 - (textPainter.width / 2),
        size.height * 0.72 - (textPainter.height / 2),
      ),
    );
  }

  @override
  bool shouldRepaint(covariant Track3DPainter oldDelegate) {
    return oldDelegate.yawAngle != yawAngle ||
        oldDelegate.inspectedKm != inspectedKm;
  }
}

class RailwayDivision {
  final String name;
  final String code;
  final List<TrackSection> sections;
  RailwayDivision({
    required this.name,
    required this.code,
    required this.sections,
  });
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
}
