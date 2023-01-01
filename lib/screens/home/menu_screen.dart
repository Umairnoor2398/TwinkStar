import 'package:flutter/material.dart';
import 'package:twinkstar/extensions/custom_theme_extension.dart';
import 'package:twinkstar/screens/home/menu_list_items.dart';

class MenuScreen extends StatefulWidget {
  final Function(int) onPageChanged;

  const MenuScreen({Key? key, required this.onPageChanged}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<MenuListItem> drawerItems = [
    MenuListItem(const Icon(Icons.home), const Text('Home'), 0),
    MenuListItem(const Icon(Icons.search), const Text('Search'), 1),
    MenuListItem(const Icon(Icons.person), const Text('Profile'), 2),
    MenuListItem(const Icon(Icons.access_time), const Text('My Twinks'), 3),
    MenuListItem(
        const Icon(Icons.favorite_border), const Text('Liked Twinks'), 4),
    MenuListItem(
        const Icon(Icons.bookmark_border), const Text('Saved Twinks'), 5),
    MenuListItem(const Icon(Icons.add), const Text('Create Twinks'), 6),
    MenuListItem(const Icon(Icons.logout), const Text('Log Out'), 7),
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.drawerColor!,
      body: Theme(
        data: ThemeData.dark(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: drawerItems
              .map((e) => ListTile(
                    onTap: () {
                      widget.onPageChanged(e.screen);
                    },
                    title: e.title,
                    leading: e.icon,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
