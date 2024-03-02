// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:invert_colors/invert_colors.dart';

import 'screens/start_screen.dart';
import 'screens/weightage_screen.dart';

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

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  ThemeMode _themeMode = ThemeMode.system;
  final pages = [StartPage(), WeightagePage()];
  int _index = 0;

  bool isFilled() {
    if (_index == 0) {
      final sp = pages[0] as StartPage;
      return sp.isFilled();
    } else if (_index == 1) {
      final wp = pages[1] as WeightagePage;
      return wp.isFilled();
    }
    return false;
  }

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
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: scr.width * 0.85,
                height: scr.height * 0.8,
                decoration: BoxDecoration(
                  // color: clr.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.fromBorderSide(BorderSide(color: Theme.of(context).colorScheme.onPrimary.withAlpha(50), width: 2))
                ), 
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return SlideTransition(
                      position: Tween<Offset>(begin: Offset(1, 0), end: Offset.zero).animate(animation),
                      child: child,
                    );
                  },
                  child: pages[_index],
                ),
              ),
              SizedBox(width: 16),
              SizedBox(height: scr.height * 0.8, child: buildNextButton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNextButton() {
    return ElevatedButton(
      onPressed: () {
        if (isFilled()) {
          debugPrint('All components are filled');
          setState(() => _index = _index == 0 ? 1 : 0);
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
      child: Icon(_index == 0
        ? Icons.arrow_forward_ios
        : Icons.arrow_back_ios),
    );
  }
}
