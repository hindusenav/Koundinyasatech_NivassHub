import 'package:flutter_nivasshub/core/api/api_exception.dart';
import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/family/add_family.dart';
import 'package:flutter_nivasshub/models/family/family_relation.dart';
import 'package:flutter_nivasshub/providers/family/family_provider.dart';
import 'package:flutter_nivasshub/services/family/family_service_base.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeFamilyService implements FamilyServiceBase {
  _FakeFamilyService({this.addFails = false});

  final bool addFails;
  AddFamilyRequest? lastRequest;

  @override
  Future<ApiResponse<FamilyRelationsData>> getRelations() async =>
      ApiResponse.success(
        FamilyRelationsData.fromJson({
          'data': {
            'categories': [
              {
                'categoryId': 1,
                'categoryName': 'Core Family',
                'relations': [
                  {'relationId': 4, 'relationName': 'Son'},
                ],
              },
            ],
          },
        }),
      );

  @override
  Future<ApiResponse<AddFamilyResult>> addFamily(
    AddFamilyRequest request,
  ) async {
    lastRequest = request;
    if (addFails) {
      return ApiResponse.failure(
        const ApiException(
          message: 'Mobile already registered.',
          type: ApiExceptionType.unknown,
        ),
      );
    }
    return ApiResponse.success(
      AddFamilyResult.fromJson({
        'message': 'Family member added successfully.',
        'data': {
          'name': 'Srinu  K',
          'relationship': 'Son',
          'mobile_country_code': '+91',
          'mobile_masked': '******9164',
        },
      }),
    );
  }
}

void main() {
  test('parses relation categories', () async {
    final provider = FamilyProvider(service: _FakeFamilyService());
    await provider.load();
    expect(provider.state, FamilyLoadState.ready);
    expect(provider.relations.categories.single.relations.single.relationName,
        'Son');
  });

  test('rejects invalid mobile without calling the API', () async {
    final service = _FakeFamilyService();
    final provider = FamilyProvider(service: service);
    final result = await provider.addMember(
      name: 'Srinu',
      mobile: '12345',
      relation: 'Son',
    );
    expect(result, isNull);
    expect(provider.saveError, contains('10-digit'));
    expect(service.lastRequest, isNull);
  });

  test('adds a member and sends the documented body', () async {
    final service = _FakeFamilyService();
    final provider = FamilyProvider(service: service);
    final result = await provider.addMember(
      name: ' Srinu K ',
      mobile: '8008309164',
      relation: 'Son',
    );
    expect(result, isNotNull);
    expect(provider.members.single.name, 'Srinu K');
    expect(service.lastRequest!.toJson(), {
      'res_cont_code': '+91',
      'res_mob': '8008309164',
      'res_name': 'Srinu K',
      'res_relation': 'Son',
    });
  });

  test('surfaces the server error message', () async {
    final provider = FamilyProvider(service: _FakeFamilyService(addFails: true));
    final result = await provider.addMember(
      name: 'Srinu',
      mobile: '8008309164',
      relation: 'Son',
    );
    expect(result, isNull);
    expect(provider.saveError, 'Mobile already registered.');
    expect(provider.members, isEmpty);
  });
}
