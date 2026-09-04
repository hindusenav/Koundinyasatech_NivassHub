import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_nivasshub/routes/app_routes.dart';

class KycStatusScreen extends StatefulWidget {
  const KycStatusScreen({
    super.key,
    this.isAlreadyApproved = false,
  });

  final bool isAlreadyApproved;

  @override
  State<KycStatusScreen> createState() =>
      _KycStatusScreenState();
}

class _KycStatusScreenState extends State<KycStatusScreen>
    with SingleTickerProviderStateMixin {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color _primaryBlue = Color(0xFF1976D2);

  static const Color _successGreen = Color(0xFF25A969);

  // ============================================================
  // ANIMATION
  // ============================================================

  late final AnimationController _animationController;

  late final Animation<double> _scaleAnimation;

  late final Animation<double> _fadeAnimation;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 800,
      ),
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

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ============================================================
  // CONTINUE TO HOME
  // ============================================================

  Future<void> _continueToDashboard() async {
    final prefs = await SharedPreferences.getInstance();

    // ==========================================================
    // SAVE KYC STATUS
    //
    // Already approved user:
    //     verified
    //
    // User who completed/submitted KYC:
    //     submitted
    // ==========================================================

    final String kycStatus =
        widget.isAlreadyApproved
            ? 'verified'
            : 'submitted';

    await prefs.setString(
      'kyc_status',
      kycStatus,
    );

    // Keep the old boolean too, if any existing code still uses it.
    await prefs.setBool(
      'kyc_completed',
      true,
    );

    if (!mounted) return;

    // ==========================================================
    // GO TO HOME
    // ==========================================================

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.dashboard,
      (route) => false,
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    final backgroundColor =
        isDark
            ? const Color(0xFF121212)
            : const Color(0xFFF7F9FC);

    final cardColor =
        isDark
            ? const Color(0xFF1E1E1E)
            : Colors.white;

    final titleColor =
        isDark
            ? Colors.white
            : const Color(0xFF1A1A1A);

    final bodyColor =
        isDark
            ? Colors.white70
            : const Color(0xFF777777);

    final borderColor =
        isDark
            ? Colors.white12
            : const Color(0xFFE1E7EF);

    // ============================================================
    // STATUS TEXT
    // ============================================================

    final String statusText =
        widget.isAlreadyApproved
            ? 'KYC Verified'
            : 'KYC Submitted';

    final String description =
        widget.isAlreadyApproved
            ? 'Your KYC is already approved.'
            : 'Your KYC details have been submitted successfully.';

    // ============================================================
    // BUILD
    // ============================================================

    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics:
                const BouncingScrollPhysics(),

            padding:
                const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 28,
            ),

            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    size.height -
                        MediaQuery.of(context)
                            .padding
                            .vertical -
                        56,
              ),

              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [
                  // ==================================================
                  // SUCCESS ICON
                  // ==================================================

                  ScaleTransition(
                    scale: _scaleAnimation,

                    child: Container(
                      width: 104,
                      height: 104,

                      decoration:
                          BoxDecoration(
                        shape:
                            BoxShape.circle,

                        color:
                            _successGreen
                                .withValues(
                          alpha: 0.10,
                        ),
                      ),

                      child: Container(
                        margin:
                            const EdgeInsets.all(
                          9,
                        ),

                        decoration:
                            BoxDecoration(
                          shape:
                              BoxShape.circle,

                          color:
                              _successGreen
                                  .withValues(
                            alpha: 0.14,
                          ),
                        ),

                        child: const Icon(
                          Icons.verified_rounded,
                          size: 56,
                          color:
                              _successGreen,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ==================================================
                  // TITLE
                  // ==================================================

                  FadeTransition(
                    opacity:
                        _fadeAnimation,

                    child: Text(
                      statusText,
                      textAlign:
                          TextAlign.center,

                      style: TextStyle(
                        color: titleColor,
                        fontSize: 28,
                        fontWeight:
                            FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ==================================================
                  // DESCRIPTION
                  // ==================================================

                  FadeTransition(
                    opacity:
                        _fadeAnimation,

                    child: Padding(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 20,
                      ),

                      child: Text(
                        description,
                        textAlign:
                            TextAlign.center,

                        style: TextStyle(
                          color: bodyColor,
                          fontSize: 14,
                          fontWeight:
                              FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ==================================================
                  // STATUS CARD
                  // ==================================================

                  FadeTransition(
                    opacity:
                        _fadeAnimation,

                    child: Material(
                      color:
                          Colors.transparent,

                      borderRadius:
                          BorderRadius
                              .circular(14),

                      child: Container(
                        width:
                            double.infinity,

                        padding:
                            const EdgeInsets
                                .all(18),

                        decoration:
                            BoxDecoration(
                          color: cardColor,

                          borderRadius:
                              BorderRadius
                                  .circular(14),

                          border:
                              Border.all(
                            color:
                                borderColor,
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: Colors
                                  .black
                                  .withValues(
                                alpha: isDark
                                    ? 0.20
                                    : 0.06,
                              ),
                              blurRadius: 10,
                              offset:
                                  const Offset(
                                0,
                                4,
                              ),
                            ),
                          ],
                        ),

                        child: Column(
                          children: [
                            // ======================================
                            // STATUS ROW
                            // ======================================

                            Row(
                              children: [
                                Container(
                                  width: 46,
                                  height: 46,

                                  decoration:
                                      BoxDecoration(
                                    shape:
                                        BoxShape
                                            .circle,

                                    color:
                                        _primaryBlue
                                            .withValues(
                                      alpha: 0.10,
                                    ),
                                  ),

                                  child:
                                      const Icon(
                                    Icons
                                        .assignment_turned_in_outlined,
                                    color:
                                        _primaryBlue,
                                    size: 25,
                                  ),
                                ),

                                const SizedBox(
                                  width: 12,
                                ),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,

                                    children: [
                                      Text(
                                        widget
                                                .isAlreadyApproved
                                            ? 'Verification Status'
                                            : 'Submission Status',

                                        style:
                                            TextStyle(
                                          color:
                                              titleColor,
                                          fontSize:
                                              14,
                                          fontWeight:
                                              FontWeight
                                                  .w500,
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 4,
                                      ),

                                      Text(
                                        widget
                                                .isAlreadyApproved
                                            ? 'Approved'
                                            : 'Submitted',

                                        style:
                                            const TextStyle(
                                          color:
                                              _successGreen,
                                          fontSize:
                                              16,
                                          fontWeight:
                                              FontWeight
                                                  .w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 16,
                            ),

                            Divider(
                              height: 1,
                              color:
                                  borderColor,
                            ),

                            const SizedBox(
                              height: 16,
                            ),

                            // ======================================
                            // MESSAGE
                            // ======================================

                            Align(
                              alignment:
                                  Alignment
                                      .centerLeft,

                              child: Text(
                                widget
                                        .isAlreadyApproved
                                    ? 'Your identity has already been verified successfully. You can continue to Home.'
                                    : 'Your KYC documents have been successfully submitted for verification.',

                                style:
                                    TextStyle(
                                  color:
                                      bodyColor,
                                  fontSize:
                                      13,
                                  height:
                                      1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ==================================================
                  // CONTINUE TO HOME
                  // ==================================================

                  FadeTransition(
                    opacity:
                        _fadeAnimation,

                    child: Material(
                      color:
                          Colors.transparent,

                      borderRadius:
                          BorderRadius
                              .circular(10),

                      child: SizedBox(
                        width:
                            double.infinity,
                        height: 52,

                        child:
                            ElevatedButton(
                          onPressed:
                              _continueToDashboard,

                          style:
                              ElevatedButton
                                  .styleFrom(
                            backgroundColor:
                                _primaryBlue,

                            foregroundColor:
                                Colors.white,

                            elevation: 2,

                            shadowColor:
                                _primaryBlue
                                    .withValues(
                              alpha: 0.25,
                            ),

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                10,
                              ),
                            ),
                          ),

                          child: const Row(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .center,

                            children: [
                              Text(
                                'Continue to Home',
                                style:
                                    TextStyle(
                                  fontSize: 15,
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                              ),

                              SizedBox(
                                width: 8,
                              ),

                              Icon(
                                Icons
                                    .arrow_forward_rounded,
                                size: 19,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ==================================================
                  // FOOTER
                  // ==================================================

                  Text(
                    widget.isAlreadyApproved
                        ? 'You can now access your Nivaas Hub Home.'
                        : 'Your KYC submission has been received.',

                    textAlign:
                        TextAlign.center,

                    style: TextStyle(
                      color: bodyColor,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}