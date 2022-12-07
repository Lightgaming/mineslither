import 'package:flutter/material.dart';
import 'package:mineslither/utils/app_assets.dart';

class OpenPixel extends StatelessWidget {
  const OpenPixel({super.key, this.number});

  final int? number;

  Widget getImageForNumber() {
    switch (number!) {
      case 0:
        return Image.asset(AppAssets.zero);
      case 1:
        return Image.asset(AppAssets.one);
      case 2:
        return Image.asset(AppAssets.two);
      case 3:
        return Image.asset(AppAssets.three);
      case 4:
        return Image.asset(AppAssets.four);
      case 5:
        return Image.asset(AppAssets.five);
      case 6:
        return Image.asset(AppAssets.six);
      case 7:
        return Image.asset(AppAssets.seven);
      case 8:
        return Image.asset(AppAssets.eight);
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (number != null) ? getImageForNumber() : null,
    );
  }
}
