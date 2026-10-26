import 'package:flutter_nivasshub/constants/kyc/kyc_strings.dart';

/// Which KYC outcome triggered a mock email (spec §16).
enum MockNotificationType {
  kycApproved,
  kycRejected,
  kycCorrectionRequired;

  String get wireValue => name;

  String get subject => switch (this) {
    MockNotificationType.kycApproved => KycStrings.emailApprovedSubject,
    MockNotificationType.kycRejected => KycStrings.emailRejectedSubject,
    MockNotificationType.kycCorrectionRequired =>
      KycStrings.emailCorrectionSubject,
  };

  static MockNotificationType fromJson(dynamic value) {
    for (final type in MockNotificationType.values) {
      if (type.wireValue == value) return type;
    }
    return MockNotificationType.kycApproved;
  }
}

/// One entry in the mock email log. The real email service is not wired
/// up, so these are printed to the console and listed on an in-app screen
/// instead of being sent.
class MockNotificationModel {
  const MockNotificationModel({
    required this.id,
    required this.type,
    required this.subject,
    required this.body,
    required this.recipient,
    required this.sentAt,
    this.read = false,
  });

  final String id;
  final MockNotificationType type;
  final String subject;
  final String body;
  final String recipient;
  final DateTime sentAt;
  final bool read;

  MockNotificationModel copyWith({bool? read}) => MockNotificationModel(
    id: id,
    type: type,
    subject: subject,
    body: body,
    recipient: recipient,
    sentAt: sentAt,
    read: read ?? this.read,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.wireValue,
    'subject': subject,
    'body': body,
    'recipient': recipient,
    'sentAt': sentAt.toIso8601String(),
    'read': read,
  };

  factory MockNotificationModel.fromJson(Map<String, dynamic> json) {
    return MockNotificationModel(
      id: json['id'] as String? ?? '',
      type: MockNotificationType.fromJson(json['type']),
      subject: json['subject'] as String? ?? '',
      body: json['body'] as String? ?? '',
      recipient: json['recipient'] as String? ?? '',
      sentAt:
          DateTime.tryParse(json['sentAt'] as String? ?? '') ?? DateTime.now(),
      read: json['read'] as bool? ?? false,
    );
  }
}
