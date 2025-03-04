import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:location_tracker/core/constants.dart';
import 'package:location_tracker/services/local_storage/hive_manager.dart';
import 'package:meta/meta.dart';

part 'location_tracker_event.dart';
part 'location_tracker_state.dart';

class LocationTrackerBloc
    extends Bloc<LocationTrackerEvent, LocationTrackerState> {
  LocationTrackerBloc() : super(LocationTrackerInitialState()) {
    on<LocationTrackerStartEvent>(_startEvent);
    on<LocationTrackerPauseEvent>(_pauseEvent);
    on<LocationTrackerResetEvent>(_resetEvent);
    on<LocationTrackerShowAddressEvent>(_showAddressEvent);
    on<LocationTrackerLocationUpdateEvent>(_locationUpdateEvent);

    add(LocationTrackerStartEvent());
  }

  StreamSubscription<Position>? _positionStream;

  List<LatLng> _markers = [];
  LatLng _defaultLocation =
      const LatLng(DefaultLocation.latitude, DefaultLocation.longitude);

  FutureOr<void> _startEvent(LocationTrackerStartEvent event,
      Emitter<LocationTrackerState> emit) async {
    bool gpsEnabled = await Geolocator.isLocationServiceEnabled();
    if (!gpsEnabled) {
      emit(LocationTrackerGpsEnabledState());
      return;
    }
    bool locaitonEnabled = await Geolocator.isLocationServiceEnabled();
    if (!locaitonEnabled) {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(LocationTrackerMissingSettingState(
              title: ErrorMessages.locationErrorTitle,
              message: ErrorMessages.locationErrorMessage));
          return;
        }
      }
    }

    bool internetConnecedted = await InternetConnectionChecker().hasConnection;
    if (!internetConnecedted) {
      emit(LocationTrackerMissingSettingState(
          title: ErrorMessages.internetErrorTitle,
          message: ErrorMessages.internetErrorMessage));
      return;
    }
    _loadMarkersFromHive();

    Position currentPosition = await Geolocator.getCurrentPosition();
    _defaultLocation =
        LatLng(currentPosition.latitude, currentPosition.longitude);
    if (_markers.isEmpty) {
      add(LocationTrackerLocationUpdateEvent(position: currentPosition));
    }

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: DefaultLocation.distanceFilter,
      ),
    ).listen((Position position) {
      add(LocationTrackerLocationUpdateEvent(position: position));
    });

    emit(LocationTrackerTrackingState(
        locations: _markers,
        currenPosition: _defaultLocation,
        trackingActive: true));
  }

  FutureOr<void> _pauseEvent(
      LocationTrackerPauseEvent event, Emitter<LocationTrackerState> emit) {
    _positionStream?.cancel();
    emit(LocationTrackerTrackingState(
        locations: _markers,
        currenPosition: _defaultLocation,
        trackingActive: false));
  }

  FutureOr<void> _resetEvent(
      LocationTrackerResetEvent event, Emitter<LocationTrackerState> emit) {
    HiveManager.hiveDeleteAll();
    _markers.clear();
    emit(LocationTrackerTrackingState(
        locations: _markers,
        currenPosition: _defaultLocation,
        trackingActive: true));
  }

  FutureOr<void> _showAddressEvent(LocationTrackerShowAddressEvent event,
      Emitter<LocationTrackerState> emit) async {
    emit(LocationTrackerShowAddressState(
        address: await _getAddressFromLatLng(event.latLng)));
  }

  FutureOr<void> _locationUpdateEvent(LocationTrackerLocationUpdateEvent event,
      Emitter<LocationTrackerState> emit) {
    final position = event.position;
    LatLng newLocation = LatLng(position.latitude, position.longitude);

    List<LatLng> markers = List<LatLng>.from(HiveManager.hiveRead());

    markers.add(newLocation);
    _markers = markers;
    HiveManager.hiveWrite(markers);

    emit(LocationTrackerTrackingState(
        locations: markers,
        currenPosition: _defaultLocation,
        trackingActive: true));
  }

  void _loadMarkersFromHive() {
    List<LatLng> storedMarkers = List<LatLng>.from(HiveManager.hiveRead());
    _markers = storedMarkers;
  }

  Future<String> _getAddressFromLatLng(LatLng position) async {
    //TODO: Create placemark model
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      return placemarks.isNotEmpty
          ? "${placemarks.first.thoroughfare}, ${placemarks.first.subThoroughfare}, ${placemarks.first.subLocality}, ${placemarks.first.subAdministrativeArea}, ${placemarks.first.administrativeArea}"
          : "Adres bulunamadı";
    } catch (e) {
      return "Hata: $e";
    }
  }
}
