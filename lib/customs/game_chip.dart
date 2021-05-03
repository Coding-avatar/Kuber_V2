import 'package:flutter/material.dart';

class GameChip extends StatelessWidget {
  final String gameName;
  final Color color;
  final String assetString;
  final double height;
  final double width;

  GameChip(
      {@required this.gameName,
      this.color,
      @required this.assetString,
      this.height,
      this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: height == null ? 110 : height,
      width: width == null ? 110 : width,
      child: Image.asset(assetString),
    );
  }
}
