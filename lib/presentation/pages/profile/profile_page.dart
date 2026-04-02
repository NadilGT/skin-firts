import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_firts/common/bloc/theme_cubit.dart';
import 'package:skin_firts/presentation/pages/sign_in/sign_in.dart';

import '../check_doctor_available_screen/check_doctor_available_screen.dart';
import '../notification/notification.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userName = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      if (!mounted) return;
      final updatedUser = FirebaseAuth.instance.currentUser;
      setState(() {
        _userName = updatedUser?.displayName ?? 'No name';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? Theme.of(context).scaffoldBackgroundColor
          : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Profile',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1C2B4A),
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 8),

            // ── Profile hero section ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 28),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF1C2B4A),
                      primaryColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.30),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Avatar with edit button
                    Stack(
                      children: [
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.15),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.35),
                              width: 2.5,
                            ),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            size: 52,
                            color: Colors.white70,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.edit_rounded,
                              color: primaryColor,
                              size: 15,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    Text(
                      _userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      FirebaseAuth.instance.currentUser?.email ?? '',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ── Menu group 1: Account ────────────────────────────────
            _SectionLabel(label: 'Account'),
            _MenuCard(
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.person_outline_rounded,
                  title: 'Profile',
                  onTap: () {
                    
                  },
                ),
                _Divider(),
                _buildMenuItem(
                  context,
                  icon: Icons.calendar_today_outlined,
                  title: 'Check Doctor Availability',
                  iconColor: Colors.pinkAccent.shade100,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CheckDoctorAvailableScreen(),
                      ),
                    );
                  },
                ),
                _Divider(),
                _buildMenuItem(
                  context,
                  icon: Icons.notification_add,
                  title: 'Notifications',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationPage(),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Menu group 2: Preferences ────────────────────────────
            _SectionLabel(label: 'Preferences'),
            _MenuCard(
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.lock_outline_rounded,
                  title: 'Privacy Policy',
                  onTap: () {},
                ),
                _Divider(),
                _buildMenuItem(
                  context,
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () {},
                ),
                _Divider(),

                // Dark mode toggle — inline, same row style
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .primaryColor
                              .withOpacity(0.10),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          context.watch<ThemeCubit>().state.isDarkMode
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          color: Theme.of(context).primaryColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'Dark Mode',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).brightness ==
                                    Brightness.dark
                                ? Colors.white
                                : const Color(0xFF1C2B4A),
                          ),
                        ),
                      ),
                      Transform.scale(
                        scale: 0.85,
                        child: Switch(
                          value:
                              context.watch<ThemeCubit>().state.isDarkMode,
                          onChanged: (_) {
                            context.read<ThemeCubit>().toggleTheme();
                          },
                          activeColor: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),

                _Divider(),
                _buildMenuItem(
                  context,
                  icon: Icons.help_outline_rounded,
                  title: 'Help',
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Logout — standalone danger row ───────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.remove("email");
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignIn(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.07),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.red.withOpacity(0.18),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.logout_rounded,
                          color: Colors.redAccent,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: Colors.redAccent,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: (iconColor ?? Theme.of(context).primaryColor)
                    .withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor ?? Theme.of(context).primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : const Color(0xFF1C2B4A),
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 28, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade500,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final List<Widget> children;
  const _MenuCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Theme.of(context).cardColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.25 : 0.05),
              blurRadius: 18,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(children: children),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 72),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.grey.withOpacity(0.10),
      ),
    );
  }
}