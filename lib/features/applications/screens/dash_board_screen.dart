import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_application_tracker/features/applications/providers/application_provider.dart';

class DashBoardScreen extends ConsumerStatefulWidget {
  const DashBoardScreen({super.key});

  @override
  ConsumerState<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends ConsumerState<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    final applicationsAsync = ref.watch(applicationProvider);

    return Scaffold(
      backgroundColor:
          Colors.white, // Pure white background matching other screens
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          "Dashboard",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: false,
        actions: [
          // Optional profile picture placeholder to make it feel like a home screen
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFFF3F4F6),
              child: const Icon(
                Icons.person_outline_rounded,
                color: Color(0xFF6B7280),
                size: 20,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: applicationsAsync.when(
          data: (data) {
            // Filter applications by status
            final applied = data
                .where((app) => app.status == 'Applied')
                .toList();
            final interview = data
                .where((app) => app.status == 'Interview')
                .toList();
            final offer = data.where((app) => app.status == 'Offer').toList();
            final rejected = data
                .where((app) => app.status == 'Rejected')
                .toList();

            return RefreshIndicator(
              color: const Color(0xFF1769FF),
              backgroundColor: Colors.white,
              onRefresh: () async => ref.invalidate(applicationProvider),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Here is your application progress",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Main Total Applications Banner
                    _buildTotalBanner(data.length),
                    const SizedBox(height: 24),

                    const Text(
                      "Status Overview",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 2x2 Grid using Rows and Columns for absolute layout control
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatusCard(
                            title: "Applied",
                            count: applied.length,
                            icon: Icons.send_rounded,
                            bgColor: const Color(0xFFEFF6FF),
                            textColor: const Color(0xFF2563EB),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatusCard(
                            title: "Interview",
                            count: interview.length,
                            icon: Icons.forum_rounded,
                            bgColor: const Color(0xFFFFF7ED),
                            textColor: const Color(0xFFEA580C),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatusCard(
                            title: "Offer",
                            count: offer.length,
                            icon: Icons.check_circle_rounded,
                            bgColor: const Color(0xFFECFDF5),
                            textColor: const Color(0xFF059669),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildStatusCard(
                            title: "Rejected",
                            count: rejected.length,
                            icon: Icons.cancel_rounded,
                            bgColor: const Color(0xFFFEF2F2),
                            textColor: const Color(0xFFDC2626),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40), // Bottom padding
                  ],
                ),
              ),
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
                  "Unable to load dashboard",
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
                  onPressed: () => ref.invalidate(applicationProvider),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTotalBanner(int totalCount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1769FF), // Primary Brand Blue
        borderRadius: BorderRadius.circular(20),
        // No shadow to keep the strict flat look
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Total Applications",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                totalCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                ),
              ),
            ],
          ),
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.work_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard({
    required String title,
    required int count,
    required IconData icon,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: textColor.withValues(alpha: 0.1),
          width: 1,
        ), // Very subtle border matching the hue
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: textColor, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: textColor,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: textColor.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
