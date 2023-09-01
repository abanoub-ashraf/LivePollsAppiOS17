//
//  AppDelegate.swift
//  LivePolls
//
//  Created by Abanoub Ashraf on 01/09/2023.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        ///
        /// these settings code is for configuring firebase emulator suit
        ///
        let settings = Firestore.firestore().settings
        settings.host = "127.0.0.1:8080"
        settings.cacheSettings = MemoryCacheSettings()
        settings.isSSLEnabled = false
        Firestore.firestore().settings = settings
        return true
    }
}
