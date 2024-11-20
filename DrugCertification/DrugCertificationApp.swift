//
//  DrugCertificationApp.swift
//  DrugCertification
//
//  Created by 植松優羽 on 2024/11/05.
//

import SwiftUI

@main
struct DrugCertificationApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate // AppDelegateを利用

    @State private var receivedData: String? // 受け取ったデータを保持

    var body: some Scene {
        WindowGroup {
            ContentView(receivedData: $receivedData)
                .onOpenURL { url in
                    if url.scheme == "myapp" {
                        receivedData = url.host // URLのホスト部分を取得
                    }
                }
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        NotificationCenter.default.post(name: .didReceiveWebData, object: url.host)
        return true
    }
}

extension Notification.Name {
    static let didReceiveWebData = Notification.Name("didReceiveWebData")
}
