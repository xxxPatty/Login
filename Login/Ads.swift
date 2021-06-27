//
//  Ads.swift
//  Login
//
//  Created by 林湘羚 on 2021/6/13.
//

import GoogleMobileAds
import UIKit

class RewardedAdController: NSObject {
    private var ad: GADRewardedAd?
    //廣告只能顯示一次，要再顯示一次要重新載入
    func loadAd() {
        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: "ca-app-pub-3940256099942544/1712485313", request: request) {ad, error in
            if let error = error {
                print(error)
                return
            }
            ad?.fullScreenContentDelegate = self
            self.ad = ad
            let reward = ad?.adReward
            print("載入廣告")
            print(reward?.amount, reward?.amount.doubleValue)
        }
    }

    func showAd() {
        if let ad = ad, let controller = UIViewController.getLastPresentedViewController() {
            ad.present(fromRootViewController: controller) {
                //觸發獎勵時要做的事
                var myUserDetail = UserDetail(name:"", country: 0, birthday: Date(), gender: "男", chance: 3, start: Date(), photoURL:"", totalPlayingTimes:0, totalWins:0, bestRecord:0, messageBoard:"")
                fetchUserDetail(){ result in
                    switch result {
                    case .success(let userDetail):
                        myUserDetail = userDetail
                        setUserChance(userId: getUserId(), chance: myUserDetail.chance+1)
                    case .failure(let error):
                        break
                    }
                }
                print("獲得獎勵")
            }
        }
    }
}


extension UIViewController {
    static func getLastPresentedViewController() -> UIViewController? {
        let window = UIApplication.shared.windows.first {
            $0.isKeyWindow
        }
        var presentedViewController = window?.rootViewController
        while presentedViewController?.presentedViewController != nil {
            presentedViewController = presentedViewController?.presentedViewController
        }
        return presentedViewController
    }
}

extension RewardedAdController: GADFullScreenContentDelegate {
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        print(#function)
    }
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
//        print(#function)
    }
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
//        print(#function, error)
    }
}
