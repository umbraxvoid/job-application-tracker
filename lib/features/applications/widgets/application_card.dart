import 'package:flutter/material.dart';

class ApplicationCard extends StatelessWidget {
  final String companyName;
  final String jobRole;
  final String location;
  final String status;
  final String appliedDate;
  final String logoUrl;

  const ApplicationCard({
    super.key,
    required this.companyName,
    required this.jobRole,
    required this.location,
    required this.status,
    required this.appliedDate,
    required this.logoUrl,
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
                  image: DecorationImage(
                    image: AssetImage(logoUrl),
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
