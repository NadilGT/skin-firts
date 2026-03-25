import 'package:flutter/material.dart';
import 'package:skin_firts/presentation/pages/calender/calender_page.dart';
import 'package:skin_firts/presentation/pages/home/home.dart';
import 'package:skin_firts/presentation/pages/profile/profile_page.dart';

import 'package:skin_firts/presentation/pages/messages/messages_page.dart';

import '../../../presentation/pages/find_running_appointment_page/find_running_appointment_page.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;

  const MainNavigation({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _selectedIndex;

  final List<Widget> _pages = [
    Home(),
    const FindRunningAppointmentPage(),
    const ProfilePage(),
    const CalendarPage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    final inactiveColor = isDarkMode ? Colors.grey.shade500 : Colors.grey.shade400;

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 70,
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(35),
            boxShadow: [
              BoxShadow(
                color: isDarkMode 
                    ? Colors.black.withOpacity(0.3) 
                    : Colors.black.withOpacity(0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_pages.length, (index) {
              final isSelected = _selectedIndex == index;
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? primaryColor.withOpacity(0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getIconForIndex(index),
                        color: isSelected ? primaryColor : inactiveColor,
                        size: 24,
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 8),
                        Text(
                          _getLabelForIndex(index),
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.home_rounded;
      case 1:
        return Icons.live_tv_rounded;
      case 2:
        return Icons.person_rounded;
      case 3:
        return Icons.calendar_today_rounded;
      default:
        return Icons.home_rounded;
    }
  }

  String _getLabelForIndex(int index) {
    switch (index) {
      case 0:
        return "Home";
      case 1:
        return "Live Appointment";
      case 2:
        return "Profile";
      case 3:
        return "Calendar";
      default:
        return "Home";
    }
  }
}