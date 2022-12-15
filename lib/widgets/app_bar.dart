import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GameAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GameAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Mineslither'),
      centerTitle: true,
      leading: GoRouter.of(context).location != '/'
          ? IconButton(
              onPressed: () {
                GoRouter.of(context).go('/');
              },
              icon: const Icon(Icons.arrow_back),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
