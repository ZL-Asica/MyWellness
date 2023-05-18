//
//  MyWellnessApp.swift
//  MyWellness
//
//  Created by ZL Asica on 5/4/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

@main
struct MyWellnessApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
