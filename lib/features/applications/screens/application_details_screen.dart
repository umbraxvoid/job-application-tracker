import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_application_tracker/features/applications/models/job_application.dart';
import 'package:job_application_tracker/features/applications/providers/application_provider.dart';

class ApplicationDetailsScreen extends ConsumerStatefulWidget {
  final JobApplication application;
  const ApplicationDetailsScreen({super.key, required this.application});

  @override
  ConsumerState<ApplicationDetailsScreen> createState() =>
      _ApplicationDetailsScreenState();
}

class _ApplicationDetailsScreenState
    extends ConsumerState<ApplicationDetailsScreen> {
  String? selection;
  late String savedStatus;

  Future<void> _saveChanges() async {
    final newApplication = widget.application.copyWith(status: selection);
    try {
      await ref
          .read(applicationProvider.notifier)
          .updateApplication(jobApplication: newApplication);
      if (!mounted) return;
      setState(() {
        savedStatus = selection!;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Updated successfully")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong: ${e.toString()}")),
      );
    }
  }

  Future<void> _deleteApplication({required String applicationId}) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Are you sure you want to delete this application?"),

          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await ref
                      .read(applicationProvider.notifier)
                      .deleteApplication(applicationId: applicationId);
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Something went wrong, try again")),
                  );
                }
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selection = widget.application.status;
    savedStatus = widget.application.status;
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.application;
    // final buttonState = ref.watch(applicationByIdProvider(job.id!));

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            spacing: 14,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
              Text(
                job.companyName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              // Text(job.status),
              DropdownMenu(
                initialSelection: job.status,
                onSelected: (value) {
                  if (value != null) {
                    setState(() {
                      selection = value;
                    });
                  }
                },
                inputDecorationTheme: InputDecorationTheme(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                dropdownMenuEntries: [
                  DropdownMenuEntry(value: "Applied", label: "Applied"),
                  // Applied', 'Interview', 'Rejected'
                  DropdownMenuEntry(value: "Interview", label: "Interview"),
                  DropdownMenuEntry(value: "Rejected", label: "Rejected"),
                ],
              ),
              if (job.location!.trim().isNotEmpty)
                _heading("Location", job.location!),
              if (job.jobType.trim().isNotEmpty)
                _heading("Job Type", job.jobType),
              _heading("Applied Date", job.appliedDate),
              if (job.jobUrl!.trim().isNotEmpty)
                _heading("Job Url", job.jobUrl!),
              if (job.notes!.trim().isNotEmpty) _heading("Notes", job.notes!),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: selection == savedStatus
                        ? null
                        : () {
                            _saveChanges();
                          },
                    child: Text("Save Changes"),
                  ),
                  SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: () {
                      _deleteApplication(applicationId: widget.application.id!);
                    },
                    child: Text("Delete"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _heading(String name, String data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        SizedBox(height: 4),
        Text(data),
      ],
    );
  }
}
