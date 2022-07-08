//
//  RunnerApp.swift
//  WatchRunner WatchKit Extension
//
//  Created by 정창범 on 2022/07/08.
//

import SwiftUI

@main
struct RunnerApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
