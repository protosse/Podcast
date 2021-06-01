//
//  PodcastApp.swift
//  Podcast
//
//  Created by liuliu on 2021/5/27.
//

import SwiftMessages
import SwiftUI

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

        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = R.color.defaultBackground()
    }
}
