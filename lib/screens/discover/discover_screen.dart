import 'package:flutter/material.dart';
import '../../app/app_theme.dart';
import '../../data/demo_opportunities.dart';
import '../../models/opportunity.dart';
import '../../state/app_state.dart';
import '../../widgets/category_chip.dart';
import '../../widgets/opportunity_card.dart';
import '../../widgets/section_header.dart';
import '../opportunity_detail/opportunity_detail_screen.dart';
import '../preferences/preferences_screen.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<String> get _categories => ['All', ...DemoData.causesList];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final query = AppState.of(context).searchQuery;
    if (_searchController.text != query) {
      _searchController.text = query;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final filtered = appState.filteredOpportunities;
    final featured = appState.featuredOpportunity;
    final selectedFilter = appState.selectedCauseFilter ?? 'All';

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopBar(context, appState),
                    const SizedBox(height: 16),
                    _buildSearchBar(appState),
                    const SizedBox(height: 14),
                    _buildCategoryRow(appState, selectedFilter),
                    const SizedBox(height: 18),
                    if (featured != null && selectedFilter == 'All' && appState.searchQuery.trim().isEmpty) ...[
                      _buildFeaturedSection(context, appState, featured),
                      const SizedBox(height: 20),
                    ],
                    SectionHeader(
                      title: selectedFilter == 'All' ? 'Upcoming Opportunities' : '$selectedFilter Opportunities',
                      subtitle: appState.searchQuery.trim().isNotEmpty
                          ? 'Search results for "${appState.searchQuery.trim()}"'
                          : 'Short-term local community activities',
                      badgeText: '${filtered.length}',
                    ),
                  ],
                ),
              ),
            ),
            if (filtered.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _buildEmptyState(appState),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final opp = filtered[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: OpportunityCard(
                          opportunity: opp,
                          isSaved: appState.isSaved(opp.id),
                          isJoined: appState.isJoined(opp.id),
                          onTap: () => _openDetail(context, opp),
                          onSaveToggle: () => appState.toggleSave(opp.id),
                        ),
                      );
                    },
                    childCount: filtered.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _openDetail(BuildContext context, Opportunity opp) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OpportunityDetailScreen(opportunityId: opp.id),
      ),
    );
  }
  Widget _buildTopBar(BuildContext context, AppState appState) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: Icon(Icons.hub_outlined, color: AppTheme.accent, size: 20),
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'VolunteerConnect',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                'Metro Central • Demo Area',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.tune_rounded, color: AppTheme.primary),
          tooltip: 'Preferences & Filters',
          style: IconButton.styleFrom(
            backgroundColor: AppTheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: AppTheme.border),
            ),
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PreferencesScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar(AppState appState) {
    return TextField(
      controller: _searchController,
      onChanged: (val) => appState.setSearchQuery(val),
      decoration: InputDecoration(
        hintText: 'Search causes, tasks, organizations...',
        prefixIcon: const Icon(Icons.search, size: 20),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () {
                  _searchController.clear();
                  appState.setSearchQuery('');
                  setState(() {});
                },
              )
            : null,
      ),
    );
  }

  Widget _buildCategoryRow(AppState appState, String selectedFilter) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final cat = _categories[i];
          final isAll = cat == 'All';
          final isSelected = isAll
              ? (appState.selectedCauseFilter == null || appState.selectedCauseFilter == 'All')
              : (selectedFilter.toLowerCase() == cat.toLowerCase());
          return CategoryChip(
            label: cat,
            isSelected: isSelected,
            onTap: () {
              if (isAll || isSelected) {
                appState.setCauseFilter(null);
              } else {
                appState.setCauseFilter(cat);
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildFeaturedSection(BuildContext context, AppState appState, Opportunity opp) {
    final isSaved = appState.isSaved(opp.id);
    final isJoined = appState.isJoined(opp.id);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.accent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'FEATURED',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: AppTheme.primaryDark,
                  ),
                ),
              ),
              const Spacer(),
              if (isJoined) ...[
                const Text(
                  'Joined ✓',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.accent,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                opp.isFull
                    ? 'Capacity Full'
                    : '${opp.spotsRemaining} spots left',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            opp.title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${opp.organization} • ${opp.dateLabel}',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: Color(0xFFC7D7CE),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            opp.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              height: 1.4,
              color: Color(0xFFE2EDE7),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              ElevatedButton(
                onPressed: () => _openDetail(context, opp),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  foregroundColor: AppTheme.primaryDark,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                child: Text(isJoined ? 'View Joined Activity' : 'View Opportunity'),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: isSaved ? 'Remove bookmark' : 'Bookmark opportunity',
                icon: Icon(
                  isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: Colors.white,
                ),
                onPressed: () => appState.toggleSave(opp.id),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppState appState) {
    final hasSearch = appState.searchQuery.trim().isNotEmpty;
    final hasCategory = appState.selectedCauseFilter != null &&
        appState.selectedCauseFilter != 'All';
    final totalOpportunities = appState.opportunities.length;

    if (totalOpportunities == 0) {
      return _buildZeroOpportunitiesState();
    }
    if (hasSearch && hasCategory) {
      return _buildSearchAndCategoryEmptyState(appState);
    }
    if (hasSearch) {
      return _buildSearchOnlyEmptyState(appState);
    }
    return _buildCategoryOnlyEmptyState(appState);
  }

  Widget _buildZeroOpportunitiesState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.event_busy_outlined,
                size: 32,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No Opportunities Available',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'There are currently no volunteer opportunities listed. Please check back later.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndCategoryEmptyState(AppState appState) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTheme.surfaceMuted,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.filter_list_off_outlined,
                size: 32,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No Matching Opportunities',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No activities matching "${appState.searchQuery.trim()}" in ${appState.selectedCauseFilter}.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    _searchController.clear();
                    appState.setSearchQuery('');
                  },
                  child: const Text('Clear Search'),
                ),
                OutlinedButton(
                  onPressed: () => appState.setCauseFilter(null),
                  child: const Text('Clear Category'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _searchController.clear();
                    appState.resetFilters();
                  },
                  child: const Text('Reset All Filters'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchOnlyEmptyState(AppState appState) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTheme.surfaceMuted,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 32,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No Search Results',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'We couldn\'t find any opportunities matching "${appState.searchQuery.trim()}".',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _searchController.clear();
                appState.setSearchQuery('');
              },
              child: const Text('Clear Search'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryOnlyEmptyState(AppState appState) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTheme.surfaceMuted,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.category_outlined,
                size: 32,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No ${appState.selectedCauseFilter} Opportunities',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'There are no opportunities listed under ${appState.selectedCauseFilter} right now.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => appState.setCauseFilter(null),
              child: const Text('Show All Categories'),
            ),
          ],
        ),
      ),
    );
  }
}
