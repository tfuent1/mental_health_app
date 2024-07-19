import 'package:flutter/material.dart';

class NavigationWidget extends StatefulWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const NavigationWidget({
    Key? key,
    required this.onItemTapped,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  _NavigationWidgetState createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
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
