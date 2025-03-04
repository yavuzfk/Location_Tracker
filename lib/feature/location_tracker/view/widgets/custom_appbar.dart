import 'package:flutter/material.dart';
import 'package:location_tracker/core/constants.dart';

PreferredSizeWidget customAppBar() {
  return AppBar(
    title: const Text(TextItems.appbarTitle),
    centerTitle: true,
  );
}
