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

  Future<JobApplication> addApplication({
    required JobApplication application,
  }) async {
    DocumentReference docRef = _applications.doc();
    final data = {
      ...application.toMap(),
      'id': docRef.id,
      'createdAt': FieldValue.serverTimestamp(),
    };
    await _applications.doc(docRef.id).set(data);
    final snapshot = await docRef.get();
    return JobApplication.fromMap(
      snapshot.data() as Map<String, dynamic>,
      snapshot.id,
    );
  }

  Future<void> updateApplication({required JobApplication application}) async {
    await _applications.doc(application.id).update(application.toUpdateMap());
  }

  Future<void> deleteApplication({required String applicationId}) async {
    await _applications.doc(applicationId).delete();
  }
}
