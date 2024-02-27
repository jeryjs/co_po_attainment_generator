// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:invert_colors/invert_colors.dart';

import 'screens/start_screen.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  final pages = [StartPage()];

  @override
  Widget build(BuildContext context) {
    final scr = MediaQuery.of(context).size;

    return MaterialApp(
      title: 'CO-PO-Attainment',
      theme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF031C53))),
      darkTheme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color(0xFF031C53), brightness: Brightness.dark)),
      themeMode: _themeMode,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 90,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.webp',height: 85,width: 85,fit: BoxFit.cover,alignment: Alignment.centerLeft),
              _themeMode != ThemeMode.light
                ? InvertColors(child: Image.asset('assets/logo.webp',height: 85,width: 380,fit: BoxFit.cover,alignment: Alignment.centerRight))
                : Image.asset('assets/logo.webp',height: 85,width: 380,fit: BoxFit.cover,alignment: Alignment.centerRight),
            ],
          ),
          actions: [
            Switch(
              value: _themeMode != ThemeMode.light,
              onChanged: (value) => setState(
                  () => _themeMode = value ? ThemeMode.dark : ThemeMode.light),
              thumbIcon: MaterialStateProperty.all<Icon?>(
                Icon(_themeMode != ThemeMode.light
                    ? Icons.dark_mode
                    : Icons.light_mode),
              ),
            ),
          ],
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            pages[0],
            SizedBox(width: 16),
            SizedBox(height: scr.height * 0.8, child: buildNextButton()),
          ],
        ),
      ),
    );
  }

  bool isFilled() {
    return pages[0].isFilled();
  }

  Widget buildNextButton() {
    return ElevatedButton(
      onPressed: () {
        if (isFilled()) {
          debugPrint('All components are filled');
          // Navigator.push(context, MaterialPageRoute(builder: (context) => ));
        } else {
          debugPrint('Some components are not filled');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Missing Required Fields'),
                content: Text('Please fill all the fields.'),
                actions: [
                  TextButton(
                    autofocus: true,
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      },
      child: Icon(Icons.arrow_forward_ios),
    );
  }
}
