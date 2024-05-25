import 'package:flutter/material.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import 'local_storage.dart';


class AdManager {
  static Future<void> init()async{
    await UnityAds.init(
      gameId: '5135347',
      onComplete: () => debugPrint('Initialization Complete'),
      onFailed: (error, message) =>
          debugPrint('Initialization Failed: $error $message'),
    );
  }



  static Future<void> loadUnityIntAd() async {

    if(LocalStorage.getUnityAdStatus()) {
      await UnityAds.load(
      placementId: 'Interstitial_Android',
      onComplete: (placementId) => debugPrint('Load Complete $placementId'),
      onFailed: (placementId, error, message) =>
          debugPrint('Load Failed $placementId: $error $message'),
    );
    }
  }

  static Future<void> loadUnityRewardedAd() async {
    if(LocalStorage.getUnityAdStatus()) {
      await UnityAds.load(
      placementId: 'Rewarded_Android',
      onComplete: (placementId) => debugPrint('Load Complete $placementId'),
      onFailed: (placementId, error, message) =>
          debugPrint('Load Failed $placementId: $error $message'),
    );
    }
  }

  // static Future<void> loadUnityBannerAd() async {
  //   await UnityAds.load(
  //     placementId: 'Banner_Android',
  //     onComplete: (placementId) => debugPrint('Load Complete $placementId'),
  //     onFailed: (placementId, error, message) =>
  //         debugPrint('Load Failed $placementId: $error $message'),
  //   );
  // }

  static Future<void> showIntAd() async {
    if(LocalStorage.getUnityAdStatus()) {
      UnityAds.showVideoAd(
        placementId: 'Interstitial_Android',
        onStart: (placementId) => debugPrint('Video Ad $placementId started'),
        onClick: (placementId) => debugPrint('Video Ad $placementId click'),
        onSkipped: (placementId) => debugPrint('Video Ad $placementId skipped'),
        onComplete: (placementId) async {
          await loadUnityIntAd();
        },
        onFailed: (placementId, error, message) async {
          await loadUnityIntAd();
        });
    }
  }

  static Future<void> showRewardedAd() async {
    if(LocalStorage.getUnityAdStatus()) {
      UnityAds.showVideoAd(
        placementId: 'Rewarded_Android',
        onStart: (placementId) => debugPrint('Video Ad $placementId started'),
        onClick: (placementId) => debugPrint('Video Ad $placementId click'),
        onSkipped: (placementId) => debugPrint('Video Ad $placementId skipped'),
        onComplete: (placementId) async {
          await loadUnityRewardedAd();
        },
        onFailed: (placementId, error, message) async {
          await loadUnityRewardedAd();
        });
    }
  }

  // static Widget showBannerAd(){
  //   return UnityBannerAd(
  //     placementId: "Banner_Android",
  //     onClick: (placementId) => debugPrint('Video Ad $placementId click'),
  //     onFailed: (placementId, error, message) async {
  //       await loadUnityBannerAd();
  //     },
  //     onLoad: (value) async{
  //       await loadUnityBannerAd();
  //       debugPrint(value);
  //     }
  //   );
  // }
}