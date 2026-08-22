import 'package:cloud_firestore/cloud_firestore.dart';

class JobApplication {
  static const _validator = ['Applied', 'Rejected', 'Offer', 'Interview'];
  static const Object _unset = Object();

  final String? id;
  final String companyName;
  final String jobRole;
  final String logoUrl;
  final String jobType;
  final String status;
  final DateTime appliedDate;
  final String? location;
  final String? jobUrl;
  final String? notes;
  final Timestamp? createdAt;

  const JobApplication({
    this.id,
    required this.companyName,
    required this.jobRole,
    required this.logoUrl,
    required this.jobType,
    required this.status,
    required this.appliedDate,
    this.location,
    this.jobUrl,
    this.notes,
    this.createdAt,
  });

  JobApplication copyWith({
    String? companyName,
    String? jobRole,
    String? logoUrl,
    Object? location = _unset,
    String? jobType,
    String? status,
    DateTime? appliedDate,
    Object? jobUrl = _unset,
    Object? notes = _unset,
  }) {
    return JobApplication(
      id: id,
      companyName: companyName ?? this.companyName,
      jobRole: jobRole ?? this.jobRole,
      logoUrl: logoUrl ?? this.logoUrl,
      location: identical(location, _unset)
          ? this.location
          : location as String?,
      jobType: jobType ?? this.jobType,
      status: status ?? this.status,
      appliedDate: appliedDate ?? this.appliedDate,
      jobUrl: identical(jobUrl, _unset) ? this.jobUrl : jobUrl as String?,
      notes: identical(notes, _unset) ? this.notes : notes as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companyName': companyName,
      'jobRole': jobRole,
      'logoUrl': logoUrl,
      'location': location,
      'jobType': jobType,
      'status': status,
      'appliedDate': appliedDate,
      'jobUrl': jobUrl,
      'notes': notes,
      'createdAt': createdAt,
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'companyName': companyName,
      'jobRole': jobRole,
      'logoUrl': logoUrl,
      'location': location,
      'jobType': jobType,
      'status': status,
      'appliedDate': appliedDate,
      'jobUrl': jobUrl,
      'notes': notes,
    };
  }

  factory JobApplication.fromMap(Map<String, dynamic> map, String id) {
    return JobApplication(
      id: id,
      companyName: map['companyName'] is String
          ? map['companyName']
          : 'Unknown Company',
      jobRole: map['jobRole'] is String ? map['jobRole'] : 'Unknown Job Role',
      logoUrl: map['logoUrl'] is String
          ? map['logoUrl']
          : 'assets/images/default.webp',

      jobType: map['jobType'] is String ? map['jobType'] : 'Unknown Job Type',
      status: map['status'] is String && _validator.contains(map['status'])
          ? map['status']
          : 'Applied',
      appliedDate: map['appliedDate'] is Timestamp
          ? (map['appliedDate'] as Timestamp).toDate()
          : DateTime.now(),
      location: map['location'] is String ? map['location'] : null,
      jobUrl: map['jobUrl'] is String ? map['jobUrl'] : null,
      notes: map['notes'] is String ? map['notes'] : null,
      createdAt: map['createdAt'] is Timestamp ? map['createdAt'] : null,
    );
  }
}
