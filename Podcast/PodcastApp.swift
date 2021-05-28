//
//  PodcastApp.swift
//  Podcast
//
//  Created by liuliu on 2021/5/27.
//

import SwiftUI
import SwiftMessages

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        application.beginReceivingRemoteControlEvents()
        return true
    }
}

@main
struct PodcastApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(perform: load)
        }
    }

    func load() {
        customUI()
    }

    func customUI() {
        UITextField.appearance().keyboardAppearance = .dark
        SwiftMessages.defaultConfig.presentationContext = .window(windowLevel: .normal)
        SwiftMessages.defaultConfig.preferredStatusBarStyle = .lightContent
    }
}
