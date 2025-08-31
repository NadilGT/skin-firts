import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skin_firts/common/widgets/appBar/app_bar.dart';
import 'package:skin_firts/common/widgets/button/basic_app_button.dart';
import 'package:skin_firts/core/constants/color_manager.dart';
import 'package:skin_firts/core/constants/text_manager.dart';
import 'package:skin_firts/data/models/login_user_model/login_user_model.dart';
import 'package:skin_firts/presentation/pages/sign_in/sign_in_cubit/sign_in_cubit.dart';
import 'package:skin_firts/presentation/pages/sign_in/sign_in_cubit/sign_in_state.dart';
import 'package:skin_firts/presentation/pages/welcome_screen/welcome_screen.dart';

class SignIn extends StatelessWidget {
  SignIn({super.key});

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInCubit(),
      child: Scaffold(
        appBar: BasicAppbar(title: Text("Log In")),
        body: BlocConsumer<SignInCubit, SignInState>(
          listener: (context, state) {
            if (state is SignInSuccess) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WelcomeScreen()),
              );
            } else if (state is SignInFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome",
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      TextManager.welcomeText,
                      style: TextStyle(
                        color: AppColors.welcomeTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 50),
                    Text(
                      "Email or Mobile Number",
                      style: TextStyle(
                        color: AppColors.welcomeTextColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 15),
                    _emailField(context),
                    SizedBox(height: 20),
                    Text(
                      "Password",
                      style: TextStyle(
                        color: AppColors.welcomeTextColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 15),
                    _passwordField(context),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Forget Password",
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        state is SignInLoading
                            ? Center(child: CircularProgressIndicator(color: AppColors.primaryColor,))
                            : BasicAppButton(
                                onPressed: () {
                                  context.read<SignInCubit>().signIn(
                                    LoginUserModel(
                                      email: _email.text.trim(),
                                      password: _password.text.trim(),
                                    ),
                                  );
                                },
                                title: "Log In",
                              ),
                        SizedBox(height: 15),
                        Text("or sign up with"),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _signUpOptions("assets/images/google.svg"),
                            SizedBox(width: 10),
                            _signUpOptions("assets/images/facebook.svg"),
                            SizedBox(width: 10),
                            _signUpOptions("assets/images/fingerprint.svg"),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account?"),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "Sign Up",
                                style: TextStyle(color: AppColors.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _emailField(BuildContext context) {
    return TextField(
      controller: _email,
      decoration: InputDecoration(
        hintText: 'Enter Email',
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
      controller: _password,
      decoration: InputDecoration(
        hintText: 'Password',
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _signUpOptions(String icon) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.lightBlue,
      ),
      width: 50,
      height: 50,
      child: SvgPicture.asset(icon),
    );
  }
}
