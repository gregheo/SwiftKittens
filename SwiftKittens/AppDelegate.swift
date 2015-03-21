//
//  AppDelegate.swift
//  SwiftKittens
//
//  Created by Greg Heo on 2015-03-15.
//
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    let window = UIWindow(frame: UIScreen.mainScreen().bounds)
    window.rootViewController = ViewController()
    window.makeKeyAndVisible()

    self.window = window

    return true
  }

}

