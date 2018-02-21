//
//  AppDelegate.swift
//  MentalCommand
//
//  Created by Hend Alzahrani on 2/21/18.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        ESTConfig.setupAppID("gp1-f1s", andAppToken:"3026b35466936307526c83684d262765");
        
        return true
    }
}
