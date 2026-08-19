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
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        // boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4)],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300, width: 0.8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://media.wired.com/photos/5926ffe47034dc5f91bed4e8/3:2/w_2560%2Cc_limit/google-logo.jpg",
                      ),
                    ),
                    color: Color(0xFFEDF3FD),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      // companyName[0],
                      "",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      companyName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      jobRole,
                      style: TextStyle(color: Color(0xFF494953), fontSize: 15),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 18,
                          color: Color(0xFF7B7D85),
                        ),
                        SizedBox(width: 4),
                        SizedBox(
                          width: 100,
                          child: Text(
                            location,
                            style: TextStyle(color: Color(0xFF7B7D85)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: statusBoxColor(status),
                  ),
                  child: Text(
                    "• $status",
                    style: TextStyle(color: statusTextColor(status)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_month_sharp,
                  size: 18,
                  color: Color(0xFF7B7D85),
                ),

                SizedBox(width: 4),
                Text(
                  "Applied on $appliedDate",
                  style: TextStyle(color: Color(0xFF7B7D85)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color statusBoxColor(String name) {
    switch (name) {
      case 'Applied':
        return Color(0xFFEDF3FD);

      case 'Interview':
        return Color(0xFFFEF8F0);
      case 'Rejected':
        return Color(0xFFFEF2F2);
      default:
        return Color(0xFFEDF3FD);
    }
  }

  Color statusTextColor(String name) {
    switch (name) {
      case 'Applied':
        return Color(0xFF004FD7);

      case 'Interview':
        return Color(0xFFF57401);
      case 'Rejected':
        return Color(0xFFD3121A);
      default:
        return Color(0xFFD3121A);
    }
  }
}
