//
//  PodcastApp.swift
//  Podcast
//
//  Created by liuliu on 2021/5/27.
//

import SwiftMessages
import SwiftUI

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        application.beginReceivingRemoteControlEvents()
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        application.endReceivingRemoteControlEvents()
    }

    // MARK: - Remote Controls

    override func remoteControlReceived(with event: UIEvent?) {
        super.remoteControlReceived(with: event)
        guard let event = event, event.type == .remoteControl else { return }
        AudioPlayerManager.share.remoteControlReceived(with: event)
    }

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        if ITunesService.share.downloadManager.identifier == identifier {
            ITunesService.share.downloadManager.completionHandler = completionHandler
        }
    }
}

@main
struct PodcastApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onLoad(perform: load)
        }
    }

    func load() {
        _ = FilePath.share
        _ = DB.share
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
