import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:video_player/video_player.dart'; // NEW (video background)

import 'api.dart';
import 'rail_track.dart';
import 'track_mentor.dart';
import 'rail_water_manage.dart';

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
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Timer? _clockTimer;

  String _currentTime = '';
  String _currentDate = '';
  String _locationText = 'Detecting location...';

  bool _passwordVisible = false;
  bool _isLoading = false;

  // NEW: video background state
  VideoPlayerController? _videoController;
  bool _videoReady = false;

  String _selectedBranch = 'Track Detector';

  final List<String> _branches = [
    'Track Detector',
    'Track Mentor',
    'Water Management',
  ];

  @override
  void initState() {
    super.initState();

    _updateDateTime();

    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateDateTime();
    });

    _getLiveLocation();
    _initVideo(); // NEW
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    _videoController?.dispose(); // NEW
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // NEW: load and loop the background video (muted)
  Future<void> _initVideo() async {
    try {
      final controller = VideoPlayerController.asset(
        'assets/videos/train.mp4',
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );

      await controller.initialize();
      await controller.setLooping(true);
      await controller.setVolume(0);
      await controller.play();

      if (!mounted) {
        controller.dispose();
        return;
      }

      setState(() {
        _videoController = controller;
        _videoReady = true;
      });
    } catch (e) {
      // If the video fails, the image/gradient background is used instead.
    }
  }

  void _updateDateTime() {
    if (!mounted) return;

    final now = DateTime.now();

    setState(() {
      _currentTime =
          '${now.hour.toString().padLeft(2, '0')}:'
          '${now.minute.toString().padLeft(2, '0')}:'
          '${now.second.toString().padLeft(2, '0')}';

      _currentDate =
          '${now.day.toString().padLeft(2, '0')}/'
          '${now.month.toString().padLeft(2, '0')}/'
          '${now.year}';
    });
  }

  Future<void> _getLiveLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) return;

        setState(() {
          _locationText = 'Location service disabled';
        });

        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (!mounted) return;

        setState(() {
          _locationText = 'Location permission denied';
        });

        return;
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;

        setState(() {
          _locationText = 'Location permission blocked';
        });

        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) return;

      setState(() {
        _locationText =
            '${position.latitude.toStringAsFixed(5)}, '
            '${position.longitude.toStringAsFixed(5)}';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _locationText = 'Location unavailable';
      });
    }
  }

  Future<void> _handleLogin() async {
    final userId = _userIdController.text.trim();
    final password = _passwordController.text.trim();

    if (userId.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter User ID and Password')),
      );

      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final data = await ApiService.login(
        userId: userId,
        password: password,
        branch: _selectedBranch,
      );

      if (!mounted) return;

      if (data['success'] == true) {
        final branch = data['branch'];

        if (branch == 'Track Detector') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const TrackDefectScreen()),
          );
        } else if (branch == 'Track Mentor') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TrackMentorScreen()),
          );
        } else if (branch == 'Water Management') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => WaterManagementPage(
                isDarkMode: widget.isDarkMode,
                onToggleTheme: widget.onToggleTheme,
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Invalid login details')),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to connect to server: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  IconData _branchIcon(String branch) {
    switch (branch) {
      case 'Track Detector':
        return Icons.sensors;
      case 'Track Mentor':
        return Icons.track_changes;
      case 'Water Management':
        return Icons.water_drop;
      default:
        return Icons.business;
    }
  }

  String _branchDescription(String branch) {
    switch (branch) {
      case 'Track Detector':
        return 'Rail flaw detection and track monitoring';

      case 'Track Mentor':
        return 'Track inspection and alignment advisory';

      case 'Water Management':
        return 'Borewell and railway water monitoring';

      default:
        return '';
    }
  }

  // Fallback gradient if both video and image are missing
  Widget _fallbackBackground(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? const [Color(0xFF020817), Color(0xFF08243D), Color(0xFF001018)]
              : const [Color(0xFFE8F4FF), Color(0xFFD4EAFE), Color(0xFFF5FAFF)],
        ),
      ),
    );
  }

  // NEW: video if ready, otherwise the photo, otherwise the gradient
  Widget _buildBackground(bool isDark) {
    if (_videoReady && _videoController != null) {
      return FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _videoController!.value.size.width,
          height: _videoController!.value.size.height,
          child: VideoPlayer(_videoController!),
        ),
      );
    }

    return Image.asset(
      'assets/images/vande_bharat.jpg',
      fit: BoxFit.cover,
      alignment: Alignment.centerLeft,
      errorBuilder: (context, error, stackTrace) => _fallbackBackground(isDark),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;

    const textShadow = [
      Shadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 2)),
    ];

    return Scaffold(
      body: Stack(
        children: [
          // =====================================================
          // BACKGROUND - TRAIN VIDEO (fallback: photo, then gradient)
          // =====================================================
          Positioned.fill(child: _buildBackground(isDark)),

          // Overlay for readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          Colors.black.withValues(alpha: 0.35),
                          Colors.black.withValues(alpha: 0.50),
                          Colors.black.withValues(alpha: 0.75),
                        ]
                      : [
                          Colors.black.withValues(alpha: 0.15),
                          Colors.black.withValues(alpha: 0.25),
                          Colors.black.withValues(alpha: 0.50),
                        ],
                ),
              ),
            ),
          ),

          // =====================================================
          // MAIN CONTENT
          // =====================================================
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 18,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 36,
                    ),
                    child: Column(
                      children: [
                        // TOP BAR (location + theme toggle)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: _infoCard(
                                icon: Icons.location_on,
                                title: 'LIVE LOCATION',
                                subtitle: _locationText,
                                isDark: isDark,
                              ),
                            ),
                            IconButton(
                              onPressed: widget.onToggleTheme,
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.18,
                                ),
                              ),
                              icon: Icon(
                                isDark ? Icons.light_mode : Icons.dark_mode,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // HEADER
                        const Icon(
                          Icons.train,
                          size: 66,
                          color: Colors.white,
                          shadows: textShadow,
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          'IRTC',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 8,
                            color: Colors.white,
                            shadows: textShadow,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          'RAILWAY MANAGEMENT PORTAL',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 3,
                            color: Colors.blue.shade100,
                            shadows: textShadow,
                          ),
                        ),

                        const SizedBox(height: 26),

                        // LOGIN CARD
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 520),
                          padding: const EdgeInsets.all(26),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.black.withValues(alpha: 0.55)
                                : Colors.white.withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.15)
                                  : Colors.blue.withValues(alpha: 0.15),
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 30,
                                spreadRadius: 2,
                                color: Colors.black.withValues(
                                  alpha: isDark ? 0.35 : 0.15,
                                ),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Secure Officer Login',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                'Access your railway management module',
                                style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 0.3,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black54,
                                ),
                              ),

                              const SizedBox(height: 25),

                              // USER ID
                              TextField(
                                controller: _userIdController,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'User ID / Officer Code',
                                  prefixIcon: const Icon(Icons.person_outline),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // PASSWORD
                              TextField(
                                controller: _passwordController,
                                obscureText: !_passwordVisible,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                    icon: Icon(
                                      _passwordVisible
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // BRANCH
                              DropdownButtonFormField<String>(
                                initialValue: _selectedBranch,
                                decoration: InputDecoration(
                                  labelText: 'Select Branch',
                                  prefixIcon: Icon(
                                    _branchIcon(_selectedBranch),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                items: _branches.map((branch) {
                                  return DropdownMenuItem(
                                    value: branch,
                                    child: Text(branch),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value == null) return;

                                  setState(() {
                                    _selectedBranch = value;
                                  });
                                },
                              ),

                              const SizedBox(height: 8),

                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                  _branchDescription(_selectedBranch),
                                  style: TextStyle(
                                    fontSize: 12,
                                    letterSpacing: 0.2,
                                    color: isDark
                                        ? Colors.white60
                                        : Colors.black54,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // LOGIN BUTTON
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: ElevatedButton.icon(
                                  onPressed: _isLoading ? null : _handleLogin,
                                  icon: _isLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(Icons.login),
                                  label: Text(
                                    _isLoading
                                        ? 'AUTHENTICATING...'
                                        : 'LOGIN TO PORTAL',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // SECURITY TEXT
                              Center(
                                child: Text(
                                  'SECURED IRTC RAILWAY INTRANET PROTOCOL',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    letterSpacing: 1.2,
                                    color: isDark
                                        ? Colors.white54
                                        : Colors.black45,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // TIME & DATE (AT THE END)
                        _infoCard(
                          icon: Icons.access_time,
                          title: _currentTime,
                          subtitle: _currentDate,
                          isDark: isDark,
                        ),

                        const SizedBox(height: 14),

                        // VERSION
                        const Text(
                          'v2.4 VB-LTS',
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 1,
                            color: Colors.white60,
                            shadows: textShadow,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: Colors.lightBlueAccent),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    letterSpacing: 0.5,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
