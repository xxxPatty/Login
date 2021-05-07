//
//  LoginApp.swift
//  Login
//
//  Created by 林湘羚 on 2021/4/14.
//

import SwiftUI
import FacebookCore

@main
struct LoginApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL(perform: { url in
                    ApplicationDelegate.shared.application(UIApplication.shared, open: url, sourceApplication: nil, annotation: UIApplication.OpenURLOptionsKey.annotation)
                })
        }
    }
}
