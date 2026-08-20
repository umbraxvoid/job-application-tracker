import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:job_application_tracker/features/applications/data/application_repository.dart';
import 'package:job_application_tracker/features/applications/models/job_application.dart';

final firebaseProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

final applicationRepositoryProvider = Provider<ApplicationRepository>((ref) {
  return ApplicationRepository(ref.watch(firebaseProvider));
});

class AddApplicationNotifier extends AsyncNotifier<List<JobApplication>> {
  ApplicationRepository get _repo => ref.read(applicationRepositoryProvider);

  @override
  Future<List<JobApplication>> build() async {
    return await _repo.getApplications();
  }

  Future<void> addApplication({required JobApplication application}) async {
    final snapshot = await _repo.addApplication(application: application);
    await update((applications) => [snapshot, ...applications]);
    // final oldState = state.value;
    // final snapshot = await _repo.addApplication(application: application);
    // final newList = [snapshot, ...?oldState];
    // state = AsyncData(newList);
  }

  Future<void> updateApplication({
    required JobApplication jobApplication,
  }) async {
    await _repo.updateApplication(application: jobApplication);
    await update(
      (applications) => [
        for (final application in applications)
          if (application.id == jobApplication.id)
            jobApplication
          else
            application,
      ],
    );
  }

  Future<void> deleteApplication({required String applicationId}) async {
    await _repo.deleteApplication(applicationId: applicationId);
    await update(
      (applications) => [
        for (final application in applications)
          if (application.id != applicationId) application,
      ],
    );
  }
}

final applicationProvider =
    AsyncNotifierProvider<AddApplicationNotifier, List<JobApplication>>(
      AddApplicationNotifier.new,
      retry: (errorCount, error) => null,
    );

final applicationByIdProvider = Provider.family<JobApplication?, String>((
  ref,
  id,
) {
  final jobs = ref.watch(applicationProvider).value ?? [];
  // final job = jobs!.where((j) => j.id == id).first;
  for (final application in jobs) {
    if (application.id == id) {
      return application;
    }
  }
  return null;
});
