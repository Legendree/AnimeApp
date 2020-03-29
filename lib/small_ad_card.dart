import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:animist/constants.dart';

class SmallAdCard extends StatefulWidget {
  @override
  _SmallAdCardState createState() => _SmallAdCardState();
}

class _SmallAdCardState extends State<SmallAdCard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      width: 170,
      height: 220,
      color: Color(0xff252525),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: NativeAdmob(
            adUnitID: 'ca-app-pub-1171365882637205/7202973804',
            loading: Center(child: CircularProgressIndicator()),
            error: Center(child: Icon(Icons.error_outline)),
            options: kAdOptions),
      ),
    );
  }
}
