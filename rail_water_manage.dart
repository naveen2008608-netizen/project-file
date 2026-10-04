import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const WaterManagementApp());
}

/// Standalone Water Management Application
class WaterManagementApp extends StatefulWidget {
  const WaterManagementApp({super.key});

  @override
  State<WaterManagementApp> createState() => _WaterManagementAppState();
}

class _WaterManagementAppState extends State<WaterManagementApp> {
  bool _isDarkMode = true;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Water Management - IRTC Hydro Operations',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF0284C7),
          surface: Colors.white,
          onSurface: Color(0xFF0F172A),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF090D16),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF38BDF8),
          surface: Color(0xFF131A29),
          onSurface: Colors.white,
        ),
      ),
      home: WaterManagementPage(
        isDarkMode: _isDarkMode,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

/// Model representing each Borewell
class BorewellData {
  final String id;
  double level; // Percentage (0-100)
  final String depth;
  final int totalCapacityLiters;
  final String pumpStatus;
  final String flowRate;
  final List<double> history24h;

  BorewellData({
    required this.id,
    required this.level,
    required this.depth,
    required this.totalCapacityLiters,
    required this.pumpStatus,
    required this.flowRate,
    required this.history24h,
  });

  int get remainingLiters => ((level / 100) * totalCapacityLiters).round();
}

/// Modern Water Management Dashboard Page
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

class _WaterManagementPageState extends State<WaterManagementPage>
    with SingleTickerProviderStateMixin {
  // Borewells: Trichy - 1, Trichy - 1.1, Trichy - 2, Trichy - 2.1, Trichy - 3, Trichy - 3.1
  late List<BorewellData> _borewells;
  late BorewellData _selectedBorewell;

  late DateTime _currentTime;
  Timer? _clockTimer;
  Timer? _telemetryLivePulseTimer;
  late AnimationController _pulseController;

  static const String _vandeBharatImageUrl =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/43/Vande_Bharat_Express_train.jpg/1920px-Vande_Bharat_Express_train.jpg';

  @override
  void initState() {
    super.initState();
    _initBorewells();
    _selectedBorewell = _borewells[0];

    _currentTime = DateTime.now();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() => _currentTime = DateTime.now());
    });

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    // Live micro-fluctuations to simulate real-time water sensor telemetry
    _telemetryLivePulseTimer = Timer.periodic(const Duration(seconds: 4), (
      timer,
    ) {
      if (mounted) {
        setState(() {
          final randomDelta = (Random().nextDouble() * 0.4) - 0.2;
          _selectedBorewell.level = (_selectedBorewell.level + randomDelta)
              .clamp(20.0, 99.0);
        });
      }
    });
  }

  void _initBorewells() {
    _borewells = [
      BorewellData(
        id: 'Trichy - 1',
        level: 82.4,
        depth: '240 ft',
        totalCapacityLiters: 20000,
        pumpStatus: 'Active',
        flowRate: '48 L/min',
        history24h: [75, 78, 80, 84, 86, 83, 82.4],
      ),
      BorewellData(
        id: 'Trichy - 1.1',
        level: 68.0,
        depth: '210 ft',
        totalCapacityLiters: 20000,
        pumpStatus: 'Standby',
        flowRate: '0 L/min',
        history24h: [62, 64, 66, 69, 70, 69, 68.0],
      ),
      BorewellData(
        id: 'Trichy - 2',
        level: 91.2,
        depth: '265 ft',
        totalCapacityLiters: 20000,
        pumpStatus: 'Active',
        flowRate: '52 L/min',
        history24h: [85, 87, 89, 93, 94, 92, 91.2],
      ),
      BorewellData(
        id: 'Trichy - 2.1',
        level: 45.5,
        depth: '180 ft',
        totalCapacityLiters: 20000,
        pumpStatus: 'Replenishing',
        flowRate: '18 L/min',
        history24h: [52, 50, 48, 44, 42, 44, 45.5],
      ),
      BorewellData(
        id: 'Trichy - 3',
        level: 74.0,
        depth: '225 ft',
        totalCapacityLiters: 20000,
        pumpStatus: 'Active',
        flowRate: '42 L/min',
        history24h: [70, 71, 73, 76, 77, 75, 74.0],
      ),
      BorewellData(
        id: 'Trichy - 3.1',
        level: 88.0,
        depth: '250 ft',
        totalCapacityLiters: 20000,
        pumpStatus: 'Standby',
        flowRate: '0 L/min',
        history24h: [82, 84, 86, 89, 90, 89, 88.0],
      ),
    ];
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    _telemetryLivePulseTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  String _formatTime(DateTime dt) {
    int hour = dt.hour;
    final period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    if (hour == 0) hour = 12;
    return '${hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')} $period';
  }

  Future<void> _refreshTelemetry() async {
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      final random = Random();
      for (var b in _borewells) {
        b.level = (b.level + (random.nextDouble() * 2 - 1)).clamp(25.0, 98.0);
      }
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: const Color(0xFF0284C7),
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text('Borewell telemetrics synchronized live!'),
            ],
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;

    final cardBgColor = isDark
        ? const Color(0xFF0F172A).withValues(alpha: 0.78)
        : Colors.white.withValues(alpha: 0.90);

    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.14)
        : Colors.black.withValues(alpha: 0.08);

    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);
    final accentPrimary = isDark
        ? const Color(0xFF38BDF8)
        : const Color(0xFF0284C7);

    return Scaffold(
      body: Stack(
        children: [
          // 1. Transparent Railway / Hydro Background
          Positioned.fill(
            child: Image.network(
              _vandeBharatImageUrl,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              headers: const {
                'User-Agent':
                    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) FlutterApp',
              },
              errorBuilder: (context, error, stackTrace) => Container(
                color: isDark
                    ? const Color(0xFF0B1120)
                    : const Color(0xFFE2E8F0),
              ),
            ),
          ),

          // 2. Translucent Contrast Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          Colors.black.withValues(alpha: 0.88),
                          const Color(0xFF030712).withValues(alpha: 0.82),
                          Colors.black.withValues(alpha: 0.92),
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.84),
                          const Color(0xFFF8FAFC).withValues(alpha: 0.78),
                          Colors.white.withValues(alpha: 0.92),
                        ],
                ),
              ),
            ),
          ),

          // 3. Scrollable Dashboard Body with Pull-to-Refresh
          SafeArea(
            child: RefreshIndicator(
              onRefresh: _refreshTelemetry,
              color: accentPrimary,
              backgroundColor: cardBgColor,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                  vertical: 14.0,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 860),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title Bar
                        _buildTitleBar(
                          isDark: isDark,
                          cardBgColor: cardBgColor,
                          borderColor: borderColor,
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
                          accentPrimary: accentPrimary,
                        ),

                        const SizedBox(height: 16),

                        // Borewell Area Selector Bar (Trichy - 1 to Trichy - 3.1)
                        _buildBorewellAreaBar(
                          cardBgColor: cardBgColor,
                          borderColor: borderColor,
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
                          accentPrimary: accentPrimary,
                        ),

                        const SizedBox(height: 16),

                        // Live Water Level Graph Card
                        _buildLiveWaterLevelGraphCard(
                          cardBgColor: cardBgColor,
                          borderColor: borderColor,
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
                          accentPrimary: accentPrimary,
                        ),

                        const SizedBox(height: 16),

                        // Daily Usage & Monthly Usage Cards
                        _buildDailyAndMonthlyUsageCards(
                          cardBgColor: cardBgColor,
                          borderColor: borderColor,
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
                          accentPrimary: accentPrimary,
                        ),

                        const SizedBox(height: 20),

                        // Remaining Water Level in Every Borewell (At the end of dashboard)
                        _buildRemainingWaterLevelInEveryBorewell(
                          cardBgColor: cardBgColor,
                          borderColor: borderColor,
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
                          accentPrimary: accentPrimary,
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // COMPONENT 1: TITLE BAR
  // ==========================================================================
  Widget _buildTitleBar({
    required bool isDark,
    required Color cardBgColor,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
    required Color accentPrimary,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0284C7), Color(0xFF06B6D4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0284C7).withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.water_drop_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),

              // Title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            'Water Management',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                              color: textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: accentPrimary.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: accentPrimary.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Text(
                            'TRICHY',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: accentPrimary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Live Borewell Telemetry & Hydro Logistics',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Live Time
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: accentPrimary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 13,
                      color: accentPrimary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _formatTime(_currentTime),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Theme Switcher Button
              IconButton(
                onPressed: widget.onToggleTheme,
                tooltip: 'Toggle Black/White Theme',
                style: IconButton.styleFrom(
                  backgroundColor: accentPrimary.withValues(alpha: 0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(
                  isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  size: 18,
                  color: isDark
                      ? const Color(0xFFFBBF24)
                      : const Color(0xFF0284C7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // COMPONENT 2: BOREWELL AREA SELECTOR BAR (Trichy - 1 to Trichy - 3.1)
  // ==========================================================================
  Widget _buildBorewellAreaBar({
    required Color cardBgColor,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
    required Color accentPrimary,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.radio_button_checked_rounded,
                          size: 14,
                          color: accentPrimary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'BOREWELL AREA SELECTOR',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${_borewells.length} Monitored',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Horizontal Selector Bar for Trichy - 1 to Trichy - 3.1
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: _borewells.map((borewell) {
                    final isSelected = borewell.id == _selectedBorewell.id;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedBorewell = borewell;
                          });
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: isSelected
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFF0284C7),
                                      Color(0xFF2563EB),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            color: isSelected
                                ? null
                                : (widget.isDarkMode
                                      ? Colors.white.withValues(alpha: 0.05)
                                      : const Color(0xFFF1F5F9)),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected ? accentPrimary : borderColor,
                              width: isSelected ? 1.4 : 1.0,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.water_rounded,
                                size: 14,
                                color: isSelected
                                    ? Colors.white
                                    : accentPrimary,
                              ),
                              const SizedBox(width: 7),
                              Text(
                                borewell.id,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? Colors.white
                                      : textPrimary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white.withValues(alpha: 0.22)
                                      : accentPrimary.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${borewell.level.toStringAsFixed(0)}%',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: isSelected
                                        ? Colors.white
                                        : accentPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // COMPONENT 3: LIVE GRAPH OF WATER LEVEL (CustomPainter Spline)
  // ==========================================================================
  Widget _buildLiveWaterLevelGraphCard({
    required Color cardBgColor,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
    required Color accentPrimary,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF10B981),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${_selectedBorewell.id} Live Water Level Graph',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Continuous acoustic depth sensor telemetry (24h Trend)',
                        style: TextStyle(fontSize: 11, color: textSecondary),
                      ),
                    ],
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: accentPrimary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: accentPrimary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      '${_selectedBorewell.level.toStringAsFixed(1)}% (${_selectedBorewell.remainingLiters} L)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: accentPrimary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Animated Graph Drawing Canvas
              SizedBox(
                height: 170,
                width: double.infinity,
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: LiveWaterLevelChartPainter(
                        dataPoints: _selectedBorewell.history24h,
                        currentLevel: _selectedBorewell.level,
                        pulseValue: _pulseController.value,
                        lineColor: accentPrimary,
                        isDarkMode: widget.isDarkMode,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              // Timestamps on X-Axis
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '00:00',
                    style: TextStyle(fontSize: 10, color: textSecondary),
                  ),
                  Text(
                    '04:00',
                    style: TextStyle(fontSize: 10, color: textSecondary),
                  ),
                  Text(
                    '08:00',
                    style: TextStyle(fontSize: 10, color: textSecondary),
                  ),
                  Text(
                    '12:00',
                    style: TextStyle(fontSize: 10, color: textSecondary),
                  ),
                  Text(
                    '16:00',
                    style: TextStyle(fontSize: 10, color: textSecondary),
                  ),
                  Text(
                    '20:00',
                    style: TextStyle(fontSize: 10, color: textSecondary),
                  ),
                  Text(
                    'Live Now',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: accentPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // COMPONENT 4: DAILY USAGE & MONTHLY USAGE
  // ==========================================================================
  Widget _buildDailyAndMonthlyUsageCards({
    required Color cardBgColor,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
    required Color accentPrimary,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 580;

        return Flex(
          direction: isWide ? Axis.horizontal : Axis.vertical,
          children: [
            // Daily Usage Card
            Expanded(
              flex: isWide ? 1 : 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0284C7)
                                        .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.today_rounded,
                                    size: 18,
                                    color: Color(0xFF0284C7),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'DAILY USAGE',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                    color: textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981)
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                '-4.2% Today',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '17,970',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Liters',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Quota Consumed',
                              style: TextStyle(
                                fontSize: 11,
                                color: textSecondary,
                              ),
                            ),
                            Text(
                              '64.1% of 28,000 L',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: 0.641,
                            minHeight: 7,
                            backgroundColor: textSecondary.withValues(
                              alpha: 0.2,
                            ),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF0284C7),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Peak Flow: 142 L/min (Recorded at 08:30 AM)',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            if (isWide)
              const SizedBox(width: 14)
            else
              const SizedBox(height: 14),

            // Monthly Usage Card
            Expanded(
              flex: isWide ? 1 : 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6366F1)
                                        .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.pie_chart_outline_rounded,
                                    size: 18,
                                    color: Color(0xFF6366F1),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'MONTHLY USAGE',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.8,
                                    color: textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6366F1)
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Oct 2026',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF6366F1),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '486,200',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Liters',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Monthly Allocation',
                              style: TextStyle(
                                fontSize: 11,
                                color: textSecondary,
                              ),
                            ),
                            Text(
                              '58.5% of 830,000 L',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: 0.585,
                            minHeight: 7,
                            backgroundColor: textSecondary.withValues(
                              alpha: 0.2,
                            ),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF6366F1),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Projected Month-End: ~720,000 L (Target Met)',
                          style: TextStyle(
                            fontSize: 10.5,
                            color: textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================================
  // COMPONENT 5: REMAINING WATER LEVEL IN EVERY BOREWELL (End of dashboard)
  // ==========================================================================
  Widget _buildRemainingWaterLevelInEveryBorewell({
    required Color cardBgColor,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
    required Color accentPrimary,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.layers_rounded,
                        size: 18,
                        color: accentPrimary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'REMAINING WATER LEVEL IN EVERY BOREWELL',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                          color: textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: accentPrimary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Trichy Sector',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: accentPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Live remaining aquifer reservoir level and depth across all active borewells',
                style: TextStyle(fontSize: 11, color: textSecondary),
              ),

              const SizedBox(height: 16),

              // Responsive Grid of all Borewells
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 580 ? 3 : 2;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.18,
                    ),
                    itemCount: _borewells.length,
                    itemBuilder: (context, index) {
                      final b = _borewells[index];
                      final isSelected = b.id == _selectedBorewell.id;

                      final levelColor = b.level > 70
                          ? const Color(0xFF0284C7)
                          : (b.level > 50
                                ? const Color(0xFF3B82F6)
                                : const Color(0xFFF59E0B));

                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedBorewell = b;
                          });
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? accentPrimary.withValues(alpha: 0.12)
                                : (widget.isDarkMode
                                      ? Colors.white.withValues(alpha: 0.04)
                                      : const Color(0xFFF8FAFC)),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? accentPrimary : borderColor,
                              width: isSelected ? 1.6 : 1.0,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    b.id,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: textPrimary,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 1.5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: b.pumpStatus == 'Active'
                                          ? const Color(0xFF10B981)
                                                .withValues(alpha: 0.15)
                                          : const Color(0xFF64748B)
                                                .withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      b.pumpStatus,
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                        color: b.pumpStatus == 'Active'
                                            ? const Color(0xFF10B981)
                                            : textSecondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Remaining Level in % & Liters
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        '${b.level.toStringAsFixed(0)}%',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w900,
                                          color: levelColor,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'remaining',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${b.remainingLiters} Liters left',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                      color: textPrimary,
                                    ),
                                  ),
                                ],
                              ),

                              // Water Gauge Progress Bar
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: b.level / 100,
                                  minHeight: 5,
                                  backgroundColor: textSecondary.withValues(
                                    alpha: 0.2,
                                  ),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    levelColor,
                                  ),
                                ),
                              ),

                              // Depth & Flow Rate
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Depth: ${b.depth}',
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      color: textSecondary,
                                    ),
                                  ),
                                  Text(
                                    b.flowRate,
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w600,
                                      color: textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// CUSTOM PAINTER: LIVE WATER LEVEL SPLINE CHART
// ============================================================================
class LiveWaterLevelChartPainter extends CustomPainter {
  final List<double> dataPoints;
  final double currentLevel;
  final double pulseValue;
  final Color lineColor;
  final bool isDarkMode;

  LiveWaterLevelChartPainter({
    required this.dataPoints,
    required this.currentLevel,
    required this.pulseValue,
    required this.lineColor,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    final gridPaint = Paint()
      ..color = (isDarkMode ? Colors.white : Colors.black).withValues(
        alpha: 0.05,
      )
      ..strokeWidth = 1.0;

    // Draw horizontal guidelines
    for (int i = 1; i <= 4; i++) {
      final y = size.height * (i / 4.0);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final points = <Offset>[];
    final stepX = size.width / (dataPoints.length - 1);

    for (int i = 0; i < dataPoints.length; i++) {
      final val = (i == dataPoints.length - 1) ? currentLevel : dataPoints[i];
      final normY = size.height - ((val / 100.0) * (size.height - 24) + 12);
      points.add(Offset(i * stepX, normY));
    }

    // Cubic Bezier Spline Path
    final path = Path()..moveTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlX = (p0.dx + p1.dx) / 2;
      path.cubicTo(controlX, p0.dy, controlX, p1.dy, p1.dx, p1.dy);
    }

    // Area Fill Gradient Under Curve
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          lineColor.withValues(alpha: 0.38),
          lineColor.withValues(alpha: 0.02),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    // Spline Curve Line
    final strokePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, strokePaint);

    // Live endpoint with animated pulsing radar dot
    final lastPoint = points.last;

    final pulsePaint = Paint()
      ..color = lineColor.withValues(alpha: 0.45 * (1.0 - pulseValue))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(lastPoint, 6 + (pulseValue * 10), pulsePaint);

    final centerDotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(lastPoint, 5, centerDotPaint);

    final dotBorderPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(lastPoint, 5, dotBorderPaint);
  }

  @override
  bool shouldRepaint(covariant LiveWaterLevelChartPainter oldDelegate) => true;
}
