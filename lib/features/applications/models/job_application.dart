import 'package:cloud_firestore/cloud_firestore.dart';

class JobApplication {
  final String? id;
  final String companyName;
  final String jobRole;
  final String logoUrl;
  final String location;
  final String jobType;
  final String status;
  final String appliedDate;
  final String jobUrl;
  final String notes;
  final Timestamp? createdAt;

  const JobApplication({
    this.id,
    required this.companyName,
    required this.jobRole,
    required this.logoUrl,
    required this.location,
    required this.jobType,
    required this.status,
    required this.appliedDate,
    required this.jobUrl,
    required this.notes,
    this.createdAt,
  });

  JobApplication copyWith({
    String? id,
    String? companyName,
    String? jobRole,
    String? logoUrl,
    String? location,
    String? jobType,
    String? status,
    String? appliedDate,
    String? jobUrl,
    String? notes,
  }) {
    return JobApplication(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      jobRole: jobRole ?? this.jobRole,
      logoUrl: logoUrl ?? this.logoUrl,
      location: location ?? this.location,
      jobType: jobType ?? this.jobType,
      status: status ?? this.status,
      appliedDate: appliedDate ?? this.appliedDate,
      jobUrl: jobUrl ?? this.jobUrl,
      notes: notes ?? this.notes,
      createdAt: createdAt,
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
      companyName: map['companyName'] as String,
      jobRole: map['jobRole'] as String,
      logoUrl: map['logoUrl'] as String,
      location: map['location'],
      jobType: map['jobType'] as String,
      status: map['status'] as String,
      appliedDate: map['appliedDate'] as String,
      jobUrl: map['jobUrl'],
      notes: map['notes'],
      createdAt: map['createdAt'] as Timestamp,
    );
  }
}
