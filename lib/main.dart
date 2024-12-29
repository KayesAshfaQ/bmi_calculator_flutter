import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'constants.dart';
import 'firebase_options.dart';
import 'pages/input_page.dart';
import 'utils/crashlytics_helper.dart';
import 'utils/remote_config_helper.dart';
import 'utils/shared_pref_util.dart';

void main() async {
  // ensure binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // load shared preferences
  await Preference.load();

  // initialize firebase app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // initialize remote config
  await FirebaseRemoteConfigHelper.initialize();

  // initialize crashlytics
  await CrashlyticsHelper.initCrashlytics();

  return runApp(const BMICalculator());
}

class BMICalculator extends StatelessWidget {
  const BMICalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _createAppTheme(),
      home: const InputPage(),
    );
  }

  ThemeData _createAppTheme() {
    final base = ThemeData.dark(useMaterial3: true);

    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: kColorPrimary,
        secondary: kColorBottomContainer,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: kColorPrimary,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 20.0,
        ),
      ),
      scaffoldBackgroundColor: kColorPrimary,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: kColorBottomContainer,
        selectionColor: kColorBottomContainer.withOpacity(0.25),
        selectionHandleColor: kColorBottomContainer,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(
          color: kColorLightGrey,
        ),
        floatingLabelStyle: TextStyle(
          color: kColorBottomContainer,
        ),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kColorBottomContainer),
        ),
      ),
      dialogTheme: const DialogTheme(
        backgroundColor: kContainerColor,
      ),
    );
  }
}
