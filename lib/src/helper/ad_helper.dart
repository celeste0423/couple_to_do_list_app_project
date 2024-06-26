import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../features/auth/controller/auth_controller.dart';

class AdHelper {
  static String get interstitialAdUnitId {
    if (kReleaseMode) {
      if (Platform.isAndroid) {
        return dotenv.env['ANDROID_AD_UNIT_ID'] ?? '';
      } else {
        return dotenv.env['IOS_AD_UNIT_ID'] ?? '';
      }
    } else {
      if (Platform.isAndroid) {
        return "ca-app-pub-8108254432581538/5301001597"; // Test ad unit ID for Android
      } else {
        return "ca-app-pub-8108254432581538/1158027865"; // Test ad unit ID for iOS
      }
    }
  }

  static InterstitialAd? _interstitialAd;
  static int maxFailedLoadAttempts = 3;
  static int _numInterstitialLoadAttempts = 0;

  static void createInterstitialAd() {
    bool isPremium =
        AuthController.to.group.value.isPremium == true ? true : false;
    print('creating ad');
    if (!isPremium) {
      InterstitialAd.load(
        adUnitId: interstitialAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            print('creating ad : onloaded');
            _interstitialAd = ad;
          },
          onAdFailedToLoad: (err) {
            print('creating ad : failed');
            _interstitialAd = null;
            print(_numInterstitialLoadAttempts);
            _numInterstitialLoadAttempts += 1;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              createInterstitialAd();
            }
            print('Failed to load an interstitial ad: ${err.message}');
          },
        ),
      );
    }
  }

  static void showInterstitialAd() {
    print('start to show ad');
    bool isPremium =
        AuthController.to.group.value.isPremium == true ? true : false;
    print('creating ad');
    if (!isPremium) {
      final storage = GetStorage();
      final lastAdShowTimeMillis =
          storage.read('lastInterstitialAdShowTime') ?? 0;
      final lastAdShowTime =
          DateTime.fromMillisecondsSinceEpoch(lastAdShowTimeMillis);
      final bool canShowAd =
          DateTime.now().difference(lastAdShowTime).inMinutes >= 3;
      if (_interstitialAd == null) {
        print('Warning: attempt to show interstitial before loaded.');
        return;
      }
      if (canShowAd) {
        _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdShowedFullScreenContent: (InterstitialAd ad) {
            print('ad onAdShowedFullScreenContent.');
            storage.write('lastInterstitialAdShowTime',
                DateTime.now().millisecondsSinceEpoch);
          },
          onAdDismissedFullScreenContent: (InterstitialAd ad) {
            print('$ad onAdDismissedFullScreenContent.');
            ad.dispose();
            Get.back();
          },
          onAdFailedToShowFullScreenContent:
              (InterstitialAd ad, AdError error) {
            print('$ad onAdFailedToShowFullScreenContent: $error');
            ad.dispose();
            Get.back();
          },
        );
        _interstitialAd!.show();
      } else {
        print('Ad not shown: Less than 3 minutes since the last ad.');
        Get.back();
      }
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/1712485313";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
