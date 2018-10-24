//
//  AppDelegate.swift
//  MeMe
//
//  Created by Shruti Pawar on 14/03/15.
//  Copyright (c) 2015 ShapeMyApp Software Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var memes = [Meme]()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Style the navigation bar, tool bar and tab bar
        let barcolors = UIColor(red: 126 / 266, green: 43 / 266, blue: 144 / 266, alpha: 1.0)
        UINavigationBar.appearance().barTintColor = barcolors
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UIToolbar.appearance().tintColor = barcolors
        UIApplication.shared.statusBarStyle =  .lightContent
        UITabBar.appearance().barTintColor = barcolors
        UITabBar.appearance().tintColor = UIColor.white
        
        return true
    }
}

