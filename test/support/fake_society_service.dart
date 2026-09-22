import 'package:flutter_nivasshub/core/api/api_response.dart';
import 'package:flutter_nivasshub/models/society/society_details_response.dart';
import 'package:flutter_nivasshub/models/society/society_floor.dart';
import 'package:flutter_nivasshub/models/society/society_tower.dart';
import 'package:flutter_nivasshub/models/society/society_unit.dart';
import 'package:flutter_nivasshub/services/society/society_service_base.dart';

/// In-memory stand-in for [SocietyService], used by widget tests so they
/// don't need a live `GET /society/details?socid=` call. Mirrors the
/// documented Tower → Floor → Unit shape for society id `33`.
class FakeSocietyService implements SocietyServiceBase {
  const FakeSocietyService();

  @override
  Future<ApiResponse<SocietyDetailsResponseData>> getSocietyDetails(
    String socId,
  ) async {
    return ApiResponse.success(
      const SocietyDetailsResponseData(
        societyId: '33',
        towers: [
          SocietyTower(
            towerId: '7',
            towerName: 'Tower E',
            towerCode: 'TE',
            totalFloors: 10,
            floors: [
              SocietyFloor(
                floorId: '1',
                floorNumber: 1,
                floorName: 'Floor - 1',
                units: [
                  SocietyUnit(
                    unitId: '3',
                    unitNumber: 'TE201',
                    unitTypeBhk: '5bhk',
                    carpetArea: 75,
                    superArea: 1350,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
