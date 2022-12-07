import 'package:flutter/material.dart';
import 'package:mineslither/utils/app_assets.dart';

class ClosedPixel extends StatelessWidget {
  const ClosedPixel({
    super.key,
    required this.onRightClick,
    required this.onLeftClick,
    this.isBomb = false,
    this.number,
  });

  final int? number;
  // is bomb
  final bool? isBomb;

  // on right click callback
  final VoidCallback onRightClick;
  // on left click callback
  final VoidCallback onLeftClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTap: () {
        onRightClick();
      },
      onTap: () {
        onLeftClick();
      },
      child: Stack(
        children: [
          Image.asset(AppAssets.facingDown),
          if (number != null)
            Center(
              child: Text(
                isBomb ?? false ? '*' : number.toString(),
              ),
            ),
        ],
      ),
    );
  }
}
