import 'package:flutter/material.dart';
import 'package:hotel_pms/core/resourses/size_manager.dart';




class CircledImage extends StatelessWidget {
  final double radius;
  final String networkImageUrl;

  CircledImage({
    Key? key,
    this.radius = AppBorderRadius.radius24,
    this.networkImageUrl = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return networkImageUrl == "" ? CircleAvatar(
      radius: radius,
      backgroundImage: AssetImage(networkImageUrl),
    ):CircleAvatar(
      radius: radius,
      backgroundImage: NetworkImage(networkImageUrl,scale: 1),
    );
  }
}
