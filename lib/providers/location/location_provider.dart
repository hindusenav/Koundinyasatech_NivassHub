import 'package:flutter/foundation.dart';
import 'package:flutter_nivasshub/models/location/location_level.dart';
import 'package:flutter_nivasshub/models/location/location_node.dart';
import 'package:flutter_nivasshub/models/location/location_selection.dart';
import 'package:flutter_nivasshub/services/location/location_service_base.dart';

/// Per-level load state, mirroring `DashboardState`'s shape.
enum LocationLoadState { initial, loading, success, empty, error }

/// Drives the Country → State → City → Society → Tower → Floor → Flat
/// cascade.
///
/// Screen-scoped, not global: a global instance would keep a fully
/// populated cascade alive for the whole authenticated session and
/// re-show the previous user's selections after a logout.
class LocationProvider extends ChangeNotifier {
  LocationProvider(LocationServiceBase service) : _service = service;

  final LocationServiceBase _service;

  final Map<LocationLevel, List<LocationNode>> _options = {};
  final Map<LocationLevel, LocationNode?> _selected = {};
  final Map<LocationLevel, LocationLoadState> _state = {};
  final Map<LocationLevel, String?> _errors = {};

  List<String> _subBranches = const [];
  bool _isLoadingSubBranches = false;
  String? _subBranchError;

  List<LocationNode> optionsFor(LocationLevel level) =>
      _options[level] ?? const [];

  LocationNode? selectedFor(LocationLevel level) => _selected[level];

  LocationLoadState stateFor(LocationLevel level) =>
      _state[level] ?? LocationLoadState.initial;

  String? errorFor(LocationLevel level) => _errors[level];

  bool isLoading(LocationLevel level) =>
      stateFor(level) == LocationLoadState.loading;

  List<String> get subBranches => _subBranches;
  bool get isLoadingSubBranches => _isLoadingSubBranches;
  String? get subBranchError => _subBranchError;

  /// A level is selectable once its parent has been chosen. Country has no
  /// parent, so it is always open.
  bool isEnabled(LocationLevel level) =>
      level == LocationLevel.country || _selected[level.previous!] != null;

  LocationSelection get selection => LocationSelection.fromMap(_selected);

  bool get isComplete => selection.isComplete;

  /// Loads a level's options. The parent's id is read from the current
  /// selection, so callers never have to thread it through.
  Future<void> load(LocationLevel level) async {
    final parent = level.previous;
    final parentId = parent == null ? null : _selected[parent]?.id;

    // Asking for a child of nothing is a no-op, not an error — it happens
    // transiently while a reset is in flight.
    if (parent != null && parentId == null) return;

    _state[level] = LocationLoadState.loading;
    _errors[level] = null;
    notifyListeners();

    final response = await _service.getLocations(
      level: level,
      parentId: parentId,
    );

    // `ApiResponse.success(null)` is legal — `data` is nullable — so
    // success alone is not enough to dereference it.
    if (response.isSuccess && response.data != null) {
      final nodes = response.data!;
      _options[level] = nodes;
      _state[level] = nodes.isEmpty
          ? LocationLoadState.empty
          : LocationLoadState.success;
    } else {
      _options[level] = const [];
      _errors[level] = response.message;
      _state[level] = LocationLoadState.error;
    }

    notifyListeners();
  }

  /// Records a choice and clears everything downstream of it.
  ///
  /// The reset walks `LocationLevel.values.skip(level.index + 1)` rather
  /// than naming each child, so adding an eighth level needs no change
  /// here and no level can be missed — which is exactly the bug six
  /// hand-written null assignments per parent would invite.
  Future<void> select(LocationLevel level, LocationNode node) async {
    if (_selected[level] == node) return;

    _selected[level] = node;

    for (final child in LocationLevel.values.skip(level.index + 1)) {
      _selected.remove(child);
      _options[child] = const [];
      _state[child] = LocationLoadState.initial;
      _errors[child] = null;
    }
    notifyListeners();

    final next = level.next;
    if (next != null) await load(next);
  }

  /// Re-runs a failed level. Bound to the picker's Retry action.
  Future<void> retry(LocationLevel level) => load(level);

  Future<void> loadSubBranches() async {
    _isLoadingSubBranches = true;
    _subBranchError = null;
    notifyListeners();

    final response = await _service.getSubBranches();
    if (response.isSuccess && response.data != null) {
      _subBranches = response.data!;
    } else {
      _subBranches = const [];
      _subBranchError = response.message;
    }

    _isLoadingSubBranches = false;
    notifyListeners();
  }
}
