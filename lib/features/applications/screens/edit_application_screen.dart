import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_application_tracker/features/applications/models/job_application.dart';
import 'package:job_application_tracker/features/applications/providers/application_provider.dart';
import 'package:intl/intl.dart';

class EditApplicationScreen extends ConsumerStatefulWidget {
  final JobApplication application;
  const EditApplicationScreen({super.key, required this.application});

  @override
  ConsumerState<EditApplicationScreen> createState() =>
      _EditApplicationScreenState();
}

class _EditApplicationScreenState extends ConsumerState<EditApplicationScreen> {
  late TextEditingController _companyNameController;
  late TextEditingController _jobRoleController;
  late TextEditingController _locationController;
  late TextEditingController _jobUrlController;
  late TextEditingController _notesController;

  final List<String> jobType = [
    'Full Time',
    'Part Time',
    'Remote',
    'Contract',
    'Internship',
  ];

  final List<String> _companyLogos = [
    'default', // Default
    'amazon',
    'flipkart',
    'google',
    'meta',
    'microsoft',
    'netflix',
    'nvidia',
  ];

  late String _selectedJobType;
  late String _selectedLogo; // State for the selected logo
  final _formKey = GlobalKey<FormState>();
  late DateTime date;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _companyNameController = TextEditingController(
      text: widget.application.companyName,
    );
    _jobRoleController = TextEditingController(
      text: widget.application.jobRole,
    );
    _locationController = TextEditingController(
      text: widget.application.location,
    );
    _jobUrlController = TextEditingController(text: widget.application.jobUrl);
    _notesController = TextEditingController(text: widget.application.notes);
    date = widget.application.appliedDate;

    // Safely initialize job type from existing data
    if (jobType.contains(widget.application.jobType)) {
      _selectedJobType = widget.application.jobType;
    } else {
      _selectedJobType = 'Full Time';
    }

    _selectedLogo = widget.application.logoUrl;
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _jobRoleController.dispose();
    _locationController.dispose();
    _jobUrlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showLogoSelectionSheet() {
    FocusScope.of(context).unfocus(); // Dismiss keyboard if open
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Select Company Logo",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount: _companyLogos.length,
                    itemBuilder: (context, index) {
                      final logoUrl =
                          "assets/images/${_companyLogos[index]}.webp";
                      final isSelected = _selectedLogo == logoUrl;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedLogo = logoUrl;
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF1769FF)
                                  : const Color(0xFFE5E7EB),
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: const Color(0xFFF9FAFB),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              logoUrl,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.business_rounded,
                                    color: Colors.grey,
                                  ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1769FF), // Flat modern blue
              onPrimary: Colors.white,
              onSurface: Color(0xFF111827),
            ),
          ),
          child: child!,
        );
      },
    );
    if (result == null) return;
    setState(() {
      date = result;
    });
  }

  Future<void> _saveApplication() async {
    if (_formKey.currentState?.validate() != true) return;

    final application = widget.application.copyWith(
      companyName: _companyNameController.text.trim(),
      jobRole: _jobRoleController.text.trim(),
      location: _locationController.text.trim().isNotEmpty
          ? _locationController.text.trim()
          : null,
      jobType: _selectedJobType,
      status: widget.application.status,
      appliedDate: date,
      jobUrl: _jobUrlController.text.trim().isNotEmpty
          ? _jobUrlController.text.trim()
          : null,
      notes: _notesController.text.trim().isNotEmpty
          ? _notesController.text.trim()
          : null,
      logoUrl: _selectedLogo,
    );

    try {
      setState(() => isLoading = true);
      await ref
          .read(applicationProvider.notifier)
          .updateApplication(jobApplication: application);

      if (!mounted) return;
      _showMessage("Application updated successfully");
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      _showMessage("Something went wrong: ${e.toString()}", isError: true);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white, // Pure white flat background
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: const Text(
            "Edit Application",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel("Company Details"),
                  const SizedBox(height: 12),

                  // Flat Company Logo Picker
                  _buildFlatLogoPicker(),
                  const SizedBox(height: 16),

                  _buildFlatTextField(
                    controller: _companyNameController,
                    label: "Company Name",
                    hint: "e.g. Google, Microsoft",
                    icon: Icons.business_rounded,
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                        ? "Company name is required"
                        : null,
                  ),
                  const SizedBox(height: 16),
                  _buildFlatTextField(
                    controller: _jobRoleController,
                    label: "Job Role",
                    hint: "e.g. Software Engineer",
                    icon: Icons.work_outline_rounded,
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                        ? "Job role is required"
                        : null,
                  ),
                  const SizedBox(height: 32),

                  _buildSectionLabel("Job Details"),
                  const SizedBox(height: 12),
                  _buildFlatTextField(
                    controller: _locationController,
                    label: "Location",
                    hint: "e.g. San Francisco, Remote",
                    icon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 16),
                  Row(children: [Expanded(child: _buildFlatDropdown())]),
                  const SizedBox(height: 16),

                  _buildFlatDatePicker(),
                  const SizedBox(height: 32),

                  _buildSectionLabel("Additional Info"),
                  const SizedBox(height: 12),
                  _buildFlatTextField(
                    controller: _jobUrlController,
                    label: "Job URL",
                    hint: "https://...",
                    icon: Icons.link_rounded,
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 16),
                  _buildFlatTextField(
                    controller: _notesController,
                    label: "Notes",
                    hint: "Any details about the interview, salary, etc.",
                    icon: Icons.notes_rounded,
                    maxLines: 4,
                  ),

                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF1769FF,
                        ), // Flat primary color
                        foregroundColor: Colors.white,
                        elevation: 0, // Strict NO shadow
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor: const Color(
                          0xFF1769FF,
                        ).withValues(alpha: 0.6),
                      ),
                      onPressed: isLoading ? null : _saveApplication,
                      child: isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              "Save Changes",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF6B7280),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildFlatLogoPicker() {
    return InkWell(
      onTap: _showLogoSelectionSheet,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Image.asset(
                  _selectedLogo,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.business_rounded, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Company Logo",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF111827),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Tap to change logo",
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF9CA3AF),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFlatTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
        fontSize: 15,
        color: Color(0xFF111827),
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFF9CA3AF),
          fontWeight: FontWeight.w400,
        ),
        labelStyle: const TextStyle(
          color: Color(0xFF6B7280),
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.only(bottom: maxLines > 1 ? 60.0 : 0),
          child: Icon(icon, color: const Color(0xFF6B7280), size: 22),
        ),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1769FF), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
      ),
    );
  }

  Widget _buildFlatDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedJobType,
      dropdownColor: Colors.white,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Color(0xFF6B7280),
      ),
      style: const TextStyle(
        fontSize: 15,
        color: Color(0xFF111827),
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: "Job Type",
        labelStyle: const TextStyle(
          color: Color(0xFF6B7280),
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: const Icon(
          Icons.work_history_outlined,
          color: Color(0xFF6B7280),
          size: 22,
        ),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1769FF), width: 1.5),
        ),
      ),
      items: jobType.map((type) {
        return DropdownMenuItem(value: type, child: Text(type));
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() => _selectedJobType = value);
        }
      },
    );
  }

  Widget _buildFlatDatePicker() {
    return InkWell(
      onTap: _pickDate,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_month_outlined,
              color: Color(0xFF6B7280),
              size: 22,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Applied Date",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat('d MMM yyyy').format(date),
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF111827),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(
              Icons.edit_calendar_rounded,
              color: Color(0xFF1769FF),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
