import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:userapp/generated/l10n.dart';
import 'package:userapp/utilities/image_constants.dart';
import '../helpers/route_helper.dart';
import '../services/app_update_service.dart';
import '../widget/app_update_dialog.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _progressController;
  
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _progressAnimation;
  
  int _progress = 0;
  Timer? _progressTimer;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    _startProgressTimer();
  }

  void _initializeAnimations() {
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Progress animation controller
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Logo scale and fade animation
    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    // Text fade animation
    _textAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));

    // Progress fade animation
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() {
    // Start logo animation
    _logoController.forward();

    // Start text animation after a delay
    Timer(const Duration(milliseconds: 800), () {
      if (mounted) {
        _textController.forward();
      }
    });

    // Start progress animation after another delay
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _progressController.forward();
      }
    });
  }

  void _startProgressTimer() {
    _progressTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (mounted) {
        setState(() {
          if (_progress < 100) {
            _progress += 2;
          } else {
            timer.cancel();
            _navigateToNextScreen();
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _navigateToNextScreen() async {
    // Add a small delay before navigation for better UX
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      // Check for app updates before navigating
      await _checkForUpdates();
    }
  }

  Future<void> _checkForUpdates() async {
    try {
      // Check for updates
      final updateResult = await AppUpdateService.checkForUpdates();
      
      if (updateResult.updateRequired && mounted) {
        // Get update configuration
        final updateConfig = await AppUpdateService.getUpdateConfig();
        
        // Show update dialog
        await AppUpdateDialog.show(
          context,
          updateResult: updateResult,
          updateConfig: updateConfig,
          onLater: updateResult.forceUpdate ? null : () {
            // If not force update, proceed to home
            _navigateToHome();
          },
        );
        
        // If force update, don't navigate to home
        if (!updateResult.forceUpdate) {
          _navigateToHome();
        }
      } else {
        // No update required, navigate to home
        _navigateToHome();
      }
    } catch (e) {
      // If update check fails, still navigate to home
      _navigateToHome();
    }
  }

  void _navigateToHome() {
    if (mounted) {
      Get.offAllNamed(RouteHelper.getHomePageRoute());
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _progressController.dispose();
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D), // Dark background like in the image
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF0D0D0D),
              const Color(0xFF1A1A1A),
              const Color(0xFF0D0D0D),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              
              // Logo Animation
              AnimatedBuilder(
                animation: _logoAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _logoAnimation.value,
                    child: Opacity(
                      opacity: _logoAnimation.value.clamp(0.0, 1.0),
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFFFFD700), // Gold
                              const Color(0xFFFFA500), // Orange
                              const Color(0xFFFF8C00), // Dark orange
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF1A1A1A),
                            border: Border.all(
                              color: const Color(0xFFFFD700),
                              width: 2,
                            ),
                          ),
                          child:  Image.asset(ImageConstants.logoImage,
                            height: 200,
                            width: MediaQuery.of(context).size.width/4,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              // Title and Subtitle Animation
              AnimatedBuilder(
                animation: _textAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _textAnimation.value.clamp(0.0, 1.0),
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - _textAnimation.value)),
                      child: Column(
                        children: [
                          // Main title
                          Text(
                            S.of(context).LDoctorAmr,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2,
                              shadows: [
                                Shadow(
                                  color: const Color(0xFFFFD700).withValues(alpha: 0.5),
                                  offset: const Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // Subtitle
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD700).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child:  Text(
                              S.of(context).LHello,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFFFD700),
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const Spacer(flex: 2),

              // Progress Animation
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _progressAnimation.value.clamp(0.0, 1.0),
                    child: Column(
                      children: [
                        // Progress Bar
                        Container(
                          width: 200,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFF333333),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: _progress / 100,
                              backgroundColor: Colors.transparent,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                const Color(0xFFFFD700),
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Progress Percentage
                        Text(
                          "$_progress%",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFFFD700),
                            shadows: [
                              Shadow(
                                color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                                offset: const Offset(0, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}