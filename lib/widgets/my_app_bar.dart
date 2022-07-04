import 'package:flutter/material.dart';
import 'package:memorizer/settings/Themes.dart';
import 'package:provider/provider.dart';

class MyAppBar {
  late final String input;
  List<Widget> actions;
  BuildContext context;

  MyAppBar({required this.input, required this.actions, required this.context});

  AppBar get() {
    const themeButton = ChangeThemeButtonWidget();
    actions.add(const SizedBox(width: 3));
    actions.add(themeButton);

    return AppBar(
      actions: actions,
      title: Text(input),
    );
  }
}

class ChangeThemeButtonWidget extends StatelessWidget {
  const ChangeThemeButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Switch.adaptive(
      value: themeProvider.isDarkMode,
      onChanged: (value) {
        final provider = Provider.of<ThemeProvider>(context, listen: false);
        provider.toggleTheme(value);
      },
    );
  }
}
