import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

//TODO: colours and styles must be specified in the theme.

void showAlertDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        titlePadding: EdgeInsets.zero,
        content: Text(
          message,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Tamam"),
          ),
        ],
      );
    },
  );
}

void showGpsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Konum Servisi Kapalı"),
      content: const Text("Konum servisini açmanız gerekiyor."),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            await Geolocator.openLocationSettings(); // GPS ayarlarına yönlendir
          },
          child: const Text("Ayarları Aç"),
        ),
      ],
    ),
  );
}
