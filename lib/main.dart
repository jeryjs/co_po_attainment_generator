import 'package:flutter/material.dart';
import 'package:invert_colors/invert_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/widgets.dart';
import 'constants.dart';
import 'screens/1_DetailsPage/details_screen.dart';
import 'screens/2_WeightagePage/weightage_screen.dart';
import 'screens/3_GeneratePage/generate_screen.dart';

/// The main entry point of the application.
/// It initializes the necessary dependencies and runs the app.
void main() async {
	WidgetsFlutterBinding.ensureInitialized();
	SharedPreferences prefs = await SharedPreferences.getInstance();
	ThemeMode themeMode = ThemeMode.values[prefs.getInt('themeMode') ?? 0];
	runApp(MaterialApp(home: MainApp(themeMode: themeMode)));
}

/// The main application widget.
/// It manages the state of the app and displays the appropriate screens.
class MainApp extends StatefulWidget {
	final ThemeMode themeMode;

	const MainApp({super.key, required this.themeMode});

	@override
	State<MainApp> createState() => _MainAppState();
}

/// The state class for the main app widget.
class _MainAppState extends State<MainApp> {
	late ThemeMode themeMode;
	int index = 0;
	final pages = [DetailsPage(), WeightagePage(), const GeneratePage()];

	/// Returns the currently displayed page.
	dynamic currentPage() {
		return pages[index];
	}

	/// Checks if the current page and its widgets are filled.
	bool isFilled() {
		return currentPage().isFilled();
	}

	/// Toggles the theme mode between light and dark.
	/// Saves the selected theme mode to shared preferences.
	void _toggleThemeMode() async {
		setState(() => themeMode =
			themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
		final prefs = await SharedPreferences.getInstance();
		prefs.setInt('themeMode', themeMode.index);
	}

	@override
	void initState() {
		super.initState();
		themeMode = widget.themeMode;
	}

	/// Builds the main user interface of the app, which includes a MaterialApp with
	/// light and dark themes. The Appbar is a fixed compponent, static throughout the app.
	/// The body's container acts as a navigation between the app's pages, while the NextButton
	/// button is for navigating to the next page.
	@override
	Widget build(BuildContext context) {
		final scr = MediaQuery.of(context).size;
		final clr = Theme.of(context).colorScheme;

		return MaterialApp(
			title: 'CO-PO-Attainment',
			themeMode: themeMode,
			theme: ThemeData.from(
				colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF031C53))),
			darkTheme: ThemeData.from(
				colorScheme: ColorScheme.fromSeed(
					seedColor: const Color(0xFF031C53), brightness: Brightness.dark)),
			home: Scaffold(
				appBar: buildAppBar(),
				body: Center(
					child: Row(
						mainAxisAlignment: MainAxisAlignment.center,
						children: [
							Container(
								width: scr.width * 0.85,
								height: scr.height * 0.8,
								decoration: BoxDecoration(
									borderRadius: BorderRadius.circular(12),
									border: Border.fromBorderSide(BorderSide(
										color: clr.onPrimary.withAlpha(50), width: 2))),
								child: AnimatedSwitcher(
									duration: const Duration(milliseconds: 500),
									transitionBuilder:
										(Widget child, Animation<double> animation) {
										return FadeTransition(
											opacity: animation,
											child: child,
										);
									},
									child: currentPage(),
								),
							),
							const SizedBox(width: 16),
							SizedBox(height: scr.height * 0.8, child: buildNavButtons(context)),
						],
					),
				),
			),
		);
	}

	/// Builds the app bar with the logo and theme mode switch.
	PreferredSizeWidget buildAppBar() {
		final logo = Image.asset('assets/logo.png',height: 85,fit: BoxFit.cover,alignment: Alignment.centerLeft);
		final banner = Image.asset('assets/banner.png',height: 85,fit: BoxFit.cover,alignment: Alignment.centerRight);
		return AppBar(
			centerTitle: true,
			toolbarHeight: 90,
			title: Row(
				mainAxisAlignment: MainAxisAlignment.center,
				children: [
					logo,
					const Text("CO-PO Attainment Calculator", style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold))
				],
			),
			actions: [
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Reset Preferences"),
                  content: const Text("This will reset ur preferences.\nPreviously entered data will need to be entered again.\nDo you wish to Proceed?"),
                  actions: [
                    TextButton(
                      child: const Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text("Reset"),
                      onPressed: () {
                        SharedPreferences.getInstance().then((prefs) {
                          prefs.clear();
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          tooltip: "Reset all preferences?",
          icon: const Icon(Icons.delete_sweep_outlined),
        ),
        IconButton(
					onPressed: () {
            showAboutDialog(
              context: context,
              applicationIcon: logo,
              applicationName: Constants.appName,
              children: [
                const Text("Developer: Jery"),
                const Text("Excel Calculations: Dr. Vishal"),
                const Text("Affiliation: Jain University"),
              ]
            );
					},
          tooltip: "About",
					icon: const Icon(Icons.info),
				),
				Switch(
					value: themeMode == ThemeMode.dark,
					onChanged: (value) => _toggleThemeMode(),
					thumbIcon: MaterialStateProperty.all<Icon?>(
						Icon(themeMode != ThemeMode.dark
							? Icons.light_mode
							: Icons.dark_mode),
					),
				),
			],
		);
	}

	/// Builds the next button that navigates between pages.
	Widget buildNavButtons(context) {
		return Card(
			child: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				children: [
					Expanded(
						flex: 3,
						child: ElevatedButton(
							style: fluentUiBtn(context),
							onPressed: index < pages.length - 1
								? () {
									if (currentPage().isFilled()) {
										if (index == 2) {
											setState(() => index = 0);
										} else {
											setState(() => ++index);
										}
									}
									}
								: null,
							child: const Icon(Icons.arrow_forward_ios),
						),
					),
					const SizedBox(width: 16),
					Expanded(
						flex: 1,
						child: ElevatedButton(
							style: fluentUiBtn(context),
							onPressed: index > 0
								? () {
										if (index == 0) {
											setState(() => index = 2);
										} else {
											setState(() => --index);
										}
									}
								: null,
							child: const Icon(Icons.arrow_back_ios),
						),
					),
				],
			),
		);
	}
}
