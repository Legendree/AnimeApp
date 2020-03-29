import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'constants.dart';

class AdCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: Color(0xff252525),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: NativeAdmob(
              adUnitID: 'ca-app-pub-1171365882637205/4449905695',
              loading: Center(child: CircularProgressIndicator()),
              error: Center(
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                            "Oops, no ads here it seems :D".toUpperCase(),
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ))),
              options: kAdOptions),
        ),
      ),
    );
  }
}
