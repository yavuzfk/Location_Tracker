import 'package:flutter/material.dart';
import 'package:location_tracker/feature/location_tracker/view/widgets/custom_appbar.dart';

class PageProgressIndicator extends StatelessWidget {
  const PageProgressIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      body: const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
