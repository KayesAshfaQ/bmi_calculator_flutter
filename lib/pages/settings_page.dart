import 'package:bmi_calculator/utils/shared_pref_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../components/ripple_view.dart';
import '../constants.dart';
import '../components/reusable_card.dart';
import '../components/unit_selection_widget.dart';
import '../controllers/settings_controller.dart';
import 'about_page.dart';
import 'terms_conditions.dart';

class SettingsPage extends StatefulWidget {
  final Imperial selectedImperial;
  final Metric selectedMetric;
  final void Function(bool)? onSettingsChanged;

  const SettingsPage({
    super.key,
    required this.selectedImperial,
    required this.selectedMetric,
    this.onSettingsChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late SettingsController settingsController;

  bool isUnitChanged = false;

  @override
  void initState() {
    super.initState();
    settingsController = SettingsController();

    // set the selected imperial and metric units
    // add post frame callback to avoid setState() during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        settingsController.selectedImperial = widget.selectedImperial;
        settingsController.selectedMetric = widget.selectedMetric;
      });
    });

    // print log
    debugPrint('args: ${widget.selectedImperial} ${widget.selectedMetric}');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        // call the callback function
        widget.onSettingsChanged?.call(isUnitChanged);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ReusableCard(
                color: kContainerColor,
                cardChild: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text('Units', style: kTextStyleLabel),
                      const Divider(
                        color: kColorLightGrey,
                        thickness: 0.25,
                      ),
                      const SizedBox(height: 8.0),
                      UnitSelectionWidget<Imperial>(
                        label: 'Imperial',
                        icon: FontAwesomeIcons.rulerCombined,
                        items: settingsController.getImperialUnits(),
                        selectedItem: settingsController.selectedImperial,
                        onTap: (val) {
                          // print log
                          debugPrint('Selected Imperial: $val');

                          // update the selected unit
                          setState(() {
                            settingsController.selectedImperial = val;
                          });

                          // show toast message
                          settingsController.showToast('Unit changed to ${settingsController.getImperial()}');

                          // store the selected unit in shared preferences
                          Preference.setString(kKeyImperialValue, settingsController.selectedImperial.toString());

                          // update change flag
                          isUnitChanged = true;
                        },
                      ),
                      const SizedBox(height: 8.0),
                      UnitSelectionWidget<Metric>(
                        label: 'Metric',
                        icon: FontAwesomeIcons.weightScale,
                        items: settingsController.getMetricUnits(),
                        selectedItem: settingsController.selectedMetric,
                        onTap: (val) {
                          // print log
                          debugPrint('Selected Metric: $val');

                          // update the selected unit
                          setState(() {
                            settingsController.selectedMetric = val;
                          });

                          // show toast message
                          settingsController.showToast('Unit changed to ${settingsController.getMetric()}');

                          // store the selected unit in shared preferences
                          Preference.setString(kKeyMetricValue, settingsController.selectedMetric.toString());

                          // update change flag
                          isUnitChanged = true;
                        },
                      )
                    ],
                  ),
                ),
              ),
              ReusableCard(
                color: kContainerColor,
                cardChild: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text('Others', style: kTextStyleLabel),
                      const Divider(
                        color: kColorLightGrey,
                        thickness: 0.25,
                      ),
                      const SizedBox(height: 8.0),
                      settingItem(
                        'Share App',
                        FontAwesomeIcons.share,
                        onTap: settingsController.shareApp,
                      ),
                      settingItem(
                        'Give Review',
                        Icons.rate_review_rounded,
                        onTap: settingsController.rateApp,
                      ),
                      settingItem(
                        'Report Bug',
                        Icons.bug_report,
                        onTap: () => settingsController.reportBug(context),
                      ),
                      settingItem(
                        'About Us',
                        FontAwesomeIcons.circleInfo,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AboutPage(),
                            ),
                          );
                        },
                      ),
                      settingItem(
                        'Privacy Policy',
                        FontAwesomeIcons.shieldHalved,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TermsConditions(
                                url: 'bmi.solobit.dev/privacy_policy.html',
                                title: 'Privacy Policy',
                              ),
                            ),
                          );
                        },
                      ),
                      settingItem(
                        'Terms & Conditions',
                        FontAwesomeIcons.book,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TermsConditions(
                                url: 'bmi.solobit.dev/terms_and_condition.html',
                                title: 'Terms & Conditions',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const Text(
                'Version 1.0.0',
                style: TextStyle(
                  color: kColorLightGrey,
                  fontSize: 12.0,
                ),
              ),
              const SizedBox(height: 12.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget settingItem(String label, IconData icon, {void Function()? onTap}) {
    return RippleView(
      rippleColor: Colors.white,
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            size: 16,
          ),
          const SizedBox(width: 8.0),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
