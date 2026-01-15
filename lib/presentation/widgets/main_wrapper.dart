import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'mini_player.dart';

class MainWrapper extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainWrapper({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,

      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          const MiniPlayer(),

          NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (index) {
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            },
            backgroundColor: Colors.black,
            indicatorColor: const Color(0xFF1db954),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home, color: Colors.grey),
                label: 'Home',
                selectedIcon: Icon(Icons.home, color: Colors.black),
              ),
              NavigationDestination(
                icon: Icon(Icons.search, color: Colors.grey),
                selectedIcon: Icon(Icons.search, color: Colors.black),
                label: 'Search',
              ),
              NavigationDestination(
                icon: Icon(Icons.library_music, color: Colors.grey),
                selectedIcon: Icon(Icons.library_music, color: Colors.black),
                label: 'Library',
              ),
              NavigationDestination(
                icon: Icon(Icons.person, color: Colors.grey),
                selectedIcon: Icon(Icons.person, color: Colors.black),
                label: 'Profile',
              ),
            ],
          ),
        ],
      ),
    );
  }
}