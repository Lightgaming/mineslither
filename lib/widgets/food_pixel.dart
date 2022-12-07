import 'package:flutter/material.dart';
import 'package:mineslither/utils/app_assets.dart';

class FoodPixel extends StatelessWidget {
  const FoodPixel({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(AppAssets.bomb);
  }
}
