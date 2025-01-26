import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/Controller/local_data.dart';
import 'package:task_manager/Controller/tasks_controller.dart';
import 'package:task_manager/Controller/theme_controller.dart';
import 'package:task_manager/View/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalData.startDatabase();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) {
              return TasksController();
            },
          ),
          ChangeNotifierProvider(create: (context) {
            return ThemeController();
          })
        ],
        child: Consumer<ThemeController>(
          builder: (context, themeController, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              darkTheme: darkTheme(),
              theme: lightTheme(),
              themeMode: (themeController.darkTheme)
                  ? ThemeMode.dark
                  : ThemeMode.light,
              home: const MainScreen(),
            );
          },
        ));
  }

  ThemeData? lightTheme() {
    return ThemeData(
        canvasColor: Color.fromRGBO(240, 249, 254, 1),
        cardColor: Colors.blueAccent,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          splashColor: Colors.blueAccent.shade700,
          foregroundColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(
                color: Color.fromRGBO(49, 49, 49, 0.5),
                width: 2,
              )),
        ),
        textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: Color.fromRGBO(49, 49, 49, 0.5),
        ),
        datePickerTheme: const DatePickerThemeData(
            backgroundColor: Color.fromRGBO(240, 249, 254, 1),
            dividerColor: Colors.blueAccent,
            headerBackgroundColor: Colors.blueAccent,
            headerForegroundColor: Colors.white),
        timePickerTheme: TimePickerThemeData(
            backgroundColor: Color.fromRGBO(240, 249, 254, 1),
            dialHandColor: Colors.blueGrey[200],
            hourMinuteColor: Colors.blueAccent,
            dayPeriodColor: Colors.blueAccent,
            dayPeriodTextColor: Colors.black,
            entryModeIconColor: Colors.blueAccent,
            dialBackgroundColor: Colors.white,
            dialTextColor: Colors.blueAccent,
            timeSelectorSeparatorColor:
                WidgetStatePropertyAll(Colors.blueAccent),
            hourMinuteTextColor: Colors.white),
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
            centerTitle: true,
            titleTextStyle: GoogleFonts.merriweather(
                fontSize: 25,
                fontWeight: FontWeight.w900,
                color: Colors.white)),
        textTheme: TextTheme(
          labelSmall: GoogleFonts.merriweather(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(49, 49, 49, 0.5)),
          labelMedium: GoogleFonts.merriweather(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
          displayLarge: GoogleFonts.merriweather(
              fontSize: 25, fontWeight: FontWeight.w900, color: Colors.white),
          displayMedium: GoogleFonts.merriweather(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
          displaySmall: GoogleFonts.merriweather(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(49, 49, 49, 0.5)),
        ));
  }

  ThemeData? darkTheme() {
    return ThemeData(
      canvasColor: Colors.grey[900],
      cardColor: Colors.black,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(
              color: Color.fromRGBO(49, 49, 49, 0.5),
              width: 2,
            )),
      ),
      datePickerTheme: DatePickerThemeData(
          rangePickerHeaderForegroundColor: Colors.white,
          headerForegroundColor: Colors.white,
          headerBackgroundColor: Colors.black),
      timePickerTheme: TimePickerThemeData(
          backgroundColor: Color.fromRGBO(240, 249, 254, 1),
          dialHandColor: Colors.blueGrey[200],
          hourMinuteColor: Colors.black,
          dayPeriodColor: Colors.black,
          dayPeriodTextColor: Colors.grey[50],
          entryModeIconColor: Colors.black,
          dialBackgroundColor: Colors.white,
          dialTextColor: Colors.black,
          timeSelectorSeparatorColor: WidgetStatePropertyAll(Colors.black),
          confirmButtonStyle: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(Colors.black)),
          cancelButtonStyle: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(Colors.black)),
          hourMinuteTextColor: Colors.white),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
        titleTextStyle: GoogleFonts.merriweather(
          fontSize: 25,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionHandleColor: Color.fromRGBO(49, 49, 49, 0.5),
      ),
      textTheme: TextTheme(
        labelMedium: GoogleFonts.merriweather(
            fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
        labelSmall: GoogleFonts.merriweather(
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black),
        displayLarge: GoogleFonts.merriweather(
          fontSize: 25,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
        displayMedium: GoogleFonts.merriweather(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        displaySmall: GoogleFonts.merriweather(
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white),
      ),
    );
  }
}
