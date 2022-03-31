import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:myapp/ThemeColor/Color.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }
  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: SecondaryColor,
    backgroundColor: PrimaryColor,
    primaryColor: Colors.black,
    colorScheme: ColorScheme.dark(),
    iconTheme: IconThemeData(color: SecondaryColor, opacity: 0.8),
  );
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: PrimaryColor,
    inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
            borderSide: BorderSide(color: PrimaryColor)
        ),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: PrimaryColor)
      ),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: PrimaryColor)
      ),
      errorBorder: OutlineInputBorder(
        borderSide:BorderSide(color: Colors.red)
      ),
      errorStyle: TextStyle(fontSize: 0,height: 0),

    ),
    textSelectionTheme:TextSelectionThemeData(
      cursorColor: PrimaryColor,
      selectionHandleColor: PrimaryColor,
      selectionColor: PrimaryColor.withOpacity(0.5)
    ) ,
    primaryColor: TextColor,
    colorScheme: ColorScheme.light(),
    disabledColor: PrimaryColor,

    iconTheme: IconThemeData(color: SecondaryColor, opacity: 0.8),


  );
}