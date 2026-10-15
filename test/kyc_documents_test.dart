import 'package:flutter_nivasshub/models/kyc/kyc_applicable_document.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('GET /kyc/documents rows keep their own document_name_id', () {
    final docs = KycApplicableDocument.listFromJson([
      {
        'document_name_id': 13,
        'document_name': 'Aadhar',
        'description': 'Government-issued identity document',
        'is_mandatory': 'Mandatory',
      },
      {
        'document_name_id': 14,
        'document_name': 'Driving Licence',
        'description': '',
        'is_mandatory': 'Not Mandatory',
      },
      {
        'document_name_id': 19,
        'document_name': 'Lease Agreement',
        'description': '',
        'is_mandatory': 'Mandatory',
      },
    ]);

    expect(docs.map((d) => d.documentId), [13, 14, 19]);
    expect(docs.map((d) => d.documentName), [
      'Aadhar',
      'Driving Licence',
      'Lease Agreement',
    ]);
    expect(docs.map((d) => d.isMandatory), [true, false, true]);
  });
}
