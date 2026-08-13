import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_application_tracker/features/applications/models/job_application.dart';
import 'package:job_application_tracker/features/applications/providers/add_application_provider.dart';

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

  Future<void> _saveChanges() async {
    final newApplication = widget.application.copyWith(status: selection);
    try {
      await ref
          .read(applicationProvider.notifier)
          .updateApplication(jobApplication: newApplication);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Updated successfully")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong: ${e.toString()}")),
      );
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    selection = widget.application.status;
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.application;
    final buttonState = ref.watch(applicationByIdProvider(job.id!));

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
              if (job.jobUrl!.trim().isNotEmpty)
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
                    onPressed: selection == buttonState.status
                        ? null
                        : () {
                            _saveChanges();
                          },
                    child: Text("Save Changes"),
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
