import 'package:flutter/material.dart';
import 'package:flutter_nivasshub/routes/app_routes.dart';

class KycStatusScreen extends StatefulWidget {
  final bool isAlreadyApproved;

  const KycStatusScreen({
    super.key,
    this.isAlreadyApproved = false,
  });

  @override
  State<KycStatusScreen> createState() => _KycStatusScreenState();
}

class _KycStatusScreenState extends State<KycStatusScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  static const Color _primaryBlue = Color(0xFF1976D2);
  static const Color _successGreen = Color(0xFF25A969);

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ============================================================
  // COMMON DASHBOARD NAVIGATION
  // ============================================================

  void _continueToDashboard() {
    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.dashboard,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final backgroundColor =
        isDark ? const Color(0xFF121212) : Colors.white;

    final headingColor =
        isDark ? Colors.white : const Color(0xFF1A1A1A);

    final bodyColor =
        isDark ? Colors.white70 : Colors.black54;

    final cardColor =
        isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF7FAFD);

    final borderColor =
        isDark ? Colors.white24 : const Color(0xFFE0E7EF);

    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding =
                constraints.maxWidth < 360 ? 20.0 : 28.0;

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.09,
                  ),

                  // ==================================================
                  // SUCCESS ICON
                  // ==================================================

                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width:
                          constraints.maxWidth < 360 ? 94 : 110,
                      height:
                          constraints.maxWidth < 360 ? 94 : 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            _successGreen.withValues(alpha: 0.12),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              _successGreen.withValues(alpha: 0.18),
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: _successGreen,
                          size: 58,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ==================================================
                  // TITLE
                  // ==================================================

                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      widget.isAlreadyApproved
                          ? 'KYC Verified!'
                          : 'KYC Submitted',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: headingColor,
                        fontSize:
                            constraints.maxWidth < 360 ? 24 : 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ==================================================
                  // DESCRIPTION
                  // ==================================================

                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Text(
                        widget.isAlreadyApproved
                            ? 'Your KYC is already approved.'
                            : 'Your KYC is under review. You will be notified once approved.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: bodyColor,
                          fontSize:
                              constraints.maxWidth < 360 ? 14 : 15,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ==================================================
                  // STATUS CARD
                  // ==================================================

                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: borderColor,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _successGreen.withValues(
                                    alpha: 0.10,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.verified_outlined,
                                  color: _successGreen,
                                  size: 24,
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.isAlreadyApproved
                                          ? 'Verification Successful'
                                          : 'Documents Submitted Successfully',
                                      style: TextStyle(
                                        color: headingColor,
                                        fontSize: 15,
                                        fontWeight:
                                            FontWeight.w600,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    Text(
                                      widget.isAlreadyApproved
                                          ? 'Your identity has already been verified. You can continue using Nivaas Hub.'
                                          : 'Your KYC documents have been successfully submitted for verification.',
                                      style: TextStyle(
                                        color: bodyColor,
                                        fontSize: 13,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          Container(
                            width: double.infinity,
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: _successGreen.withValues(
                                alpha: 0.06,
                              ),
                              borderRadius:
                                  BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: _successGreen,
                                  size: 20,
                                ),

                                const SizedBox(width: 10),

                                Expanded(
                                  child: Text(
                                    widget.isAlreadyApproved
                                        ? 'KYC Status: Approved'
                                        : 'KYC Status: Submitted',
                                    style: TextStyle(
                                      color: headingColor,
                                      fontSize: 13,
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // ==================================================
                  // CONTINUE TO HOME
                  // ==================================================

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _continueToDashboard,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Text(
                            'Continue to Home',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    widget.isAlreadyApproved
                        ? 'You can now access your Nivaas Hub Home.'
                        : 'Your KYC submission has been received.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: bodyColor,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}