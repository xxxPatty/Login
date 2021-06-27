//
//  AppDelegate.swift
//  Login
//
//  Created by 林湘羚 on 2021/4/14.
//

import UIKit
import Firebase
import FacebookCore
import GoogleSignIn
import AVFoundation
import GoogleMobileAds

class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        // Override point for customization after application launch.
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // 1
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        // 2
        GIDSignIn.sharedInstance().delegate = self
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        AVPlayer.setupBgMusic()
        AVPlayer.bgQueuePlayer.play()
        print("launch")
        
        return true
    }
}

//Google sign in
extension AppDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            print("google login ok")
            NotificationCenter.default.post(name: Notification.Name("GoogleSignInSuccess"), object: nil)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
        print("disconnects from app with google sign in")
    }
}



