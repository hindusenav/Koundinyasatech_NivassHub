import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/network/api_client.dart';
import '../../dashboard/presentation/widgets/navigation/dashboard_bottom_navigation.dart';
import 'notices_screen.dart';
import 'schedule_visit_screen.dart';

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
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: const Color(0xFFE0F2FE),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
            onPressed: () => _handleBackPress(context),
          ),
          title: const Text(
            'Advertisement Details',
            style: TextStyle(
              color: Color(0xFF0F172A),
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
              // Top Cover Hero Image with Overlay Badge
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
                        placeholder: (context, url) => Container(color: const Color(0xFFE2E8F0)),
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
                              color: const Color(0xFFD97706),
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
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 14,
                                color: Color(0xFF64748B),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  subtitle,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    color: Color(0xFF64748B),
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
                        color: const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.home_outlined,
                            size: 14,
                            color: Color(0xFFD97706),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            priceLabel,
                            style: const TextStyle(
                              color: Color(0xFFD97706),
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

              if (_isNikoo) _buildNikooContent() else _buildCenturyContent(),

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
                    backgroundColor: const Color(0xFF0284C7),
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
                    backgroundColor: const Color(0xFFD97706),
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

  Widget _buildCenturyContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Card 1: Every Reason to Upgrade
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .02),
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
                children: const [
                  Text(
                    'Every Reason to Upgrade',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  Icon(
                    Icons.auto_awesome,
                    color: Color(0xFFD97706),
                    size: 18,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              const SizedBox(height: 14),

              _buildIconBulletItem(
                icon: Icons.location_on_outlined,
                text: '4.25-acre thoughtfully planned community',
              ),
              const SizedBox(height: 10),
              _buildIconBulletItem(
                icon: Icons.star_outline,
                text: '30+ curated lifestyle amenities',
              ),
              const SizedBox(height: 10),
              _buildIconBulletItem(
                icon: Icons.storefront_outlined,
                text: '27,000+ sq. ft. commercial space',
              ),
              const SizedBox(height: 10),
              _buildIconBulletItem(
                icon: Icons.sports_basketball_outlined,
                text: '26,000+ sq. ft. multi-level clubhouse',
              ),
              const SizedBox(height: 10),
              _buildIconBulletItem(
                icon: Icons.park_outlined,
                text: '75% landscaped open spaces',
              ),
              const SizedBox(height: 10),
              _buildIconBulletItem(
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Why Century Bliss?',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 10),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              const SizedBox(height: 12),
              Text(
                'A thoughtfully planned community built around the way you truly want to live. Nestled on Yelahanka–Doddaballapura Main Road, Century Bliss offers freespirited 2 & 3 BHK homes with world-class amenities and lush green surroundings.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNikooContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 4 Stat grid items matching Figma AD 2
        Row(
          children: [
            Expanded(child: _buildStatItem(Icons.home_outlined, '6 Towers', 'Development')),
            const SizedBox(width: 8),
            Expanded(child: _buildStatItem(Icons.grid_view_rounded, '2B+G+34', 'Floors')),
            const SizedBox(width: 8),
            Expanded(child: _buildStatItem(Icons.map_outlined, '11.5 Acres', 'Total Area')),
            const SizedBox(width: 8),
            Expanded(child: _buildStatItem(Icons.people_outline_rounded, '1,000+', 'Apartments')),
          ],
        ),
        const SizedBox(height: 20),

        // Pricing details section
        const Text(
          'PRICING DETAILS',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Color(0xFF64748B),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: '₹93L ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF0F172A),
                ),
              ),
              TextSpan(
                text: 'Onwards',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Project Highlights Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Project Highlights',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
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
        const Text(
          'Location Advantages',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildAdvantageItem('1 km from Bhartiya City Township'),
              const Divider(height: 20, color: Color(0xFFF1F5F9)),
              _buildAdvantageItem('Near Hebbal, Yelahanka & Airport Corridor'),
              const Divider(height: 20, color: Color(0xFFF1F5F9)),
              _buildAdvantageItem('Upcoming Metro — Phase 2B Airport Line'),
              const Divider(height: 20, color: Color(0xFFF1F5F9)),
              _buildAdvantageItem('10 mins to Manyata Tech Park'),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // About This Project
        const Text(
          'About This Project',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: .02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Enjoy luxury living at Bhartiya – Nikoo Homes, Thanisandra (Nikoo 6)!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Here\'s the biggest residential launch of the year. Live in a premium residential development near Bhartiya City, designed for luxury, convenience, and long-term value.',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF475569),
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconBulletItem({required IconData icon, required String text}) {
    return Row(
      children: [
        Container(
          height: 28,
          width: 28,
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFFDE68A)),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFD97706),
            size: 15,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF334155),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String main, String sub) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Color(0xFFFFFBEB),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFFD97706), size: 16),
          ),
          const SizedBox(height: 6),
          Text(
            main,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 1),
          Text(
            sub,
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 9.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvantageItem(String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: Color(0xFFD1FAE5),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.location_on, size: 14, color: Color(0xFF059669)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF334155),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Color(0xFFEFF6FF),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF0284C7), size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11.5,
                    color: Color(0xFF0F172A),
                  ),
                ),
                Text(
                  sub,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
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
