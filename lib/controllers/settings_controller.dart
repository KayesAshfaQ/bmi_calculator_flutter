import 'package:bmi_calculator/utils/app_dialogues.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';

enum Imperial { ft, cm }

enum Metric { lbs, kg }

class SettingsController {
  Imperial selectedImperial = Imperial.ft;
  Metric selectedMetric = Metric.kg;

  void setImperial(Imperial imperial) {
    selectedImperial = imperial;
  }

  void setMetric(Metric metric) {
    selectedMetric = metric;
  }

  String getImperial() {
    return selectedImperial.toString().split('.').last.toUpperCase();
  }

  String getMetric() {
    return selectedMetric.toString().split('.').last.toUpperCase();
  }

  // get all imperial units
  List<Imperial> getImperialUnits() {
    return Imperial.values;
  }

  // get all metric units
  List<Metric> getMetricUnits() {
    return Metric.values;
  }

  void showToast(String message) {
    // cancel previous toast if available
    Fluttertoast.cancel();

    // shows new toast
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: kColorBottomContainer,
    );
  }

  void shareApp() {
    // share app
    Share.share('Check out this awesome BMI Calculator app! Download it now from https://play.google.com/store/apps/details?id=$kConfigAppPackageName');
  }

  void rateApp() {
    final InAppReview inAppReview = InAppReview.instance;
    inAppReview.openStoreListing();
  }

  void reportBug(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final detailsController = TextEditingController();

    AppDialogues().showReportBugDialog(
      context,
      formKey: formKey,
      titleController: titleController,
      descriptionController: detailsController,
      onPressedReport: () {
        if (formKey.currentState!.validate()) {
          // send email
          final Uri emailLaunchUri = Uri(
            scheme: 'mailto',
            path: 'dev.solobit@gmail.com',
            query: 'subject=${Uri.encodeComponent(titleController.text)}&body=${Uri.encodeComponent(detailsController.text)}',
          );
          launchUrl(emailLaunchUri);
        }
      },
    );
  }
}
