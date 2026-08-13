import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_application_tracker/features/applications/models/job_application.dart';

class ApplicationRepository {
  final FirebaseFirestore _firestore;
  const ApplicationRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _applications =>
      _firestore.collection('applications');

  Future<List<JobApplication>> getApplications() async {
    final snapshot = await _applications
        .orderBy("createdAt", descending: true)
        .get();
    final applications = snapshot.docs
        .map((doc) => JobApplication.fromMap(doc.data(), doc.id))
        .toList();
    return applications;
  }

  Future<void> addApplication({required JobApplication application}) async {
    final data = {
      ...application.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    };

    await _applications.add(data);
  }

  Future<void> updateApplication({required JobApplication application}) async {
    await _applications
        .doc(application.id)
        .set(application.toUpdateMap(), SetOptions(merge: true));
  }
}
