import 'package:flutter/material.dart';
import 'package:mineslither/utils/app_assets.dart';

class OpenPixel extends StatelessWidget {
  const OpenPixel({
    super.key,
    this.number,
    this.isBomb = false,
    this.isRevealed = false,
  });

  final int? number;

  final bool isBomb;
  final bool isRevealed;

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
    return Stack(
      children: [
        Container(
          child: (number != null && !(isBomb && isRevealed))
              ? getImageForNumber()
              : null,
        ),
        if (isBomb && isRevealed)
          Center(
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
              child: Image.asset(AppAssets.bomb),
            ),
          ),
      ],
    );
  }
}
