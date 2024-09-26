// ignore_for_file: use_key_in_widget_constructors, unnecessary_this, file_names, prefer_const_constructors_in_immutables, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final ShapeBorder? shapeBorder;
  final EdgeInsetsGeometry? margin;

  ShimmerWidget.rectangular(
      {this.width = double.infinity,
      required this.height,
      this.shapeBorder,
      this.margin});

  ShimmerWidget.circular(
      {this.width,
      this.height,
      this.margin,
      this.shapeBorder = const CircleBorder()});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[400]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: ShapeDecoration(
            shape: shapeBorder ?? const RoundedRectangleBorder(),
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.2)),
      ),
    );
  }
}
