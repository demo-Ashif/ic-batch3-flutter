import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ic_batch3_flutter_classes/ad_unit_ids.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  bool _isInterstitialReady = false;
  bool _isRewardedReady = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadBannerAd();
    _loadInterstitialAd();
    _loadRewardedAd();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    super.dispose();
  }

  void _loadBannerAd() {
    final ad = BannerAd(
      size: AdSize.banner,
      adUnitId: bannerUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => _bannerAd = ad as BannerAd),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('Banner failedToLoad: $error');
        },
      ),
      request: AdRequest(),
    );

    ad.load();
  }

  String get bannerUnitId =>
      Platform.isAndroid
          ? AdUnitIds.bannerAndroidAdUnitId
          : AdUnitIds.bannerIosAdUnitId;

  String get interstitialUnitId =>
      Platform.isAndroid
          ? AdUnitIds.interstitialAndroidUnitId
          : AdUnitIds.interstitialIosUnitId;

  String get rewardedUnitId =>
      Platform.isAndroid
          ? AdUnitIds.rewardAndroidUnitId
          : AdUnitIds.rewardIosUnitId;

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialReady = true;
          _interstitialAd!.setImmersiveMode(true);
          _interstitialAd!
              .fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isInterstitialReady = false;
              _loadInterstitialAd(); // preload next
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _isInterstitialReady = false;
              _loadInterstitialAd();
            },
          );
          setState(() {});
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial failedToLoad: $error');
          _isInterstitialReady = false;
          setState(() {});
        },
      ),
    );
  }

  void _showInterstitial() {
    if (_isInterstitialReady && _interstitialAd != null) {
      _interstitialAd!.show();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Interstitial not ready yet')),
      );
      _loadInterstitialAd();
    }
  }

  /// Rewarded ad load and show
  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardedUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedReady = true;
          _rewardedAd!.setImmersiveMode(true);
          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isRewardedReady = false;
              _loadRewardedAd(); // preload next
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _isRewardedReady = false;
              _loadRewardedAd();
            },
          );
          setState(() {});
        },
        onAdFailedToLoad: (error) {
          debugPrint('Rewarded failedToLoad: $error');
          _isRewardedReady = false;
          setState(() {});
        },
      ),
    );
  }

  void _showRewarded() {
    if (_isRewardedReady && _rewardedAd != null) {
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          // Here you can credit the user (e.g., coins, features, etc.)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Reward earned: ${reward.amount} ${reward.type}',
              ),
            ),
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rewarded ad not ready yet')),
      );
      _loadRewardedAd();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admob Demo')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.shop),
        onPressed: () {
          _showInterstitial();
        },
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              if (_bannerAd != null)
                SizedBox(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              SizedBox(height: 24,),
              FilledButton(onPressed: _isRewardedReady? _showRewarded:null, child: Text(
                _isRewardedReady?'Show Reward':'Loading Reward ...'
              ))
            ],
          ),
        ),
      ),
    );
  }
}
