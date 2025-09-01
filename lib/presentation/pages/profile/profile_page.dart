import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skin_firts/common/widgets/button/basic_app_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BasicAppButton(
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            prefs.remove("email");
          },
          title: "Log out",
        ),
      ),
    );
  }
}
