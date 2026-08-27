import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_nivasshub/constants/app_colors.dart';
import 'package:flutter_nivasshub/constants/app_icons.dart';
import 'package:flutter_nivasshub/utils/responsive.dart';
import 'package:flutter_nivasshub/models/shared/app_feature_model.dart';
import 'package:flutter_nivasshub/widgets/shared/feedback/custom_snackbar.dart';
import 'package:flutter_nivasshub/widgets/shared/inputs/app_search_bar.dart';
import 'package:flutter_nivasshub/widgets/shared/states/custom_error_widget.dart';
import 'package:flutter_nivasshub/widgets/shared/states/empty_state.dart';
import 'package:flutter_nivasshub/widgets/dashboard/navigation/dashboard_bottom_navigation.dart';
import 'package:flutter_nivasshub/models/quick_actions/quick_action_section_model.dart';
import 'package:flutter_nivasshub/providers/quick_actions/quick_actions_provider.dart';
import 'package:flutter_nivasshub/widgets/quick_actions/demo_notification_banner.dart';
import 'package:flutter_nivasshub/widgets/quick_actions/quick_action_card.dart';
import 'package:flutter_nivasshub/widgets/quick_actions/quick_actions_shimmer.dart';

class QuickActionsScreen extends StatefulWidget {
  const QuickActionsScreen({super.key});

  @override
  State<QuickActionsScreen> createState() =>
      _QuickActionsScreenState();
}

class _QuickActionsScreenState extends State<QuickActionsScreen> {
  static const String _iconsPath1 =
      'assets/icons/quick_actions';

  static const String _iconsPath2 =
      'assets/icons/quick_actions/homequick_actions';

  // ============================================================
  // FEED / HOUSEHOLD / SETTINGS
  // ============================================================

  // Slightly larger card width.
  static const double _kFourCardMinWidth = 52;

  // Increased gap between cards.
  static const double _kFourCardGap = 20;

  // Small side padding.
  static const double _kFourCardHorizontalPadding = 2;

  // Card height remains the same.
  static const double _kFourCardHeight = 66;

  // ============================================================
  // MARKETPLACE
  // ============================================================

  static const double _kMarketplaceHorizontalPadding = 0;

  static const double _kMarketplaceGap = 9;

  static const double _kMarketplaceCardHeight = 60;

  // ============================================================
  // SECTION SPACING
  // ============================================================

  static const double _kHeaderToCardGap = 7;

  static const double _kSectionGap = 16;

  // ============================================================
  // ICON SIZES
  // ============================================================

  static const double _kFeedIconSize = 22;

  static const double _kSquareIconSize = 22;

  static const double _kMarketplaceIconSize = 22;

  // ============================================================
  // CARD STYLE
  // ============================================================

  static const double _kCardRadius = 10;

  static const TextStyle _kCardLabelStyle = TextStyle(
    fontSize: 8.5,
    height: 1.15,
    fontWeight: FontWeight.w500,
    color: Color(0xFF374151),
  );

  static const TextStyle _kSectionActionStyle = TextStyle(
    fontSize: 9.5,
    height: 1.1,
    fontWeight: FontWeight.w600,
    color: Color(0xFF2563EB),
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final provider =
          context.read<QuickActionsProvider>();

      provider.clearSearch();
      provider.loadQuickActions();
    });
  }

  // ============================================================
  // ACTION HANDLING
  // ============================================================

  void _handleTap(AppFeatureModel item) {
    if (item.id == 'test_notifications') {
      DemoNotificationBanner.show(context);
    } else if (item.routeName != null) {
      Navigator.pushNamed(
        context,
        item.routeName!,
      );
    } else {
      CustomSnackbar.info(
        context,
        '${item.title} coming soon.',
      );
    }
  }

  void _handleSectionAction(String sectionTitle) {
    CustomSnackbar.info(
      context,
      '$sectionTitle coming soon.',
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.infoDark : AppColors.infoLight,

      appBar: AppBar(
        backgroundColor:
            isDark ? AppColors.infoDark : AppColors.infoLight,
        elevation: 0,
        leading: IconButton(
          icon: Icon(AppIcons.close),
          onPressed: () =>
              Navigator.of(context).pop(),
        ),
        title: const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),

      bottomNavigationBar:
          const DashboardBottomNavigation(),

      body: SafeArea(
        child: Consumer<QuickActionsProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const QuickActionsShimmer();
            }

            if (provider.hasError) {
              return CustomErrorWidget(
                message: provider.errorMessage ??
                    'Something went wrong. Please try again.',
                onRetry: provider.retry,
              );
            }

            if (provider.isEmpty) {
              return const EmptyState(
                title: 'No quick actions available',
                message:
                    'Quick actions will appear here once available.',
              );
            }

            return _buildBody(provider);
          },
        ),
      ),
    );
  }

  // ============================================================
  // MAIN BODY
  // ============================================================

  Widget _buildBody(
    QuickActionsProvider provider,
  ) {
    final filtered =
        provider.filteredSections;

    if (provider.isSearching &&
        filtered.isEmpty) {
      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal:
              Responsive.horizontalPadding(context),
          vertical: 8,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            _buildSearchBar(provider),
            const SizedBox(height: 16),
            const EmptyState(
              title:
                  'No matching quick action found',
              message:
                  'Try a different search term.',
            ),
          ],
        ),
      );
    }

    final shortcuts =
        filtered.firstWhere(
      (section) => section.id == 'shortcuts',
      orElse: () =>
          const QuickActionSectionModel(
        id: 'shortcuts',
        items: [],
      ),
    );

    return SingleChildScrollView(
      physics:
          const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal:
            Responsive.horizontalPadding(context),
        vertical: 6,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _buildSearchBar(provider),

          if (shortcuts.items.isNotEmpty) ...[
            const SizedBox(height: 12),

            Row(
              children:
                  shortcuts.items.map((item) {
                return Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 3,
                    ),
                    child: QuickActionCard(
                      item: item,
                      onTap: () =>
                          _handleTap(item),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],

          const SizedBox(
            height: _kSectionGap,
          ),

          _buildFeedSection(),

          const SizedBox(
            height: _kSectionGap,
          ),

          _buildMarketplaceSection(),

          const SizedBox(
            height: _kSectionGap,
          ),

          _buildHouseholdSection(),

          const SizedBox(
            height: _kSectionGap,
          ),

          _buildSettingsSection(),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ============================================================
  // SEARCH BAR
  // ============================================================

  Widget _buildSearchBar(
    QuickActionsProvider provider,
  ) {
    return AppSearchBar(
      hint: 'Search all features',
      onChanged:
          provider.setSearchQuery,
    );
  }

  // ============================================================
  // SECTION HEADER
  // ============================================================

  Widget _buildSectionHeader({
    required String title,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style:
              Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(
                    fontWeight:
                        FontWeight.w600,
                    fontSize: 11,
                    color:
                        const Color(
                      0xFF374151,
                    ),
                  ),
        ),
        TextButton(
          onPressed: onAction,
          style:
              TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize:
                MaterialTapTargetSize
                    .shrinkWrap,
          ),
          child: Text(
            actionLabel,
            style:
                _kSectionActionStyle,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // CARD SHELL
  // ============================================================

  Widget _buildCardShell({
    required Widget child,
    required double height,
    EdgeInsets padding =
        EdgeInsets.zero,
  }) {
    return Container(
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          _kCardRadius,
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.06,
            ),
            blurRadius: 4,
            offset:
                const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  // ============================================================
  // FEED / HOUSEHOLD / SETTINGS
  //
  // Slightly wider cards + increased gap.
  // Width is calculated from available screen width so it
  // remains responsive and does not overflow.
  // ============================================================

  Widget _buildFourCardRow(
    List<Widget> items,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal:
            _kFourCardHorizontalPadding,
      ),
      child: LayoutBuilder(
        builder:
            (context, constraints) {
          final availableWidth =
              constraints.maxWidth;

          final totalGap =
              _kFourCardGap *
                  (items.length - 1);

          final calculatedWidth =
              (availableWidth -
                      totalGap) /
                  items.length;

          final cardWidth =
              calculatedWidth <
                      _kFourCardMinWidth
                  ? calculatedWidth
                  : calculatedWidth;

          return Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children:
                List.generate(
              items.length,
              (index) {
                return Padding(
                  padding:
                      EdgeInsets.only(
                    right:
                        index ==
                                items.length - 1
                            ? 0
                            : _kFourCardGap,
                  ),
                  child: SizedBox(
                    width:
                        cardWidth,
                    child:
                        items[index],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // MARKETPLACE
  // Three wider cards.
  // ============================================================

  Widget _buildMarketplaceRow(
    List<Widget> items,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal:
            _kMarketplaceHorizontalPadding,
      ),
      child: LayoutBuilder(
        builder:
            (context, constraints) {
          final totalGap =
              _kMarketplaceGap *
                  (items.length - 1);

          final cardWidth =
              (constraints.maxWidth -
                      totalGap) /
                  items.length;

          return Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children:
                List.generate(
              items.length,
              (index) {
                return Padding(
                  padding:
                      EdgeInsets.only(
                    right:
                        index ==
                                items.length - 1
                            ? 0
                            : _kMarketplaceGap,
                  ),
                  child: SizedBox(
                    width:
                        cardWidth,
                    child:
                        items[index],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // FEED
  // ============================================================

  Widget _buildFeedSection() {
    final feedItems = const [
      _FeatureItem(
        title: 'Create Post',
        id: 'create_post',
        imageName:
            'create_post.png',
      ),
      _FeatureItem(
        title: 'Create Poll',
        id: 'create_poll',
        imageName:
            'create_poll.png',
      ),
      _FeatureItem(
        title: 'Host an Event',
        id: 'host_an_event',
        imageName:
            'host_an_event.png',
      ),
      _FeatureItem(
        title: 'My Posts',
        id: 'my_posts',
        imageName:
            'my_posts.png',
      ),
    ];

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: 'Feed',
          actionLabel:
              'View all posts >',
          onAction: () =>
              _handleSectionAction(
            'View all posts',
          ),
        ),
        const SizedBox(
          height:
              _kHeaderToCardGap,
        ),
        _buildFourCardRow(
          feedItems
              .map(_buildFeedCard)
              .toList(),
        ),
      ],
    );
  }

  Widget _buildFeedCard(
    _FeatureItem feature,
  ) {
    final item = AppFeatureModel(
      id: feature.id,
      title: feature.title,
      iconKey: feature.id,
    );

    return GestureDetector(
      onTap: () =>
          _handleTap(item),
      child: Column(
        mainAxisSize:
            MainAxisSize.min,
        children: [
          _buildCardShell(
            height:
                _kFourCardHeight,
            padding:
                const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 5,
            ),
            child: Center(
              child: _buildIcon(
                feature.imageName,
                _kFeedIconSize,
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 22,
            child: Center(
              child: Text(
                feature.title,
                maxLines: 2,
                textAlign:
                    TextAlign.center,
                overflow:
                    TextOverflow.ellipsis,
                style:
                    _kCardLabelStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MARKETPLACE
  // ============================================================

  Widget _buildMarketplaceSection() {
    final marketplaceItems =
        const [
      _FeatureItem(
        title: 'Find Homes',
        id: 'find_homes',
        imageName:
            'find_homes.png',
      ),
      _FeatureItem(
        title: 'My Listings',
        id: 'my_listing',
        imageName:
            'my_listing.png',
      ),
      _FeatureItem(
        title: 'Create a listing',
        id: 'create_a_listing',
        imageName:
            'create_a_listing.png',
      ),
    ];

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: 'Marketplace',
          actionLabel: 'Explore >',
          onAction: () =>
              _handleSectionAction(
            'Explore',
          ),
        ),
        const SizedBox(
          height:
              _kHeaderToCardGap,
        ),
        _buildMarketplaceRow(
          marketplaceItems
              .map(
                _buildMarketplaceCard,
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildMarketplaceCard(
    _FeatureItem feature,
  ) {
    final item = AppFeatureModel(
      id: feature.id,
      title: feature.title,
      iconKey: feature.id,
    );

    return GestureDetector(
      onTap: () =>
          _handleTap(item),
      child: _buildCardShell(
        height:
            _kMarketplaceCardHeight,
        padding:
            const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 6,
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            _buildIcon(
              feature.imageName,
              _kMarketplaceIconSize,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              feature.title,
              maxLines: 1,
              textAlign:
                  TextAlign.center,
              overflow:
                  TextOverflow.ellipsis,
              style:
                  _kCardLabelStyle,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HOUSEHOLD
  // ============================================================

  Widget _buildHouseholdSection() {
    final householdItems =
        const [
      _FeatureItem(
        title: 'My Family',
        id: 'my_family',
        imageName:
            'My_Family.png',
      ),
      _FeatureItem(
        title: 'My Daily Help',
        id: 'my_daily_help',
        imageName:
            'My_Daily_Help.png',
      ),
      _FeatureItem(
        title: 'Home Planner',
        id: 'home_planner',
        imageName:
            'Home_Planner.png',
      ),
      _FeatureItem(
        title: 'My Vehicles',
        id: 'my_vehicles',
        imageName:
            'My_Vehicles.png',
      ),
    ];

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: 'Household',
          actionLabel: 'Manage >',
          onAction: () =>
              _handleSectionAction(
            'Manage',
          ),
        ),
        const SizedBox(
          height:
              _kHeaderToCardGap,
        ),
        _buildFourCardRow(
          householdItems
              .map(
                _buildSquareCardWithText,
              )
              .toList(),
        ),
      ],
    );
  }

  // ============================================================
  // SETTINGS
  // ============================================================

  Widget _buildSettingsSection() {
    final settingsItems =
        const [
      _FeatureItem(
        title: 'Test Notifications',
        id: 'test_notifications',
        imageName:
            'text_notifications.png',
      ),
      _FeatureItem(
        title: 'My Flat',
        id: 'my_flat',
        imageName:
            'my_flat.png',
      ),
      _FeatureItem(
        title: 'My Plans',
        id: 'my_plans',
        imageName:
            'my_plans.png',
      ),
      _FeatureItem(
        title: 'Help & Support',
        id: 'help_support',
        imageName:
            'Help&support.png',
      ),
    ];

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: 'Settings',
          actionLabel:
              'View all >',
          onAction: () =>
              _handleSectionAction(
            'View all',
          ),
        ),
        const SizedBox(
          height:
              _kHeaderToCardGap,
        ),
        _buildFourCardRow(
          settingsItems
              .map(
                _buildSquareCardWithText,
              )
              .toList(),
        ),
      ],
    );
  }

  // ============================================================
  // HOUSEHOLD + SETTINGS CARD
  // ============================================================

  Widget _buildSquareCardWithText(
    _FeatureItem feature,
  ) {
    final item = AppFeatureModel(
      id: feature.id,
      title: feature.title,
      iconKey: feature.id,
    );

    return GestureDetector(
      onTap: () =>
          _handleTap(item),
      child: _buildCardShell(
        height:
            _kFourCardHeight,
        padding:
            const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 5,
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            _buildIcon(
              feature.imageName,
              _kSquareIconSize,
            ),
            const SizedBox(
              height: 5,
            ),
            Flexible(
              child: Text(
                feature.title,
                maxLines: 2,
                textAlign:
                    TextAlign.center,
                overflow:
                    TextOverflow.ellipsis,
                style:
                    _kCardLabelStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ICON
  // ============================================================

  Widget _buildIcon(
    String imageName,
    double size,
  ) {
    return Image.asset(
      '$_iconsPath1/$imageName',
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality:
          FilterQuality.high,
      errorBuilder:
          (context, error, stackTrace) {
        return Image.asset(
          '$_iconsPath2/$imageName',
          width: size,
          height: size,
          fit: BoxFit.contain,
          filterQuality:
              FilterQuality.high,
          errorBuilder:
              (context, error, stackTrace) {
            return Icon(
              Icons
                  .image_not_supported_outlined,
              size: size,
              color: Colors.grey,
            );
          },
        );
      },
    );
  }
}

// ============================================================
// FEATURE ITEM MODEL
// ============================================================

class _FeatureItem {
  final String title;
  final String id;
  final String imageName;

  const _FeatureItem({
    required this.title,
    required this.id,
    required this.imageName,
  });
}