import 'dart:math';

import 'settings_controller.dart';

class CalculatorController {
  final int height;
  final int weight;
  final Imperial imperialUnit;
  final Metric metricUnit;
  double _bmi = 0;

  CalculatorController({
    required this.height,
    required this.weight,
    required this.imperialUnit,
    required this.metricUnit,
  });

  String calculateBMI() {
    int height = this.height, weight = this.weight;

    // if imperial unit is ft selected convert it to cm
    if (imperialUnit == Imperial.ft) {
      height = (this.height * 2.54).round();
    }

    // if metric unit is lb selected convert it to kg
    if (metricUnit == Metric.lbs) {
      weight = (this.weight * 0.453592).round();
    }

    _bmi = weight / pow(height / 100, 2);
    return _bmi.toStringAsFixed(1);
  }

  String getResult() {
    if (_bmi > 35) {
      return 'OBESITY';
    } else if (_bmi > 25) {
      return 'OVERWEIGHT';
    } else if (_bmi > 18.5) {
      return 'NORMAL';
    } else {
      return 'UNDERWEIGHT';
    }
  }

  String getInterpretation() {
    if (_bmi > 35) {
      return 'Your BMI indicates obesity. It\'s important to consult with a healthcare provider for personalized advice.';
    } else if (_bmi > 25) {
      return 'You have a higher then normal body weight! Try to exercise more.';
    } else if (_bmi > 18.5) {
      return 'You have normal body weight! Good Job.';
    } else {
      return 'You have lower then normal body weight! You can eat a bit more.';
    }
  }
}
