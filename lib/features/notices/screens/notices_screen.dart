import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/network/api_client.dart';

import '../provider/notices_provider.dart';
import '../widgets/empty_widget.dart';
import '../widgets/error_widget.dart';
import '../widgets/feed_list.dart';
import '../widgets/loading_widget.dart';
import '../widgets/section_header.dart';

class NoticesScreen extends StatelessWidget {
  const NoticesScreen({super.key, required this.apiClient});

  final ApiClient apiClient;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NoticesProvider(apiClient: apiClient)..loadFeed(),
      child: const _NoticesView(),
    );
  }
}

class _NoticesView extends StatefulWidget {
  const _NoticesView();

  @override
  State<_NoticesView> createState() => _NoticesViewState();
}

class _NoticesViewState extends State<_NoticesView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final provider = context.read<NoticesProvider>();

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      provider.loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoticesProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: AppColors.background,

          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: const Text(AppStrings.communityFeed),
          ),

          body: SafeArea(
            child: Builder(
              builder: (_) {
                //------------------------------------------------------
                // Loading
                //------------------------------------------------------

                if (provider.isLoading) {
                  return const LoadingWidget();
                }

                //------------------------------------------------------
                // Error
                //------------------------------------------------------

                if (provider.hasError) {
                  return ErrorStateWidget(
                    message:
                        provider.errorMessage ?? AppStrings.somethingWentWrong,
                    onRetry: provider.retry,
                  );
                }

                //------------------------------------------------------
                // Empty
                //------------------------------------------------------

                if (provider.isEmpty) {
                  return EmptyWidget(
                    title: AppStrings.noData,
                    message:
                        "Community posts, notices and advertisements will appear here.",
                    buttonText: AppStrings.retry,
                    onPressed: provider.refreshFeed,
                  );
                }

                //------------------------------------------------------
                // Success
                //------------------------------------------------------

                return RefreshIndicator(
                  onRefresh: provider.refreshFeed,
                  child: ListView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(AppDimensions.padding16),
                    children: [
                      const SectionHeader(
                        title: AppStrings.communityFeed,
                        subtitle: "Latest updates from your society",
                        leadingIcon: Icons.groups,
                      ),

                      const SizedBox(height: AppDimensions.padding16),

                      FeedList(
                        feedItems: provider.feedItems,
                        isLoadingMore: provider.isLoadingMore,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
