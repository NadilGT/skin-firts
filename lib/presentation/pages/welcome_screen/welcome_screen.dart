import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skin_firts/common/widgets/button/basic_app_button.dart';
import 'package:skin_firts/presentation/pages/sign_in/sign_in.dart';

import '../../../core/constants/color_manager.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/images/blue_logo.svg"),
            SizedBox(height: 15),
            Text(
              "Skin Firts",
              style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w300,
                fontSize: 48,
              ),
            ),
            Text(
              "Dermatology center",
              style: TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ",
                style: TextStyle(
                  color: AppColors.welcomeTextColor,
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30),
            BasicAppButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));
            }, title: "Log In"),
            SizedBox(height: 10),
            BasicAppButton(
              onPressed: () {},
              bgColor: AppColors.lightBlue,
              textColor: AppColors.primaryColor,
              title: "Sign Up"),
          ],
        ),
      ),
    );
  }
}
