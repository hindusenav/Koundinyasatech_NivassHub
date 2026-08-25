import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
        appBar: AppBar(
          backgroundColor:
              isDark ? AppColors.noticesAppBarDark : AppColors.noticesAppBarLight,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: headingColor),
            onPressed: () => _handleBackPress(context),
          ),
          title: Text(
            'Advertisement Details',
            style: TextStyle(
              color: headingColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        bottomNavigationBar: const DashboardBottomNavigation(),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Cover Hero Image with Overlay Badge — the photo, its
              // legibility scrim, and any text/badges painted directly on top
              // of it are intentionally theme-independent (a photo does not
              // change with app theme).
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 200,
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
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: .65),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (_isNikoo)
                    const Positioned(
                      left: 16,
                      bottom: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nikoo Homes',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'by Bhartiya City',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Positioned(
                      left: 16,
                      bottom: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.noticesAccentAmberLight,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              '20+ AMENITIES',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'for everyday to find more',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Project Title & Price Header Row (for Century Bliss)
              if (!_isNikoo) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.noticesTitleTextDark
                                  : AppColors.noticesTitleTextLight,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 14,
                                color: isDark
                                    ? AppColors.noticesSecondaryTextDark
                                    : AppColors.noticesSecondaryTextLight,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  subtitle,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: isDark
                                        ? AppColors.noticesSecondaryTextDark
                                        : AppColors.noticesSecondaryTextLight,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.noticesAmberBgDark : AppColors.noticesAmberBgLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? AppColors.noticesAmberBorderDark
                              : AppColors.noticesAmberBorderLight,
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
                                : AppColors.noticesAccentAmberLight,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            priceLabel,
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.noticesAccentAmberDark
                                  : AppColors.noticesAccentAmberLight,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              if (_isNikoo) _buildNikooContent(isDark) else _buildCenturyContent(isDark),

              const SizedBox(height: 20),

              // Bottom Action Buttons: Schedule a Visit & Download Brochure
              SizedBox(
                width: double.infinity,
                height: 46,
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
                        : AppColors.noticesAccentBlueLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Schedule a Visit',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Downloading brochure...')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? AppColors.noticesAccentAmberDark
                        : AppColors.noticesAccentAmberLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.download, color: Colors.white, size: 18),
                  label: const Text(
                    'Download Brochure',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenturyContent(bool isDark) {
    final cardColor = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final borderColor =
        isDark ? AppColors.noticesCardBorderDark : AppColors.noticesCardBorderLight;
    final titleColor =
        isDark ? AppColors.noticesTitleTextDark : AppColors.noticesTitleTextLight;
    final dividerColor = isDark ? AppColors.noticesDividerDark : AppColors.noticesDividerLight;
    final bodyColor = isDark ? AppColors.noticesBodyTextDark : AppColors.noticesBodyTextLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card 1: Every Reason to Upgrade
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Every Reason to Upgrade',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    ),
                  ),
                  Icon(
                    Icons.auto_awesome,
                    color: isDark
                        ? AppColors.noticesAccentAmberDark
                        : AppColors.noticesAccentAmberLight,
                    size: 18,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Divider(height: 1, color: dividerColor),
              const SizedBox(height: 14),

              _buildIconBulletItem(
                isDark,
                icon: Icons.location_on_outlined,
                text: '4.25-acre thoughtfully planned community',
              ),
              const SizedBox(height: 10),
              _buildIconBulletItem(
                isDark,
                icon: Icons.star_outline,
                text: '30+ curated lifestyle amenities',
              ),
              const SizedBox(height: 10),
              _buildIconBulletItem(
                isDark,
                icon: Icons.storefront_outlined,
                text: '27,000+ sq. ft. commercial space',
              ),
              const SizedBox(height: 10),
              _buildIconBulletItem(
                isDark,
                icon: Icons.sports_basketball_outlined,
                text: '26,000+ sq. ft. multi-level clubhouse',
              ),
              const SizedBox(height: 10),
              _buildIconBulletItem(
                isDark,
                icon: Icons.park_outlined,
                text: '75% landscaped open spaces',
              ),
              const SizedBox(height: 10),
              _buildIconBulletItem(
                isDark,
                icon: Icons.home_outlined,
                text: 'Freespirited 2 & 3 Bed Homes',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Card 2: Why Century Bliss?
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
                'Why Century Bliss?',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 10),
              Divider(height: 1, color: dividerColor),
              const SizedBox(height: 12),
              Text(
                'A thoughtfully planned community built around the way you truly want to live. Nestled on Yelahanka–Doddaballapura Main Road, Century Bliss offers freespirited 2 & 3 BHK homes with world-class amenities and lush green surroundings.',
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

  Widget _buildNikooContent(bool isDark) {
    final cardColor = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final borderColor =
        isDark ? AppColors.noticesCardBorderDark : AppColors.noticesCardBorderLight;
    final headingColor =
        isDark ? AppColors.noticesHeadingDark : AppColors.noticesHeadingLight;
    final secondaryColor =
        isDark ? AppColors.noticesSecondaryTextDark : AppColors.noticesSecondaryTextLight;
    final bodyColor = isDark ? AppColors.noticesBodyTextDark : AppColors.noticesBodyTextLight;
    final dividerColor = isDark ? AppColors.noticesDividerDark : AppColors.noticesDividerLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 4 Stat grid items matching Figma AD 2
        Row(
          children: [
            Expanded(child: _buildStatItem(isDark, Icons.home_outlined, '6 Towers', 'Development')),
            const SizedBox(width: 8),
            Expanded(child: _buildStatItem(isDark, Icons.grid_view_rounded, '2B+G+34', 'Floors')),
            const SizedBox(width: 8),
            Expanded(child: _buildStatItem(isDark, Icons.map_outlined, '11.5 Acres', 'Total Area')),
            const SizedBox(width: 8),
            Expanded(
              child: _buildStatItem(isDark, Icons.people_outline_rounded, '1,000+', 'Apartments'),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Pricing details section
        Text(
          'PRICING DETAILS',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: secondaryColor,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '₹93L ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: headingColor,
                ),
              ),
              TextSpan(
                text: 'Onwards',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: secondaryColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Project Highlights Header
        Text(
          'Project Highlights',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: headingColor,
          ),
        ),
        const SizedBox(height: 12),

        // 2x3 Grid of Project Highlights
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: const [
            _HighlightCard(icon: Icons.wb_sunny_outlined, title: 'Rooftop Pool', sub: 'Stunning city views'),
            _HighlightCard(icon: Icons.workspace_premium_outlined, title: 'Clubhouse', sub: '40,000 sq.ft luxury'),
            _HighlightCard(icon: Icons.menu_book_outlined, title: 'School & Retail', sub: 'Within the campus'),
            _HighlightCard(icon: Icons.favorite_border_outlined, title: 'Lush Greens', sub: 'Landscaped areas'),
            _HighlightCard(icon: Icons.location_on_outlined, title: 'Metro Access', sub: 'Phase 2B Line'),
            _HighlightCard(icon: Icons.work_outline_rounded, title: 'Manyata Tech', sub: 'Just 10 mins away'),
          ],
        ),
        const SizedBox(height: 20),

        // Location Advantages
        Text(
          'Location Advantages',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: headingColor,
          ),
        ),
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
        const SizedBox(height: 20),

        // About This Project
        Text(
          'About This Project',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: headingColor,
          ),
        ),
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
                'Enjoy luxury living at Bhartiya – Nikoo Homes, Thanisandra (Nikoo 6)!',
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

  Widget _buildIconBulletItem(bool isDark, {required IconData icon, required String text}) {
    return Row(
      children: [
        Container(
          height: 28,
          width: 28,
          decoration: BoxDecoration(
            color: isDark ? AppColors.noticesAmberBgDark : AppColors.noticesAmberBgLight,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isDark ? AppColors.noticesAmberBorderDark : AppColors.noticesAmberBorderLight,
            ),
          ),
          child: Icon(
            icon,
            color: isDark ? AppColors.noticesAccentAmberDark : AppColors.noticesAccentAmberLight,
            size: 15,
          ),
        ),
        const SizedBox(width: 10),
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

  Widget _buildStatItem(bool isDark, IconData icon, String main, String sub) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.noticesCardBorderDark : AppColors.noticesCardBorderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? .25 : .02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isDark ? AppColors.noticesAmberBgDark : AppColors.noticesAmberBgLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isDark ? AppColors.noticesAccentAmberDark : AppColors.noticesAccentAmberLight,
              size: 16,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            main,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
              color: isDark ? AppColors.noticesHeadingDark : AppColors.noticesHeadingLight,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            sub,
            style: TextStyle(
              color: isDark ? AppColors.noticesMutedDark : AppColors.noticesMutedLight,
              fontSize: 9.5,
            ),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.noticesCardBorderDark : AppColors.noticesCardBorderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? .25 : .02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isDark ? AppColors.noticesBlueTintBgDark : AppColors.noticesBlueTintBgLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isDark ? AppColors.noticesAccentBlueDark : AppColors.noticesAccentBlueLight,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11.5,
                    color: isDark ? AppColors.noticesHeadingDark : AppColors.noticesHeadingLight,
                  ),
                ),
                Text(
                  sub,
                  style: TextStyle(
                    color: isDark ? AppColors.noticesMutedDark : AppColors.noticesMutedLight,
                    fontSize: 9.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
