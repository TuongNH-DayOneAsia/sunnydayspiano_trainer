import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';

abstract class BaseStatelessScreen extends StatelessWidget {
  final String? title;
  final double appBarHeight;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;
  const BaseStatelessScreen({
    super.key,
    this.title,
    this.appBarHeight = kToolbarHeight,
    this.automaticallyImplyLeading = true, this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarHeight),
        child: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            scrolledUnderElevation: 0,
            systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.dark,
                statusBarBrightness: Brightness.dark),
            elevation: 0,
            automaticallyImplyLeading: automaticallyImplyLeading,
            actions: actions,
            backgroundColor: MyColors.mainColor,
            title: title != null
                ? Text(
                    title!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null),
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext pageContext);
}
