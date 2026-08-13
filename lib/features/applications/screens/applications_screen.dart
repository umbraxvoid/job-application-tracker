import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_application_tracker/features/applications/models/job_application.dart';
import 'package:job_application_tracker/features/applications/providers/add_application_provider.dart';
import 'package:job_application_tracker/features/applications/screens/add_application_screen.dart';
import 'package:job_application_tracker/features/applications/screens/application_details_screen.dart';
import 'package:job_application_tracker/features/applications/widgets/application_card.dart';

class ApplicationsScreen extends ConsumerStatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  ConsumerState<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends ConsumerState<ApplicationsScreen> {
  final status = ['All', 'Applied', 'Interview', 'Offer', 'Rejected'];
  String _selectedStatus = "All";

  final TextEditingController _controller = TextEditingController();

  List<JobApplication> _searchApplications(List<JobApplication> applications) {
    final query = _controller.text.trim().toLowerCase();

    return applications.where((application) {
      final matchesSearch =
          query.isEmpty ||
          application.companyName.toLowerCase().startsWith(query) ||
          application.jobRole.toLowerCase().startsWith(query);

      final matchesStatus =
          _selectedStatus == 'All' || application.status == _selectedStatus;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final applications = ref.watch(applicationProvider);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: applications.when(
            data: (application) {
              final filteredApplications = _searchApplications(application);
              if (application.isEmpty) {
                return Center(
                  child: Text(
                    "No applications yet\nStart tracking your job applications.",
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return SafeArea(
                child: Column(
                  children: [
                    Text(
                      "Applications",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(height: 6),
                    Text("${filteredApplications.length} Applications"),
                    SizedBox(height: 14),

                    TextField(
                      onChanged: (value) {
                        setState(() {});
                      },
                      controller: _controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                        hintText: "Search company or role...",
                      ),
                    ),
                    SizedBox(height: 8),

                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: status.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: GestureDetector(
                            onTap: () {
                              _selectedStatus = status[index];
                              setState(() {});
                            },
                            child: Chip(
                              label: Text(status[index]),
                              backgroundColor: _selectedStatus == status[index]
                                  ? Colors.green
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    if (filteredApplications.isEmpty)
                      Expanded(
                        child: Center(
                          child: Text(
                            "🔍 No applications found\nTry changing your search or filter.",
                          ),
                        ),
                      )
                    else
                      // if (_selectedStatus != 'All' && data.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredApplications.length,
                          itemBuilder: (context, index) {
                            final application = filteredApplications[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ApplicationDetailsScreen(
                                      application: application,
                                    ),
                                  ),
                                );
                              },
                              child: ApplicationCard(
                                companyName: application.companyName,
                                jobRole: application.jobRole,
                                location: application.location!,
                                status: application.status,
                                appliedDate: application.appliedDate,
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              );
            },
            error: (e, _) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Something went wrong\nUnable to load applications: ${e.toString()}",
                  ),
                  SizedBox(height: 6),
                  ElevatedButton(onPressed: () {}, child: Text("Retry")),
                ],
              ),
            ),
            loading: () => Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 8),
                  Text("Loading..."),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddApplicationScreen()),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
