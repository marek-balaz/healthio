//
//  AppDelegate.swift
//  Healthio
//
//  Created by Marek Baláž on 25/10/2024.
//

import UIKit
import Combine

typealias NotificationPayload = [AnyHashable: Any]
typealias FetchCompletion = (UIBackgroundFetchResult) -> Void

final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var appEnvironment: AppEnvironment
    
    override init() {
        self.appEnvironment = AppEnvironment.bootstrap()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        appEnvironment = AppEnvironment.bootstrap()
        
        return true
    }
    
}
