import 'package:amplitude_flutter/amplitude.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Analytics {
  Analytics();

  static FirebaseAnalytics googleAnalytics = FirebaseAnalytics.instance;
  static Amplitude amplitudeAnalytics =
      Amplitude.getInstance(instanceName: "project");

  Future<void> init() async {
    googleAnalytics.setAnalyticsCollectionEnabled(true);
    amplitudeAnalytics.init(dotenv.env['AMPLITUDE_SECRET_API_KEY'] ?? '');
  }

  Future<void> logEvent(
    String name,
    Map<String, dynamic>? parameters,
  ) async {
    //ga
    await googleAnalytics.logEvent(
      name: name,
      parameters: parameters,
    );
    //aa
    await amplitudeAnalytics.logEvent(name, eventProperties: parameters);
    print('log 전송');
  }

  Future<void> logAppOpen() async {
    await googleAnalytics.logAppOpen();
    // await amplitudeAnalytics.logEvent(name, eventProperties: parameters);
  }
}
