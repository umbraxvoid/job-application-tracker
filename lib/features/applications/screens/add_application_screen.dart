import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_application_tracker/features/applications/models/job_application.dart';
import 'package:job_application_tracker/features/applications/providers/application_provider.dart';
import 'package:job_application_tracker/features/applications/widgets/app_text_form_field.dart';

class AddApplicationScreen extends ConsumerStatefulWidget {
  const AddApplicationScreen({super.key});

  @override
  ConsumerState<AddApplicationScreen> createState() =>
      _AddApplicationScreenState();
}

class _AddApplicationScreenState extends ConsumerState<AddApplicationScreen> {
  final List<TextEditingController> _controllers = List.generate(5, (index) {
    return TextEditingController();
  });
  final jobType = ['Full Time', 'Part Time', 'Remote'];
  final status = ['Applied', 'Interview', 'Rejected'];
  String _selectedJobType = 'Full Time';
  String _selectedStatus = 'Applied';
  final _formKey = GlobalKey<FormState>();
  String? date;
  bool isLoading = false;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 2)),
    );
  }

  Future<void> _pickDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );
    if (result == null) return;
    setState(() {
      date = "${result.day} - ${result.month} - ${result.year}";
    });
  }

  void _setToDefault() {
    for (final controller in _controllers) {
      controller.clear();
    }
    date = null;
    _selectedJobType = 'Full Time';
    _selectedStatus = 'Applied';
    setState(() {});
  }

  Future<void> _saveApplication() async {
    setState(() {
      isLoading = true;
    });
    final result = _formKey.currentState!.validate();
    if (result == false) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    if (date == null) {
      setState(() {
        isLoading = false;
      });
      _showMessage("Please Select date");
      return;
    }
    final application = JobApplication(
      companyName: _controllers[0].text.trim(),
      jobRole: _controllers[1].text.trim(),
      location: _controllers[2].text.trim(),
      jobType: _selectedJobType,
      status: _selectedStatus,
      appliedDate: date!,
      jobUrl: _controllers[3].text,
      notes: _controllers[4].text,
      createdAt: null,
    );
    try {
      await ref
          .read(applicationProvider.notifier)
          .addApplication(application: application);
      setState(() {
        isLoading = false;
      });
      _showMessage("Application added successfully");
      _setToDefault();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showMessage("Something went wrong: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Add Application",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Form(
                    key: _formKey,
                    child: Column(
                      spacing: 14,
                      children: [
                        AppTextFormField(
                          prefixIcon: Icon(Icons.view_compact_alt_outlined),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Company name can't be empty";
                            }
                            return null;
                          },
                          hintText: "Enter company name",
                          labelText: "Company Name",
                          controller: _controllers[0],
                        ),
                        AppTextFormField(
                          prefixIcon: Icon(Icons.add_box),
                          hintText: "Enter job role",
                          labelText: "Job Role",
                          controller: _controllers[1],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter job role";
                            }
                            return null;
                          },
                        ),

                        AppTextFormField(
                          prefixIcon: Icon(Icons.location_pin),
                          hintText: "Enter company/work location",
                          labelText: "Location",
                          controller: _controllers[2],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownMenu<String>(
                                onSelected: (value) {
                                  if (value != null) {
                                    _selectedJobType = value;
                                  }
                                },

                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                                trailingIcon: Icon(Icons.keyboard_arrow_down),
                                selectedTrailingIcon: Icon(
                                  Icons.keyboard_arrow_up,
                                ),
                                initialSelection: "Full Time",
                                dropdownMenuEntries: jobType
                                    .map(
                                      (e) => DropdownMenuEntry(
                                        leadingIcon: Icon(
                                          Icons.add_circle_outline_rounded,
                                        ),
                                        value: e,
                                        label: e,
                                      ),
                                    )
                                    .toList(),
                                inputDecorationTheme: InputDecorationTheme(
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: DropdownMenu<String>(
                                onSelected: (value) {
                                  if (value != null) {
                                    _selectedStatus = value;
                                  }
                                },
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                                trailingIcon: Icon(Icons.keyboard_arrow_down),
                                selectedTrailingIcon: Icon(
                                  Icons.keyboard_arrow_up,
                                ),
                                initialSelection: "Applied",
                                dropdownMenuEntries: status
                                    .map(
                                      (e) => DropdownMenuEntry(
                                        leadingIcon: Icon(
                                          Icons.check_circle_outline,
                                        ),
                                        value: e,
                                        label: e,
                                      ),
                                    )
                                    .toList(),
                                inputDecorationTheme: InputDecorationTheme(
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            _pickDate();
                          },
                          child: Card(
                            child: SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      date != null
                                          ? Text("Applied Date: $date")
                                          : Text("Select Date"),
                                      Spacer(),
                                      Icon(Icons.add),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // SizedBox(height: 20),
                        AppTextFormField(
                          prefixIcon: Icon(Icons.format_underline_outlined),
                          hintText: "Enter job url",
                          labelText: "JOB Url",
                          controller: _controllers[3],
                        ),

                        AppTextFormField(
                          hintText: "Enter notes...",
                          labelText: "Notes",
                          controller: _controllers[4],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isLoading == true
                        ? null
                        : () {
                            _saveApplication();
                          },
                    child: Text("Save Application"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
