import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBarWithBackBtn extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final String? route;
  const AppBarWithBackBtn(
      {super.key, required this.title, this.actions, this.route});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          if (route != null) {
            GoRouter.of(context).go(route!);
          }

          GoRouter.of(context).pop();
        },
      ),
      title: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          title,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      actions: actions,
      elevation: 2,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
  color:Color(0xffFEFEFE),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: const Color(0xff2E3A46),
          height: 1.0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
