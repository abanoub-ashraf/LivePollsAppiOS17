//
//  LivePollsApp.swift
//  LivePolls
//
//  Created by Abanoub Ashraf on 31/08/2023.
//

import SwiftUI

@main
struct LivePollsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
            }
        }
    }
}
