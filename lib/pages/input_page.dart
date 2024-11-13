import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bmi_calculator/utils/app_extensions.dart';

import '../controllers/calculator_controller.dart';
import '../components/bottom_button_widget.dart';
import '../components/circle_icon_button.dart';
import '../components/icon_widget.dart';
import '../components/reusable_card.dart';
import '../constants.dart';
import '../controllers/settings_controller.dart';
import '../utils/app_dialogues.dart';
import '../utils/app_helper.dart';
import '../utils/app_package_info_helper.dart';
import '../utils/remote_config_helper.dart';
import '../utils/shared_pref_util.dart';
import 'result_page.dart';
import 'settings_page.dart';

enum Gender { MALE, FEMALE }

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  late Imperial selectedImperial;
  late Metric selectedMetric;
  Gender selectedGender = Gender.MALE;
  late int height;
  int weight = 50;
  int age = 20;

  bool _isAnimationEnable = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // post frame callback to check for force update
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForceUpdate();
    });

    _fetchCachedData();
  }

  // Helper method to compare two semver versions.
  int _getExtendedVersionNumber(String version) {
    List versionCells = version.split('.');
    versionCells = versionCells.map((i) => int.parse(i)).toList();
    return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
  }

  void _checkForceUpdate() async {
    // init req
    final remoteConfig = FirebaseRemoteConfigHelper();
    final packageInfo = AppPackageInfoHelper();
    await packageInfo.initialize();

    // get current app version
    final appVersion = _getExtendedVersionNumber(packageInfo.version);

    // get required minimum version from remote config
    final minRequiredVersion = _getExtendedVersionNumber(remoteConfig.getRequiredMinimumVersion());

    // get recommended minimum version from remote config
    final minRecommendedVersion = _getExtendedVersionNumber(remoteConfig.getRecommendedMinimumVersion());

    if (appVersion < minRequiredVersion) {
      AppDialogues().showUpdateVersionDialog(context, false);
    } else if (appVersion < minRecommendedVersion) {
      AppDialogues().showUpdateVersionDialog(context, true);
    } else {
      // do nothing
      debugPrint('No update required');
    }

    // print log
    debugPrint('App Version: $appVersion');
    debugPrint('Min Required Version: ${remoteConfig.getRequiredMinimumVersion()}');
    debugPrint('Min Recommended Version: ${remoteConfig.getRequiredMinimumVersion()}');
  }

  void _updateUnit(bool isWeight, bool isIncrement) {
    if (isWeight) {
      if (isIncrement) {
        if (selectedMetric == Metric.kg) {
          setState(() {
            if (weight < 200) ++weight;
          });
        } else {
          setState(() {
            if (weight < 440) ++weight;
          });
        }
      } else {
        setState(() {
          if (weight > 0) --weight;
        });
      }
    } else {
      if (isIncrement) {
        setState(() {
          if (age < 150) ++age;
        });
      } else {
        setState(() {
          if (age > 0) --age;
        });
      }
    }
  }

  void _startUpdatingUnit(bool isWeight, bool isIncrement) {
    // disable animation for long press
    setState(() {
      _isAnimationEnable = false;
    });

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _updateUnit(isWeight, isIncrement);
    });
  }

  void _stopUpdatingUnit(_) {
    // enable animation after long press
    setState(() {
      _isAnimationEnable = true;
    });

    _timer?.cancel();
  }

  void _onSettingsChange(bool shouldUpdate) {
    if (shouldUpdate) {
      _fetchCachedData();

      // update state
      setState(() {});
    }
  }

  void _fetchCachedData() {
    // get imperial and metric values from shared preferences
    selectedImperial = Imperial.values.firstWhere((element) => element.toString() == Preference.getString(kKeyImperialValue), orElse: () => Imperial.ft);
    selectedMetric = Metric.values.firstWhere((element) => element.toString() == Preference.getString(kKeyMetricValue), orElse: () => Metric.kg);

    // print log
    debugPrint('Imperial: $selectedImperial');
    debugPrint('Metric: $selectedMetric');

    // set height value
    height = selectedImperial == Imperial.cm ? 170 : 48;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 600) {
          return _buildLandscapeLayout();
        } else {
          return _buildPortraitLayout();
        }
      },
    );
  }

  Widget _buildPortraitLayout() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            // pass data to settings page using arguments
            onPressed: () {
              AppHelper.pushWithAnimation<void>(
                context,
                SettingsPage(
                  selectedImperial: selectedImperial,
                  selectedMetric: selectedMetric,
                  onSettingsChanged: _onSettingsChange,
                ),
              );
            },
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: genderCard(
                    gender: Gender.MALE,
                    icon: Icons.male,
                  ),
                ),
                Expanded(
                  child: genderCard(
                    gender: Gender.FEMALE,
                    icon: Icons.female,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ReusableCard(
              color: kContainerColor,
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('HEIGHT', style: kTextStyleLabel),
                  selectedImperial == Imperial.cm
                      ? Row(
                          textBaseline: TextBaseline.alphabetic,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          children: [
                            Text(height.toString(), style: kTextStyleNumber),
                            Text(selectedImperial.value, style: kTextStyleLabel),
                          ],
                        )
                      : Row(
                          textBaseline: TextBaseline.alphabetic,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, animation) => FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                              child: Text(
                                (height / 12).floor().toString(),
                                key: ValueKey<int>((height / 12).floor()),
                                style: kTextStyleNumber,
                              ),
                            ),
                            const Text('ft', style: kTextStyleLabel),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, animation) => FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                              child: Text(
                                (height % 12).toString(),
                                key: ValueKey<int>((height % 12).floor()),
                                style: kTextStyleNumber,
                              ),
                            ),
                            const Text('in', style: kTextStyleLabel),
                          ],
                        ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 2.0,
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: kColorLightGrey,
                      thumbColor: kColorBottomContainer,
                      overlayColor: const Color(0x29FF0067),
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
                      trackShape: const RectangularSliderTrackShape(),
                    ),
                    child: selectedImperial == Imperial.cm
                        ? Slider(
                            value: height.toDouble(),
                            min: 30,
                            max: 340,
                            onChanged: (double newValue) {
                              setState(() {
                                height = newValue.round();
                              });
                            },
                          )
                        : Slider(
                            value: height.toDouble(),
                            min: 12.0,
                            max: 120.0,
                            onChanged: (double newValue) {
                              setState(() {
                                height = newValue.round();
                              });
                            },
                          ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ReusableCard(
                    color: kContainerColor,
                    cardChild: weightColumn(),
                  ),
                ),
                Expanded(
                  child: ReusableCard(
                    color: kContainerColor,
                    cardChild: ageColumn(),
                  ),
                ),
              ],
            ),
          ),
          BottomButtonWidget(
            label: 'CALCULATE',
            suffixIcon: FontAwesomeIcons.arrowRight,
            onTap: () {
              CalculatorController calculator = CalculatorController(
                height: height,
                weight: weight,
                imperialUnit: selectedImperial,
                metricUnit: selectedMetric,
              );

              AppHelper.pushWithAnimation(
                context,
                ResultPage(
                  bmiResult: calculator.calculateBMI(),
                  resultText: calculator.getResult(),
                  interpolation: calculator.getInterpretation(),
                ),
                isTransitionVertical: true,
              );
            },
          )
        ],
      ),
    );
  }

  Builder genderCard({
    required Gender gender,
    required IconData icon,
  }) {
    return Builder(builder: (context) {
      bool isSelected = gender == selectedGender;

      return ReusableCard(
        cardChild: IconWidget(icon: icon, label: gender.toString().toUpperCase()),
        color: isSelected ? kColorActiveCard : kColorInActiveCard,
        border: isSelected ? Border.all(color: kColorBottomContainer, width: 2.0) : null,
        onPress: () {
          setState(() {
            selectedGender = gender;
          });
        },
      );
    });
  }

  Widget _buildLandscapeLayout() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            // pass data to settings page using arguments
            onPressed: () {
              AppHelper.pushWithAnimation<void>(
                context,
                SettingsPage(
                  selectedImperial: selectedImperial,
                  selectedMetric: selectedMetric,
                  onSettingsChanged: _onSettingsChange,
                ),
              );
            },
          )
        ],
      ),
      // endDrawer: const DrawerWidget(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Add your widgets here for the left side of the landscape layout
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Add your widgets here for the right side of the landscape layout
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget weightColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('WEIGHT', style: kTextStyleLabel),
        _isAnimationEnable
            ? AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: child,
                ),
                child: RichText(
                  key: ValueKey(weight),
                  text: TextSpan(
                    children: [
                      TextSpan(text: weight.toString(), style: kTextStyleNumber),
                      TextSpan(
                        text: ' ${selectedMetric.value}',
                        style: kTextStyleLabel.copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              )
            : RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: weight.toString(), style: kTextStyleNumber),
                    TextSpan(
                      text: ' ${selectedMetric.value}',
                      style: kTextStyleLabel.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleIconButton(
              icon: FontAwesomeIcons.minus,
              onPress: () => _updateUnit(true, false),
              onLongPress: () => _startUpdatingUnit(true, false),
              onLongPressEnd: _stopUpdatingUnit,
            ),
            const SizedBox(width: 8.0),
            CircleIconButton(
              icon: FontAwesomeIcons.plus,
              onPress: () => _updateUnit(true, true),
              onLongPress: () => _startUpdatingUnit(true, true),
              onLongPressEnd: _stopUpdatingUnit,
            ),
          ],
        )
      ],
    );
  }

  Widget ageColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('AGE', style: kTextStyleLabel),
        _isAnimationEnable
            ? AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: child,
                ),
                child: Text(
                  key: ValueKey(age),
                  age.toString(),
                  style: kTextStyleNumber,
                ),
              )
            : Text(
                age.toString(),
                style: kTextStyleNumber,
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleIconButton(
              icon: FontAwesomeIcons.minus,
              onPress: () => _updateUnit(false, false),
              onLongPress: () => _startUpdatingUnit(false, false),
              onLongPressEnd: _stopUpdatingUnit,
            ),
            const SizedBox(width: 8.0),
            CircleIconButton(
              icon: FontAwesomeIcons.plus,
              onPress: () => _updateUnit(false, true),
              onLongPress: () => _startUpdatingUnit(false, true),
              onLongPressEnd: _stopUpdatingUnit,
            ),
          ],
        )
      ],
    );
  }
}
