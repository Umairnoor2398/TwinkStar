import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:twinkstar/screens/home/logout_screen.dart';
import 'package:twinkstar/screens/home/post_twink_screen.dart';
import 'package:twinkstar/screens/home/profile_screen.dart';
import 'package:twinkstar/screens/home/user_twink_screen.dart';
import 'package:twinkstar/screens/home/search_screen.dart';
import 'package:twinkstar/screens/home/twinks_screen.dart';
import 'package:twinkstar/screens/welcome/welcome_screen.dart';
import 'package:twinkstar/services/auth_services.dart';
import 'package:twinkstar/utils/utils.dart';

class HomeUIScreen extends StatefulWidget {
  const HomeUIScreen({Key? key}) : super(key: key);

  @override
  State<HomeUIScreen> createState() => _HomeUIScreenState();
}

class _HomeUIScreenState extends State<HomeUIScreen> {
  int screen = 0;

  @override
  Widget build(BuildContext context) {
    // Toast.showToast(UserInfoDL.currUser.email, Colors.blue);
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
      menuBackgroundColor: Colors.blue,
    );
  }
}

class MainScreen extends StatefulWidget {
  final int idx;
  static final CollectionReference users =
      FirebaseFirestore.instance.collection('Users');

  const MainScreen({Key? key, required this.idx}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final pages = <Widget>[
    const TwinksScreen(),
    const SearchScreen(),
    // ProfileScreen(),
    ProfileScreen(uid: AuthService().firebaseAuth.currentUser!.uid),
    UserTwinksScreen(
      userUid: AuthService().firebaseAuth.currentUser!.uid,
      twinksType: 'twinks',
    ),
    UserTwinksScreen(
      userUid: AuthService().firebaseAuth.currentUser!.uid,
      twinksType: 'likedTwinks',
    ),
    UserTwinksScreen(
      userUid: AuthService().firebaseAuth.currentUser!.uid,
      twinksType: 'savedTwinks',
    ),
    const CreateTwinkScreen(),
    const Logout(),
  ];

  final screen = [
    "Home",
    "Search",
    "Profile",
    "My Twinks",
    "Liked Twinks",
    "Saved Twinks",
    "Create Twink",
    ""
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          title: Text(screen[widget.idx]),
          centerTitle: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          leading: IconButton(
              onPressed: () => ZoomDrawer.of(context)!.toggle(),
              icon: const Icon(Icons.menu)),
        ),
      ),
      body: pages[widget.idx],
    );
  }
}

class MenuScreen extends StatefulWidget {
  final Function(int) onPageChanged;

  const MenuScreen({Key? key, required this.onPageChanged}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  List<ListItems> drawerItems = [
    ListItems(const Icon(Icons.home), const Text('Home'), 0),
    ListItems(const Icon(Icons.search), const Text('Search'), 1),
    ListItems(const Icon(Icons.person), const Text('Profile'), 2),
    ListItems(const Icon(Icons.access_time), const Text('My Twinks'), 3),
    ListItems(const Icon(Icons.favorite_border), const Text('Liked Twinks'), 4),
    ListItems(const Icon(Icons.bookmark_border), const Text('Saved Twinks'), 5),
    ListItems(const Icon(Icons.add), const Text('Create Twinks'), 6),
    ListItems(const Icon(Icons.logout), const Text('Log Out'), 7),
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Theme(
        data: ThemeData.dark(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: drawerItems
              .map((e) => ListTile(
                    onTap: () {
                      if (e.screen == 7) {
                        AuthService().signout();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const WelcomeScreen()));
                        Toast.showToast("Logged out", Colors.blue[300]!);
                      }
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

class ListItems {
  final Icon icon;
  final Text title;
  final int screen;

  ListItems(this.icon, this.title, this.screen);
}
