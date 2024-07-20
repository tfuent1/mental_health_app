import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const NavBar({
    Key? key,
    required this.onItemTapped,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  void _onItemTapped(int index) {
    widget.onItemTapped(index);
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: widget.selectedIndex,
      onDestinationSelected: _onItemTapped,
      destinations: const <NavigationDestination>[
        NavigationDestination(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.mood),
          label: 'Emotions',
        ),
        NavigationDestination(
          icon: Icon(Icons.book),
          label: 'Journal',
        ),
        NavigationDestination(
          icon: Icon(Icons.check_circle),
          label: 'Duties',
        ),
        NavigationDestination(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
