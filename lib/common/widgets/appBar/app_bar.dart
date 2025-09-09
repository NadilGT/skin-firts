import 'package:flutter/material.dart';
import 'package:skin_firts/core/constants/color_manager.dart';

class BasicAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? action;
  final bool hideBack;
  const BasicAppbar({super.key, this.title, this.hideBack = false, this.action});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actionsPadding: EdgeInsets.only(right: 15),
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: title ?? Text(""),
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w700,
        color: AppColors.primaryColor,
        fontSize: 24,
        fontFamily: "LeagueSpartan"
      ),
      actions: [
        action ?? Container()
      ],
      centerTitle: true,
      leading: hideBack ? null : IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
