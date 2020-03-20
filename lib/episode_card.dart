import 'package:flutter/material.dart';

class EpsiodeCard extends StatelessWidget {
  EpsiodeCard({this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          
        },
        child: Container(
          decoration: BoxDecoration(color: Colors.white10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text('Episode ' + index.toString(),
                    style: TextStyle(color: Colors.white))),
          ),
        ),
      ),
    );
  }
}
