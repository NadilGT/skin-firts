import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skin_firts/common/widgets/appBar/app_bar.dart';
import 'package:skin_firts/common/widgets/button/basic_app_button.dart';
import 'package:skin_firts/core/constants/color_manager.dart';
import 'package:skin_firts/data/models/sign_up_user_model/sign_up_user_model.dart';
import 'package:skin_firts/presentation/pages/home/home.dart';
import 'package:skin_firts/presentation/pages/sign_up/sign_up_cubit/sign_up_cubit.dart';
import 'package:skin_firts/presentation/pages/sign_up/sign_up_cubit/sign_up_state.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: Scaffold(
        appBar: BasicAppbar(title: Text("Sign Up")),
        body: BlocConsumer<SignUpCubit, SignUpState>(
          listener: (context, state) {
            if (state is SignUpSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Home()),
                (route) => false,
              );
            } else if (state is SignUpFailure) {
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
                      "Create Account",
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 50),
                    Text(
                      "Full Name",
                      style: TextStyle(
                        color: AppColors.welcomeTextColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 15),
                    _nameField(context),
                    SizedBox(height: 20),
                    Text(
                      "Email",
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
                    SizedBox(height: 40),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        state is SignUpLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                ),
                              )
                            : BasicAppButton(
                                onPressed: () {
                                  context.read<SignUpCubit>().signUp(
                                    SignUpUserModel(
                                      name: _name.text.trim(),
                                      email: _email.text.trim(),
                                      password: _password.text.trim(),
                                    ),
                                  );
                                },
                                title: "Sign Up",
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

  Widget _nameField(BuildContext context) {
    return TextField(
      controller: _name,
      decoration: InputDecoration(
        hintText: 'Enter Full Name',
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
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
}
