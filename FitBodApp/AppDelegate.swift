//
//  AppDelegate.swift
//  FitBodApp
//
//  Created by Nicholas Della Valle on 6/13/24.
//

import SwiftUI
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        let fitbodNavController = FitBodNavController()
        let hostingVC = UIHostingController(rootView: FitBod1RMListView(delegate: fitbodNavController))
        hostingVC.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        hostingVC.navigationItem.title = "1 Rep Max"
        
        fitbodNavController.viewControllers = [hostingVC]
        
        window.rootViewController = fitbodNavController
        self.window?.makeKeyAndVisible()
        
        return true
    }


}

