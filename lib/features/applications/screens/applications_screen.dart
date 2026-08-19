import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_application_tracker/features/applications/models/job_application.dart';
import 'package:job_application_tracker/features/applications/providers/application_provider.dart';
import 'package:job_application_tracker/features/applications/screens/add_application_screen.dart';
import 'package:job_application_tracker/features/applications/screens/application_details_screen.dart';

class ApplicationsScreen extends ConsumerStatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  ConsumerState<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends ConsumerState<ApplicationsScreen> {
  final List<String> statusList = [
    'All',
    'Applied',
    'Interview',
    'Offer',
    'Rejected',
  ];
  String _selectedStatus = "All";

  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    // Fix: Properly dispose of the search controller to prevent memory leaks
    _searchController.dispose();
    super.dispose();
  }

  List<JobApplication> _searchApplications(List<JobApplication> applications) {
    final query = _searchController.text.trim().toLowerCase();

    return applications.where((application) {
      final matchesSearch =
          query.isEmpty ||
          application.companyName.toLowerCase().contains(query) ||
          application.jobRole.toLowerCase().contains(query);

      final matchesStatus =
          _selectedStatus == 'All' || application.status == _selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final applicationsAsync = ref.watch(applicationProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white, // Pure white background
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: const Text(
            "Applications",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
              letterSpacing: -0.5,
            ),
          ),
          centerTitle: false,
        ),
        body: SafeArea(
          child: applicationsAsync.when(
            data: (applications) {
              final filteredApplications = _searchApplications(applications);

              if (applications.isEmpty) {
                return _buildEmptyState(
                  icon: Icons.work_outline_rounded,
                  title: "No applications yet",
                  subtitle: "Start tracking your job search journey.",
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "You have ${applications.length} tracked applications",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFE5E7EB),
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF111827),
                        ),
                        onChanged: (value) => setState(() {}),
                        decoration: const InputDecoration(
                          hintText: "Search company or role...",
                          hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: Color(0xFF9CA3AF),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Flat Filter Chips
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      scrollDirection: Axis.horizontal,
                      itemCount: statusList.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final status = statusList[index];
                        final isSelected = _selectedStatus == status;

                        return GestureDetector(
                          onTap: () {
                            setState(() => _selectedStatus = status);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF1769FF)
                                  : const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF1769FF)
                                    : const Color(0xFFE5E7EB),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                status,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF4B5563),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (filteredApplications.isEmpty)
                    Expanded(
                      child: _buildEmptyState(
                        icon: Icons.search_off_rounded,
                        title: "No results found",
                        subtitle: "Try adjusting your search or filters.",
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 80,
                        ), // Padding for FAB
                        itemCount: filteredApplications.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final application = filteredApplications[index];
                          return GestureDetector(
                            onTap: () async {
                              FocusManager.instance.primaryFocus?.unfocus();

                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ApplicationDetailsScreen(
                                    application: application,
                                  ),
                                ),
                              );

                              if (!mounted) return;

                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              });
                            },
                            child: ApplicationCard(
                              companyName: application.companyName,
                              jobRole: application.jobRole,
                              location: application.location,
                              status: application.status,
                              appliedDate: application.appliedDate,
                            ),
                          );
                        },
                      ),
                    ),
                ],
              );
            },

            loading: () => const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1769FF),
                strokeWidth: 3,
              ),
            ),
            error: (e, _) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: Colors.redAccent,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Unable to load data",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    e.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Color(0xFF6B7280)),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1769FF),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.refresh_rounded, size: 20),
                    label: const Text("Retry"),
                    onPressed: () {
                      // Fix: Correctly trigger a re-fetch
                      ref.invalidate(applicationProvider);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF1769FF),
          foregroundColor: Colors.white,
          elevation: 0, // Flat design strictly
          highlightElevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          onPressed: () async {
            FocusManager.instance.primaryFocus?.unfocus();

            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddApplicationScreen()),
            );

            if (!mounted) return;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              FocusManager.instance.primaryFocus?.unfocus();
            });
          },
          child: const Icon(Icons.add_rounded, size: 28),
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 48, color: const Color(0xFF9CA3AF)),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }
}

class ApplicationCard extends StatelessWidget {
  final String companyName;
  final String jobRole;
  final String location;
  final String status;
  final String appliedDate;

  const ApplicationCard({
    super.key,
    required this.companyName,
    required this.jobRole,
    required this.location,
    required this.status,
    required this.appliedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // No BoxShadow
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1.2,
        ), // Clean flat border
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo Placeholder
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFF3F4F6), width: 1),
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: NetworkImage(
                      "https://media.wired.com/photos/5926ffe47034dc5f91bed4e8/3:2/w_2560%2Cc_limit/google-logo.jpg",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Text Content
              Expanded(
                // Fix: Replaced hardcoded width with Expanded to prevent overflows
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      companyName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      jobRole,
                      style: const TextStyle(
                        color: Color(0xFF4B5563),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Color(0xFF9CA3AF),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          // Protects against extremely long location names
                          child: Text(
                            location.isEmpty ? 'Remote' : location,
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: _statusBoxColor(status),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _statusTextColor(status),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      status,
                      style: TextStyle(
                        color: _statusTextColor(status),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFF3F4F6)),
          ),

          Row(
            children: [
              const Icon(
                Icons.calendar_month_outlined,
                size: 16,
                color: Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 6),
              Text(
                "Applied on $appliedDate",
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _statusBoxColor(String name) {
    switch (name) {
      case 'Applied':
        return const Color(0xFFEFF6FF); // Lighter Blue
      case 'Interview':
        return const Color(0xFFFFF7ED); // Lighter Orange
      case 'Rejected':
        return const Color(0xFFFEF2F2); // Lighter Red
      case 'Offer':
        return const Color(0xFFECFDF5); // Fix: Added Lighter Green for Offer
      default:
        return const Color(0xFFEFF6FF);
    }
  }

  Color _statusTextColor(String name) {
    switch (name) {
      case 'Applied':
        return const Color(0xFF2563EB); // Deep Blue
      case 'Interview':
        return const Color(0xFFEA580C); // Deep Orange
      case 'Rejected':
        return const Color(0xFFDC2626); // Deep Red
      case 'Offer':
        return const Color(0xFF059669); // Fix: Added Deep Green for Offer
      default:
        return const Color(0xFF2563EB);
    }
  }
}
