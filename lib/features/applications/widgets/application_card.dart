import 'package:flutter/material.dart';

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
    return Card(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(companyName),
              Text(jobRole),
              Text(location),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(status),
                  ),
                  Spacer(),
                  Text(appliedDate),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
