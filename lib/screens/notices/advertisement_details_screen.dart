import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/services/core/api_client.dart';
import 'package:flutter_nivasshub/widgets/dashboard/navigation/dashboard_bottom_navigation.dart';
import 'package:flutter_nivasshub/screens/notices/notices_screen.dart';
import 'package:flutter_nivasshub/screens/notices/schedule_visit_screen.dart';

class AdvertisementDetailsScreen extends StatelessWidget {
  const AdvertisementDetailsScreen({
    super.key,
    required this.projectName,
  });

  final String projectName;

  bool get _isNikoo =>
      projectName.toLowerCase().contains('nikoo') ||
      projectName.toLowerCase().contains('nikaa') ||
      projectName.toLowerCase().contains('luxury');

  void _handleBackPress(BuildContext context) {
    ApiClient? apiClient;
    try {
      apiClient = context.read<ApiClient>();
    } catch (_) {}

    apiClient ??= ApiClient();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => NoticesScreen(apiClient: apiClient!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final headingColor =
        isDark ? AppColors.noticesHeadingDark : AppColors.noticesHeadingLight;

    final title = _isNikoo ? 'Nikoo Homes' : 'Century Bliss';
    final subtitle = _isNikoo
        ? 'by Bhartiya City'
        : 'Yelahanka–Doddaballapura Main Road';
    final imageUrl = _isNikoo
        ? 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=600&q=80'
        : 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=600&q=80';
    final priceLabel = _isNikoo ? '₹93L Onwards' : '₹92.5 L*';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleBackPress(context);
        }
      },
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.noticesBackgroundDark
            : AppColors.noticesBackgroundLight,
        bottomNavigationBar: const DashboardBottomNavigation(),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
            statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
          ),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                // Header Container matching Figma specs
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                    top: statusBarHeight > 0 ? statusBarHeight + 12 : 12,
                    right: 20,
                    bottom: 16,
                    left: 20,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.dashboardHeaderDark
                        : const Color(0xFFC7E3FF),
                  ),
                  child: Row(
                    children: [
                      // Back Button
                      InkWell(
                        onTap: () => _handleBackPress(context),
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Icon(
                            Icons.arrow_back,
                            color: headingColor,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Greeting Container (Title Pill)
                      Expanded(
                        child: Container(
                          height: 38,
                          padding: const EdgeInsets.only(left: 16, right: 12),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.borderDark
                                  : const Color(0xFFCCDFF2),
                              width: 1,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Advertisement Details',
                              style: TextStyle(
                                fontFamily: 'DM Sans',
                                color: isDark
                                    ? AppColors.noticesHeadingDark
                                    : const Color(0xFF000000),
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                height: 1.0,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                      top: 24,
                      right: 20,
                      bottom: 24,
                      left: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Cover Hero Image with Overlay Badge (hero-section: height 280px for Nikoo, radius 12px)
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(
                                height: _isNikoo ? 280 : 320,
                                width: double.infinity,
                                child: CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: isDark
                                        ? AppColors.noticesCardBorderDark
                                        : AppColors.noticesCardBorderLight,
                                  ),
                                  errorWidget: (context, url, err) => Container(
                                    color: const Color(0xFF0F172A),
                                    child: const Icon(Icons.apartment, size: 50, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SizedBox(
                                height: _isNikoo ? 280 : 320,
                                width: double.infinity,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withValues(alpha: .45),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (_isNikoo)
                              Positioned(
                                left: 24,
                                right: 24,
                                bottom: 20,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text Title (DM Sans/Inter 800 ExtraBold 28px height 1.0 #FFFFFF)
                                    const Text(
                                      'Nikoo Homes',
                                      style: TextStyle(
                                        fontFamily: 'DM Sans',
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w800,
                                        height: 1.0,
                                        letterSpacing: 0,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    // Text Subtitle (DM Sans/Inter 500 Medium 14px height 1.0 80% opacity #FFFFFF)
                                    Text(
                                      'by Bhartiya City',
                                      style: TextStyle(
                                        fontFamily: 'DM Sans',
                                        color: Colors.white.withValues(alpha: 0.8),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        height: 1.0,
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              Positioned(
                                left: 24,
                                right: 24,
                                bottom: 20,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // amenity-badge (padding 4/10/4/10, radius 4px, #EC9211)
                                    Container(
                                      padding: const EdgeInsets.only(
                                        top: 4,
                                        right: 10,
                                        bottom: 4,
                                        left: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEC9211),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        '30+ AMENITIES',
                                        style: TextStyle(
                                          fontFamily: 'DM Sans',
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 10,
                                          height: 1.0,
                                          letterSpacing: 0,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    const Text(
                                      'for everyday to find more',
                                      style: TextStyle(
                                        fontFamily: 'DM Sans',
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700,
                                        height: 28 / 22,
                                        letterSpacing: 0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),

                        // Project Title & Price Header Row (title-section: top 20px, bottom 16px, gap 8px)
                        if (!_isNikoo) ...[
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // main-title-row (space-between)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Text brand-title (DM Sans 800 ExtraBold 28px height 1.0 #05234D)
                                    Expanded(
                                      child: Text(
                                        title,
                                        style: TextStyle(
                                          fontFamily: 'DM Sans',
                                          fontSize: 28,
                                          fontWeight: FontWeight.w800,
                                          height: 1.0,
                                          letterSpacing: 0,
                                          color: isDark
                                              ? AppColors.noticesTitleTextDark
                                              : const Color(0xFF05234D),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // price-badge (radius 20px, border 1px #EC9211, padding 6/12/6/12, gap 6)
                                    Container(
                                      padding: const EdgeInsets.only(
                                        top: 6,
                                        right: 12,
                                        bottom: 6,
                                        left: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? AppColors.noticesAmberBgDark
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: isDark
                                              ? AppColors.noticesAmberBorderDark
                                              : const Color(0xFFEC9211),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.home_outlined,
                                            size: 14,
                                            color: isDark
                                                ? AppColors.noticesAccentAmberDark
                                                : const Color(0xFFEC9211),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            priceLabel,
                                            style: TextStyle(
                                              fontFamily: 'DM Sans',
                                              color: isDark
                                                  ? AppColors.noticesAccentAmberDark
                                                  : const Color(0xFFEC9211),
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 14,
                                      color: isDark
                                          ? AppColors.noticesSecondaryTextDark
                                          : const Color(0xFF3D3D3D),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        subtitle,
                                        style: TextStyle(
                                          fontFamily: 'DM Sans',
                                          fontSize: 12,
                                          color: isDark
                                              ? AppColors.noticesSecondaryTextDark
                                              : const Color(0xFF3D3D3D),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],

                        if (_isNikoo) _buildNikooContent(isDark) else _buildCenturyContent(isDark),

                        const SizedBox(height: 12),

                        // Bottom Action Buttons: Schedule a Visit & Download Brochure matching Figma
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ScheduleVisitScreen(
                                    projectName: title,
                                    subtitleInfo: 'Freespirited 2 & 3 Bed Homes | Starting at $priceLabel',
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark
                                  ? AppColors.noticesAccentBlueDark
                                  : const Color(0xFF0060BD),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Schedule a Visit',
                              style: TextStyle(
                                fontFamily: 'DM Sans',
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                height: 1.0,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Downloading brochure...')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark
                                  ? AppColors.noticesAccentAmberDark
                                  : const Color(0xFFEC9211),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.file_download_outlined, color: Colors.white, size: 14),
                                SizedBox(width: 6),
                                Text(
                                  'Download Brochure',
                                  style: TextStyle(
                                    fontFamily: 'DM Sans',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    height: 1.0,
                                    letterSpacing: 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCenturyContent(bool isDark) {
    final cardColor = isDark ? AppColors.surfaceDark : const Color(0xFFFFFFFF);
    final borderColor =
        isDark ? AppColors.noticesCardBorderDark : const Color(0xFFE2E8F0);
    final titleColor =
        isDark ? AppColors.noticesTitleTextDark : const Color(0xFF0F172A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card 1: Every Reason to Upgrade (upgrade-reasons-card: padding 20px, radius 16px, border 1px #E2E8F0, gap 14px)
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? .25 : .02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // card-header (space-between)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Text card-title (DM Sans 700 Bold 16px height 1.0 #0F172A)
                  Text(
                    'Every Reason to Upgrade',
                    style: TextStyle(
                      fontFamily: 'DM Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.0,
                      letterSpacing: 0,
                      color: titleColor,
                    ),
                  ),
                  // icon-sparkles (18px, #EC9211)
                  Icon(
                    Icons.auto_awesome,
                    color: isDark
                        ? AppColors.noticesAccentAmberDark
                        : const Color(0xFFEC9211),
                    size: 18,
                  ),
                ],
              ),
              const SizedBox(height: 14),

              _buildIconBulletItem(
                isDark,
                icon: Icons.location_on_outlined,
                text: '4.25-acre thoughtfully planned community',
              ),
              _buildIconBulletItem(
                isDark,
                icon: Icons.star_outline,
                text: '30+ curated lifestyle amenities',
              ),
              _buildIconBulletItem(
                isDark,
                icon: Icons.storefront_outlined,
                text: '27,000+ sq. ft. commercial space',
              ),
              _buildIconBulletItem(
                isDark,
                icon: Icons.layers_outlined,
                text: '26,000+ sq. ft. multi-level clubhouse',
              ),
              _buildIconBulletItem(
                isDark,
                icon: Icons.park_outlined,
                text: '75% landscaped open spaces',
              ),
              _buildIconBulletItem(
                isDark,
                icon: Icons.home_outlined,
                text: 'Freespirited 2 & 3 Bed Homes',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Card 2: Why Century Bliss? (why-card: padding 20px, radius 16px, border 1px #E2E8F0, gap 12px)
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? .25 : .02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text why-title (DM Sans 700 Bold 16px height 1.0 #0F172A)
              Text(
                'Why Century Bliss?',
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                  letterSpacing: 0,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 12),
              // Text why-paragraph (DM Sans 400 Regular 14px height 20/14 #3E3E3E)
              Text(
                'A thoughtfully planned community built around the way you truly want to live. Nestled on Yelahanka–Doddaballapura Main Road, Century Bliss offers freespirited 2 & 3 BHK homes with world-class amenities and lush green surroundings.',
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 20 / 14,
                  letterSpacing: 0,
                  color: isDark
                      ? AppColors.noticesBodyTextDark
                      : const Color(0xFF3E3E3E),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNikooContent(bool isDark) {
    final cardColor = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final borderColor =
        isDark ? AppColors.noticesCardBorderDark : AppColors.noticesCardBorderLight;
    final headingColor =
        isDark ? AppColors.noticesHeadingDark : AppColors.noticesHeadingLight;
    final bodyColor = isDark ? AppColors.noticesBodyTextDark : AppColors.noticesBodyTextLight;
    final dividerColor = isDark ? AppColors.noticesDividerDark : AppColors.noticesDividerLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        // 4 Stat grid items matching Figma AD 2
        Row(
          children: [
            Expanded(child: _buildStatItem(isDark, Icons.home_outlined, '6 Towers', 'Development')),
            const SizedBox(width: 8),
            Expanded(child: _buildStatItem(isDark, Icons.grid_view_rounded, '2B+G+24', 'Floors')),
            const SizedBox(width: 8),
            Expanded(child: _buildStatItem(isDark, Icons.map_outlined, '11.5 Acres', 'Total Area')),
            const SizedBox(width: 8),
            Expanded(
              child: _buildStatItem(isDark, Icons.people_outline_rounded, '1,000+', 'Apartments'),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Pricing details section (price-cta-container: height 80px, top & bottom border 1px #E5E7EB, gap 4px)
        Container(
          width: double.infinity,
          height: 80,
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: isDark ? AppColors.noticesCardBorderDark : const Color(0xFFE5E7EB),
                width: 1,
              ),
              bottom: BorderSide(
                color: isDark ? AppColors.noticesCardBorderDark : const Color(0xFFE5E7EB),
                width: 1,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text Section Title (DM Sans 600 SemiBold 12px height 1.0 Gray 1 #3E3E3E)
              Text(
                'PRICING DETAILS',
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1.0,
                  letterSpacing: 0.5,
                  color: isDark ? AppColors.noticesSecondaryTextDark : const Color(0xFF3E3E3E),
                ),
              ),
              const SizedBox(height: 4),
              // Text Section Value (₹93L in 26px 800 #05234D, Onwards in 16px 500 #05234D)
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '₹93L ',
                      style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        height: 1.0,
                        letterSpacing: 0,
                        color: isDark ? AppColors.noticesTitleTextDark : const Color(0xFF05234D),
                      ),
                    ),
                    TextSpan(
                      text: 'Onwards',
                      style: TextStyle(
                        fontFamily: 'DM Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.0,
                        letterSpacing: 0,
                        color: isDark ? AppColors.noticesTitleTextDark : const Color(0xFF05234D),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Project Highlights Header (DM Sans 600 SemiBold 18px height 1.0 #05234D + 6px gap + 36x3px Yellow 1 bar)
        _buildSectionHeader('Project Highlights', isDark),
        const SizedBox(height: 12),

        // 2x3 Grid of Project Highlights
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.38,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: const [
            _HighlightCard(icon: Icons.wb_sunny_outlined, title: 'Rooftop Pool', sub: 'Stunning city views'),
            _HighlightCard(icon: Icons.workspace_premium_outlined, title: 'Clubhouse', sub: '40,000 sq.ft luxury'),
            _HighlightCard(icon: Icons.menu_book_outlined, title: 'School & Retail', sub: 'Within the campus'),
            _HighlightCard(icon: Icons.favorite_border_outlined, title: 'Lush Greens', sub: 'Landscaped areas'),
            _HighlightCard(icon: Icons.location_on_outlined, title: 'Metro Access', sub: 'Phase 2B Line'),
            _HighlightCard(icon: Icons.work_outline_rounded, title: 'Manyata Tech', sub: 'Just 10 mins away'),
          ],
        ),
        const SizedBox(height: 12),

        // Location Advantages Header
        _buildSectionHeader('Location Advantages', isDark),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? .25 : .02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildAdvantageItem(isDark, '1 km from Bhartiya City Township'),
              Divider(height: 20, color: dividerColor),
              _buildAdvantageItem(isDark, 'Near Hebbal, Yelahanka & Airport Corridor'),
              Divider(height: 20, color: dividerColor),
              _buildAdvantageItem(isDark, 'Upcoming Metro — Phase 2B Airport Line'),
              Divider(height: 20, color: dividerColor),
              _buildAdvantageItem(isDark, '10 mins to Manyata Tech Park'),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // About This Project Header
        _buildSectionHeader('About This Project', isDark),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? .25 : .02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enjoy luxury living at Bhartiya – Nikoo Homes, Thanisandra (Nikoo 8)!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: headingColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Here\'s the biggest residential launch of the year. Live in a premium residential development near Bhartiya City, designed for luxury, convenience, and long-term value.',
                style: TextStyle(
                  fontSize: 12,
                  color: bodyColor,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            height: 1.0,
            letterSpacing: 0,
            color: isDark ? AppColors.noticesTitleTextDark : const Color(0xFF05234D),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 36,
          height: 3,
          decoration: BoxDecoration(
            color: const Color(0xFFEC9211),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildIconBulletItem(bool isDark, {required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // icon-container (32x32, radius 8px, #C5A880 at 10.98% opacity)
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.noticesAmberBgDark
                  : const Color(0xFFC5A880).withValues(alpha: 0.11),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                icon,
                color: isDark
                    ? AppColors.noticesAccentAmberDark
                    : const Color(0xFFEC9211),
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Text feature-text (DM Sans 500 Medium 14px height 1.0 #05234D)
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.0,
                letterSpacing: 0,
                color: isDark
                    ? AppColors.noticesBodyTextDark
                    : const Color(0xFF05234D),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(bool isDark, IconData icon, String main, String sub) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.noticesCardBorderDark : const Color(0xFFE5E7EB),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Frame icon container (32x32, 16px radius / circle, #FEF7E7 fill)
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isDark ? AppColors.noticesAmberBgDark : const Color(0xFFFEF7E7),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                icon,
                color: isDark ? AppColors.noticesAccentAmberDark : const Color(0xFFEC9211),
                size: 18,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            main,
            style: TextStyle(
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w700,
              fontSize: 14,
              height: 1.0,
              letterSpacing: 0,
              color: isDark ? AppColors.noticesHeadingDark : const Color(0xFF1A1A2E),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            style: TextStyle(
              fontFamily: 'DM Sans',
              color: isDark ? AppColors.noticesMutedDark : const Color(0xFF6B7280),
              fontSize: 11,
              fontWeight: FontWeight.w400,
              height: 1.0,
              letterSpacing: 0,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAdvantageItem(bool isDark, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isDark ? AppColors.noticesSuccessBgDark : AppColors.noticesSuccessBgLight,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.location_on,
            size: 14,
            color: isDark ? AppColors.noticesSuccessIconDark : AppColors.noticesSuccessIconLight,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.noticesBodyTextDark : AppColors.noticesBodyTextLight,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _HighlightCard extends StatelessWidget {
  const _HighlightCard({required this.icon, required this.title, required this.sub});
  final IconData icon;
  final String title;
  final String sub;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.noticesCardBorderDark : const Color(0xFFE5E7EB),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? .25 : .02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Frame icon container (40x40, 20px radius / circle, #F0F5FA fill)
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDark ? AppColors.noticesBlueTintBgDark : const Color(0xFFF0F5FA),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                icon,
                color: isDark ? AppColors.noticesAccentBlueDark : const Color(0xFF05234D),
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  height: 1.0,
                  letterSpacing: 0,
                  color: isDark ? AppColors.noticesHeadingDark : const Color(0xFF05234D),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                sub,
                style: TextStyle(
                  fontFamily: 'DM Sans',
                  color: isDark ? AppColors.noticesMutedDark : const Color(0xFF6B7280),
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  height: 1.0,
                  letterSpacing: 0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
