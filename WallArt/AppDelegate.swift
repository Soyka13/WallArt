//
//  AppDelegate.swift
//  WallArt
//
//  Created by Olena Stepaniuk on 30.05.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ARViewController()
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        return true
    }
    
    
}

