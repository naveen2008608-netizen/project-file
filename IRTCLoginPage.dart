import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'rail_water_manage.dart';

void main() {
  runApp(const IRTCLoginApp());
}

/// Root Application Widget with Dark/Light Theme Switching
class IRTCLoginApp extends StatefulWidget {
  const IRTCLoginApp({super.key});

  @override
  State<IRTCLoginApp> createState() => _IRTCLoginAppState();
}

class _IRTCLoginAppState extends State<IRTCLoginApp> {
  // Theme state: true = Black (Dark) theme, false = White (Light) theme
  bool _isDarkMode = true;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IRTC Railway Portal',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      // White (Light) Theme
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF0284C7),
          secondary: Color(0xFF0369A1),
          surface: Colors.white,
          onSurface: Color(0xFF0F172A),
        ),
        fontFamily: 'Roboto',
      ),
      // Black (Dark) Theme
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF090D16),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF38BDF8),
          secondary: Color(0xFF60A5FA),
          surface: Color(0xFF131A29),
          onSurface: Colors.white,
        ),
        fontFamily: 'Roboto',
      ),
      home: IRTCLoginPage(isDarkMode: _isDarkMode, onToggleTheme: _toggleTheme),
    );
  }
}

/// Modern Glassmorphic Login Page for IRTC featuring realistic Vande Bharat background
class IRTCLoginPage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const IRTCLoginPage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<IRTCLoginPage> createState() => _IRTCLoginPageState();
}

class _IRTCLoginPageState extends State<IRTCLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Branch Selection Options
  final List<String> _branchOptions = const [
    'Track Detector',
    'Track Mentor',
    'Water Management',
  ];
  String _selectedBranch = 'Track Detector';

  // Password visibility & remember session
  bool _obscurePassword = true;
  bool _rememberMe = true;

  // Real-time Date and Time timer
  late DateTime _currentTime;
  Timer? _clockTimer;

  // Realistic Vande Bharat Express Image URL
  static const String _vandeBharatImageUrl =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/4/43/Vande_Bharat_Express_train.jpg/1920px-Vande_Bharat_Express_train.jpg';

  // High-resolution backup image of Vande Bharat
  static const String _vandeBharatBackupUrl =
      'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fe/Vande_Bharat_Express_on_Platform_16_in_New_Delhi_02.jpg/1920px-Vande_Bharat_Express_on_Platform_16_in_New_Delhi_02.jpg';

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    // Ticking live clock
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Format Time (HH:mm:ss AM/PM)
  String _formatTime(DateTime dt) {
    int hour = dt.hour;
    final period = hour >= 12 ? 'PM' : 'AM';
    hour = hour % 12;
    if (hour == 0) hour = 12;
    final hStr = hour.toString().padLeft(2, '0');
    final mStr = dt.minute.toString().padLeft(2, '0');
    final sStr = dt.second.toString().padLeft(2, '0');
    return '$hStr:$mStr:$sStr $period';
  }

  // Format Date (Day, Month DD, YYYY)
  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dayName = weekdays[dt.weekday - 1];
    final monthName = months[dt.month - 1];
    final day = dt.day.toString().padLeft(2, '0');
    final year = dt.year;
    return '$dayName, $monthName $day, $year';
  }

  IconData _getBranchIcon(String branch) {
    switch (branch) {
      case 'Track Detector':
        return Icons.radar_rounded;
      case 'Track Mentor':
        return Icons.alt_route_rounded;
      case 'Water Management':
        return Icons.water_drop_rounded;
      default:
        return Icons.device_hub_rounded;
    }
  }

  String _getBranchDescription(String branch) {
    switch (branch) {
      case 'Track Detector':
        return 'Sensors, Ultrasonic Rail Flaw Detection & Alert System';
      case 'Track Mentor':
        return 'Inspection, Alignment & Track Advisory';
      case 'Water Management':
        return 'Station Hydro-Logistics & Tank Level Control';
      default:
        return '';
    }
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      final user = _userIdController.text.trim();

      if (_selectedBranch == 'Water Management') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WaterManagementPage(
              isDarkMode: widget.isDarkMode,
              onToggleTheme: widget.onToggleTheme,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            backgroundColor: widget.isDarkMode
                ? const Color(0xFF059669)
                : const Color(0xFF10B981),
            content: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Access granted for $user in [$_selectedBranch]!',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;

    // Theme-dependent surface and glass colors
    final cardBgColor = isDark
        ? const Color(0xFF0F172A).withValues(alpha: 0.72)
        : Colors.white.withValues(alpha: 0.88);

    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.16)
        : Colors.black.withValues(alpha: 0.09);

    final inputFillColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : const Color(0xFFF1F5F9);

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
          // 1. Realistic Vande Bharat Express Background Image with Fallback Handling
          Positioned.fill(
            child: Image.network(
              _vandeBharatImageUrl,
              fit: BoxFit.cover,
              alignment: const Alignment(
                0.1,
                -0.2,
              ), // Focuses on aerodynamic nose
              headers: const {
                'User-Agent':
                    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) FlutterApp',
              },
              errorBuilder: (context, error, stackTrace) {
                // Secondary backup URL for Vande Bharat
                return Image.network(
                  _vandeBharatBackupUrl,
                  fit: BoxFit.cover,
                  headers: const {
                    'User-Agent':
                        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) FlutterApp',
                  },
                  errorBuilder: (context, error2, stackTrace2) {
                    // Modern gradient fallback if completely offline
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [
                                  const Color(0xFF020617),
                                  const Color(0xFF0F172A),
                                  const Color(0xFF1E293B),
                                ]
                              : [
                                  const Color(0xFFE2E8F0),
                                  const Color(0xFFCBD5E1),
                                  const Color(0xFF94A3B8),
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // 2. Translucent Gradient Overlay for High Contrast and Transparency Aesthetics
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          Colors.black.withValues(alpha: 0.85),
                          const Color(0xFF030712).withValues(alpha: 0.76),
                          Colors.black.withValues(alpha: 0.92),
                        ]
                      : [
                          Colors.white.withValues(alpha: 0.75),
                          const Color(0xFFF8FAFC).withValues(alpha: 0.65),
                          Colors.white.withValues(alpha: 0.88),
                        ],
                ),
              ),
            ),
          ),

          // 3. Main Form Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 24.0,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Top Row: Live Date & Time + Theme Conversion Button
                      _buildTopActionBar(
                        isDark: isDark,
                        textPrimary: textPrimary,
                        accentPrimary: accentPrimary,
                        borderColor: borderColor,
                      ),

                      const SizedBox(height: 18),

                      // Glassmorphic Card
                      ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                          child: Container(
                            decoration: BoxDecoration(
                              color: cardBgColor,
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: borderColor,
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isDark
                                      ? Colors.black.withValues(alpha: 0.6)
                                      : Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 36,
                                  offset: const Offset(0, 16),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28.0,
                              vertical: 30.0,
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Header: IRTC + Vande Bharat Operations Indicator
                                  _buildHeader(
                                    isDark: isDark,
                                    textPrimary: textPrimary,
                                    textSecondary: textSecondary,
                                    accentPrimary: accentPrimary,
                                  ),

                                  const SizedBox(height: 26),

                                  // Bar 1: User ID
                                  _buildFieldLabel(
                                    'User ID / Officer Code',
                                    textSecondary,
                                  ),
                                  const SizedBox(height: 8),
                                  _buildUserIdField(
                                    isDark: isDark,
                                    textPrimary: textPrimary,
                                    accentPrimary: accentPrimary,
                                    inputFillColor: inputFillColor,
                                    borderColor: borderColor,
                                  ),

                                  const SizedBox(height: 18),

                                  // Bar 2: Password
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildFieldLabel(
                                        'Password',
                                        textSecondary,
                                      ),
                                      TextButton(
                                        onPressed: () {},
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: Size.zero,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: Text(
                                          'Forgot?',
                                          style: TextStyle(
                                            color: accentPrimary,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  _buildPasswordField(
                                    isDark: isDark,
                                    textPrimary: textPrimary,
                                    accentPrimary: accentPrimary,
                                    inputFillColor: inputFillColor,
                                    borderColor: borderColor,
                                  ),

                                  const SizedBox(height: 18),

                                  // Bar 3: Branch Selection Bar (Track Detector, Track Mentor, Water Management)
                                  _buildFieldLabel(
                                    'Select Branch',
                                    textSecondary,
                                  ),
                                  const SizedBox(height: 8),
                                  _buildBranchSelector(
                                    isDark: isDark,
                                    textPrimary: textPrimary,
                                    textSecondary: textSecondary,
                                    accentPrimary: accentPrimary,
                                    inputFillColor: inputFillColor,
                                    borderColor: borderColor,
                                  ),

                                  const SizedBox(height: 16),

                                  // Remember Me & Terminal Version
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            _rememberMe = !_rememberMe;
                                          });
                                        },
                                        borderRadius: BorderRadius.circular(6),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 22,
                                              height: 22,
                                              child: Checkbox(
                                                value: _rememberMe,
                                                activeColor: accentPrimary,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                onChanged: (val) {
                                                  setState(() {
                                                    _rememberMe = val ?? true;
                                                  });
                                                },
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Remember Terminal',
                                              style: TextStyle(
                                                color: textSecondary,
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        'v2.4 VB-LTS',
                                        style: TextStyle(
                                          color: textSecondary.withValues(
                                            alpha: 0.6,
                                          ),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 22),

                                  // Submit Button
                                  _buildSubmitButton(),

                                  const SizedBox(height: 18),

                                  // Intranet Security Tag
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.verified_user_rounded,
                                        size: 14,
                                        color: Color(0xFF10B981),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Secured IRTC Railway Intranet Protocol',
                                        style: TextStyle(
                                          color: textSecondary,
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Top Bar with Live Clock and Black & White Theme Button
  Widget _buildTopActionBar({
    required bool isDark,
    required Color textPrimary,
    required Color accentPrimary,
    required Color borderColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Live Date & Time Display
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1E293B).withValues(alpha: 0.7)
                  : Colors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time_filled_rounded,
                  size: 14,
                  color: accentPrimary,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    '${_formatTime(_currentTime)}  •  ${_formatDate(_currentTime)}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 8),

        // Black and White Theme Conversion Button
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onToggleTheme,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E293B).withValues(alpha: 0.7)
                    : Colors.white.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFFFBBF24)
                          : const Color(0xFF0284C7),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isDark
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                      size: 13,
                      color: isDark ? const Color(0xFF0F172A) : Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isDark ? 'Dark' : 'Light',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// IRTC Logo and Branding with Vande Bharat Badge
  Widget _buildHeader({
    required bool isDark,
    required Color textPrimary,
    required Color textSecondary,
    required Color accentPrimary,
  }) {
    return Column(
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0284C7), Color(0xFF4F46E5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0284C7).withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.train_rounded, color: Colors.white, size: 32),
        ),
        const SizedBox(height: 12),
        // Title: IRTC
        Text(
          'IRTC',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 3),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: accentPrimary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: accentPrimary.withValues(alpha: 0.3)),
              ),
              child: Text(
                'VANDE BHARAT OPERATIONS',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: accentPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Indian Railway Technical & Operations Portal',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label, Color color) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.0,
        color: color,
      ),
    );
  }

  /// Bar 1: User ID
  Widget _buildUserIdField({
    required bool isDark,
    required Color textPrimary,
    required Color accentPrimary,
    required Color inputFillColor,
    required Color borderColor,
  }) {
    return TextFormField(
      controller: _userIdController,
      style: TextStyle(
        color: textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: 'e.g. IRTC-EMP-4092',
        hintStyle: TextStyle(
          color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
          fontSize: 13.5,
        ),
        prefixIcon: Icon(Icons.badge_rounded, color: accentPrimary, size: 20),
        filled: true,
        fillColor: inputFillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: accentPrimary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.6),
        ),
      ),
      validator: (val) {
        if (val == null || val.trim().isEmpty) {
          return 'Please enter your User ID';
        }
        return null;
      },
    );
  }

  /// Bar 2: Password
  Widget _buildPasswordField({
    required bool isDark,
    required Color textPrimary,
    required Color accentPrimary,
    required Color inputFillColor,
    required Color borderColor,
  }) {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: TextStyle(
        color: textPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: '••••••••••••',
        hintStyle: TextStyle(
          color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
          fontSize: 13.5,
        ),
        prefixIcon: Icon(Icons.lock_rounded, color: accentPrimary, size: 20),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_off_rounded
                : Icons.visibility_rounded,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            size: 20,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        filled: true,
        fillColor: inputFillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: accentPrimary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.6),
        ),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Please enter your password';
        }
        if (val.length < 4) {
          return 'Password must be at least 4 characters';
        }
        return null;
      },
    );
  }

  /// Bar 3: Branch Selection Bar (Track Detector, Track Mentor, Water Management)
  Widget _buildBranchSelector({
    required bool isDark,
    required Color textPrimary,
    required Color textSecondary,
    required Color accentPrimary,
    required Color inputFillColor,
    required Color borderColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: inputFillColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedBranch,
              isExpanded: true,
              dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: textSecondary,
              ),
              items: _branchOptions.map((String branch) {
                return DropdownMenuItem<String>(
                  value: branch,
                  child: Row(
                    children: [
                      Icon(
                        _getBranchIcon(branch),
                        color: accentPrimary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        branch,
                        style: TextStyle(
                          color: textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedBranch = newValue;
                  });
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.info_outline_rounded, size: 13, color: accentPrimary),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                _getBranchDescription(_selectedBranch),
                style: TextStyle(
                  fontSize: 11,
                  color: textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Submit Button
  Widget _buildSubmitButton() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [Color(0xFF0284C7), Color(0xFF2563EB), Color(0xFF4F46E5)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0284C7).withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handleLogin,
          borderRadius: BorderRadius.circular(14),
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sign In to Terminal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
