import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_tracker/core/constants.dart';
import 'package:location_tracker/feature/location_tracker/bloc/location_tracker_bloc.dart';
import 'package:location_tracker/feature/location_tracker/view/widgets/custom_alert_dialog.dart';
import 'package:location_tracker/feature/location_tracker/view/widgets/custom_appbar.dart';
import 'package:location_tracker/feature/location_tracker/view/widgets/page_progress_indicator.dart';

class LocationTrackerPage extends StatefulWidget {
  const LocationTrackerPage({super.key});

  @override
  _LocationTrackerPageState createState() => _LocationTrackerPageState();
}

class _LocationTrackerPageState extends State<LocationTrackerPage> {
  GoogleMapController? _controller;
  LatLng? _currentPosition;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
  }

  void _onMarkerTapped(LatLng position, BuildContext context) {
    BlocProvider.of<LocationTrackerBloc>(context)
        .add(LocationTrackerShowAddressEvent(latLng: position));
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationTrackerBloc(),
      child: BlocConsumer<LocationTrackerBloc, LocationTrackerState>(
        listenWhen: (previous, current) =>
            current is LocationtrackerActionState,
        buildWhen: (previous, current) =>
            current is! LocationtrackerActionState,
        listener: (context, state) {
          if (state is LocationTrackerShowAddressState) {
            showAlertDialog(
                context, TextItems.addressDialogTitle, state.address);
          } else if (state is LocationTrackerMissingSettingState) {
            showAlertDialog(context, state.title, state.message);
          } else if (state is LocationTrackerGpsEnabledState) {
            showGpsDialog(context);
          }
        },
        builder: (BuildContext context, LocationTrackerState state) {
          if (state is LocationTrackerTrackingState) {
            _currentPosition =
                state.locations.isNotEmpty ? state.locations.last : null;
            _markers = state.locations
                .map((loc) => Marker(
                      markerId: MarkerId(loc.toString()),
                      position: loc,
                      onTap: () => _onMarkerTapped(loc, context),
                    ))
                .toSet();

            if (_currentPosition != null && _controller != null) {
              _controller!.animateCamera(
                CameraUpdate.newLatLng(_currentPosition!),
              );
            }
            return Scaffold(
              appBar: customAppBar(),
              body: Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<LocationTrackerBloc>(context)
                                    .add(LocationTrackerStartEvent());
                              },
                              child: const Text("Başlat"),
                            ),
                            ElevatedButton(
                              onPressed: state.trackingActive
                                  ? () => BlocProvider.of<LocationTrackerBloc>(
                                          context)
                                      .add(LocationTrackerPauseEvent())
                                  : null,
                              child: const Text("Durdur"),
                            ),
                            ElevatedButton(
                              onPressed: state.trackingActive
                                  ? () => BlocProvider.of<LocationTrackerBloc>(
                                          context)
                                      .add(LocationTrackerResetEvent())
                                  : null,
                              child: const Text("Sıfırla"),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: GoogleMap(
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: state.currenPosition,
                            zoom: 15,
                          ),
                          markers: _markers,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                        ),
                      ),
                    ],
                  ),
                  if (!state.trackingActive)
                    Positioned(
                      top: 60,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                          child: Container(
                            color: Colors.black.withOpacity(0.01),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          } else {
            return const PageProgressIndicator();
          }
        },
      ),
    );
  }
}
