/// One pet type from `GET /pet/add-pet` with the breeds the backend offers
/// for it, e.g. `Dog` -> `[Labrador, Beagle, ...]`.
class PetTypeOption {
  const PetTypeOption({
    required this.petType,
    required this.breeds,
    this.petTypeId,
    this.petTypeCode,
    this.breedIds = const {},
  });

  /// Breed display name -> backend breed id (`breedtype` on POST).
  final Map<String, int> breedIds;

  static const _breedIdKeys = ['breedId', 'breed_id', 'petBreedId', 'id'];

  static int? _breedId(dynamic b) {
    if (b is! Map) return null;
    for (final key in _breedIdKeys) {
      final v = int.tryParse(b[key]?.toString() ?? '');
      if (v != null) return v;
    }
    return null;
  }

  /// Display name (`petTypeName`), e.g. "Bird".
  final String petType;
  final List<String> breeds;
  final int? petTypeId;
  final String? petTypeCode;

  static const _breedNameKeys = [
    'breedName',
    'breed_name',
    'petBreedName',
    'name',
    'breed',
  ];

  static String _breedLabel(dynamic b) {
    if (b is Map) {
      for (final key in _breedNameKeys) {
        final v = b[key]?.toString().trim();
        if (v != null && v.isNotEmpty) return v;
      }
      return '';
    }
    return b?.toString().trim() ?? '';
  }

  /// Accepts the current camelCase shape (`petTypeName`, `petTypeId`,
  /// `petTypeCode`) as well as the older snake_case `pet_type`. Breeds may
  /// be plain strings or objects carrying a name.
  factory PetTypeOption.fromJson(Map<String, dynamic> json) {
    final rawBreeds = json['breeds'];
    final name = (json['petTypeName'] ?? json['pet_type'] ?? json['petType'])
        ?.toString()
        .trim();
    return PetTypeOption(
      petType: name ?? '',
      petTypeId: int.tryParse(json['petTypeId']?.toString() ?? ''),
      petTypeCode: json['petTypeCode']?.toString(),
      breeds: rawBreeds is List
          ? [
              for (final b in rawBreeds)
                if (_breedLabel(b).isNotEmpty) _breedLabel(b),
            ]
          : const [],
      breedIds: rawBreeds is List
          ? {
              for (final b in rawBreeds)
                if (_breedLabel(b).isNotEmpty && _breedId(b) != null)
                  _breedLabel(b): _breedId(b)!,
            }
          : const {},
    );
  }

  /// Pulls the type list out of the response envelope. The list sits at
  /// `body.data.data` (the stored procedure's own envelope nested inside the
  /// API envelope); a bare `body.data` list is accepted too.
  static List<PetTypeOption> listFromResponse(dynamic body) {
    dynamic node = body is Map ? body['data'] : null;
    if (node is Map) node = node['data'];
    if (node is! List) return const [];
    return [
      for (final item in node)
        if (item is Map) PetTypeOption.fromJson(Map<String, dynamic>.from(item)),
    ].where((t) => t.petType.isNotEmpty).toList();
  }
}
