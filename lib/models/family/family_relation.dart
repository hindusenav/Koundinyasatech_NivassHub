/// One selectable relation, e.g. `Son` (`relationId` 4).
class FamilyRelation {
  const FamilyRelation({required this.relationId, required this.relationName});

  final int relationId;
  final String relationName;

  factory FamilyRelation.fromJson(Map<String, dynamic> json) {
    final id = json['relationId'];
    return FamilyRelation(
      relationId: id is num ? id.toInt() : int.tryParse('$id') ?? 0,
      relationName: json['relationName']?.toString() ?? '',
    );
  }
}

/// A heading such as "Core Family" with the relations listed under it.
class FamilyRelationCategory {
  const FamilyRelationCategory({
    required this.categoryId,
    required this.categoryName,
    required this.relations,
  });

  final int categoryId;
  final String categoryName;
  final List<FamilyRelation> relations;

  factory FamilyRelationCategory.fromJson(Map<String, dynamic> json) {
    final id = json['categoryId'];
    final raw = json['relations'];
    return FamilyRelationCategory(
      categoryId: id is num ? id.toInt() : int.tryParse('$id') ?? 0,
      categoryName: json['categoryName']?.toString() ?? '',
      relations: raw is List
          ? [
              for (final r in raw)
                if (r is Map)
                  FamilyRelation.fromJson(Map<String, dynamic>.from(r)),
            ]
          : const [],
    );
  }
}

/// Parsed `GET /get-family` response.
class FamilyRelationsData {
  const FamilyRelationsData({required this.categories});

  static const empty = FamilyRelationsData(categories: []);

  final List<FamilyRelationCategory> categories;

  bool get isEmpty => categories.every((c) => c.relations.isEmpty);

  /// [json] is the whole response body (`success`, `message`, `data`, ...).
  factory FamilyRelationsData.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    final data = raw is Map ? raw : const {};
    final cats = data['categories'];
    return FamilyRelationsData(
      categories: cats is List
          ? [
              for (final c in cats)
                if (c is Map)
                  FamilyRelationCategory.fromJson(Map<String, dynamic>.from(c)),
            ]
          : const [],
    );
  }
}
