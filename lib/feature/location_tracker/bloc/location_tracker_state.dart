part of 'location_tracker_bloc.dart';

@immutable
sealed class LocationTrackerState extends Equatable {
  @override
  List<Object> get props => [];
}

@immutable
sealed class LocationtrackerActionState extends LocationTrackerState {
  @override
  List<Object> get props => [];
}

final class LocationTrackerInitialState extends LocationTrackerState {}

final class LocationTrackerTrackingState extends LocationTrackerState {
  final List<LatLng> locations;
  final LatLng currenPosition;
  final bool trackingActive;
  LocationTrackerTrackingState(
      {required this.trackingActive,
      required this.currenPosition,
      required this.locations});

  @override
  List<Object> get props => [locations, currenPosition, trackingActive];
}

final class LocationTrackerShowAddressState extends LocationtrackerActionState {
  final String address;
  LocationTrackerShowAddressState({required this.address});

  @override
  List<Object> get props => [address];
}

final class LocationTrackerErrorState extends LocationtrackerActionState {
  final String message;
  LocationTrackerErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

final class LocationTrackerMissingSettingState
    extends LocationtrackerActionState {
  final String title;
  final String message;
  LocationTrackerMissingSettingState(
      {required this.title, required this.message});
  @override
  List<Object> get props => [title, message];
}

final class LocationTrackerGpsEnabledState extends LocationtrackerActionState {}
