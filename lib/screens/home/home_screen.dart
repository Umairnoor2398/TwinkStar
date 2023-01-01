import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:twinkstar/screens/home/main_screen.dart';
import 'package:twinkstar/extensions/custom_theme_extension.dart';
import 'package:twinkstar/screens/home/menu_screen.dart';

class HomeUIScreen extends StatefulWidget {
  const HomeUIScreen({Key? key}) : super(key: key);

  @override
  State<HomeUIScreen> createState() => _HomeUIScreenState();
}

class _HomeUIScreenState extends State<HomeUIScreen> {
  int screen = 0;

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      menuScreen: Builder(builder: (context) {
        return MenuScreen(onPageChanged: (a) {
          setState(() {
            screen = a;
          });
          ZoomDrawer.of(context)!.close();
        });
      }),
      mainScreen: MainScreen(idx: screen),
      borderRadius: 24.0,
      showShadow: true,
      drawerShadowsBackgroundColor: Colors.grey[300]!,
      menuBackgroundColor: context.theme.drawerColor!,
    );
  }
}
