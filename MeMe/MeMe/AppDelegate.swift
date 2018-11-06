//
//  AppDelegate.swift
//  MeMe
//
//  Created by Shruti Choksi on 20/10/18.
//  Copyright (c) 2018 Shruti Choksi. All rights reserved.
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

