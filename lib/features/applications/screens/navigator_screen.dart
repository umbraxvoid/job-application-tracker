import 'package:flutter/material.dart';
import 'package:job_application_tracker/features/applications/screens/applications_screen.dart';
import 'package:job_application_tracker/features/applications/screens/dash_board_screen.dart';

class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({super.key});

  @override
  State<NavigatorScreen> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  int selectedIndex = 0;

  // List of screens corresponding to bottom navigation bar items
  final List<Widget> screens = const [ApplicationsScreen(), DashBoardScreen()];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Handle hardware back button press to prevent exiting the app from Dashboard
      canPop: selectedIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (selectedIndex != 0) {
          setState(() {
            selectedIndex = 0;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: IndexedStack(index: selectedIndex, children: screens),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: const Color(0xFFE5E7EB), width: 1),
            ),
          ),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: Colors.white,
              indicatorColor: const Color(
                0xFFEFF6FF,
              ), // Subtle active highlight
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1769FF),
                  );
                }
                return const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6B7280),
                );
              }),
            ),
            child: NavigationBar(
              height: 70,
              elevation: 0,
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(
                    Icons.work_outline_rounded,
                    color: Color(0xFF6B7280),
                  ),
                  selectedIcon: Icon(
                    Icons.work_rounded,
                    color: Color(0xFF1769FF),
                  ),
                  label: 'Applications',
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.dashboard_outlined,
                    color: Color(0xFF6B7280),
                  ),
                  selectedIcon: Icon(
                    Icons.dashboard_rounded,
                    color: Color(0xFF1769FF),
                  ),
                  label: 'Dashboard',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
