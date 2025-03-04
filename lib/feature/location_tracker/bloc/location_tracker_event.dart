part of 'location_tracker_bloc.dart';

@immutable
sealed class LocationTrackerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LocationTrackerStartEvent extends LocationTrackerEvent {}

class LocationTrackerPauseEvent extends LocationTrackerEvent {}

class LocationTrackerResetEvent extends LocationTrackerEvent {}

class LocationTrackerShowAddressEvent extends LocationTrackerEvent {
  final LatLng latLng;

  LocationTrackerShowAddressEvent({required this.latLng});

  @override
  List<Object> get props => [latLng];
}

class LocationTrackerLocationUpdateEvent extends LocationTrackerEvent {
  final Position position;

  LocationTrackerLocationUpdateEvent({required this.position});

  @override
  List<Object> get props => [position];
}
