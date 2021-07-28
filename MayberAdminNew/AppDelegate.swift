//
//  AppDelegate.swift
//  MayberAdminNew
//
//  Created by Airtemium on 18.05.2021.
//

import UIKit
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate//, MessagingDelegate
{
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
//        let initialController = UINavigationController()
//        initialController.setRootWireframe(LoaderWireframe())
//
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        self.window?.rootViewController = initialController
//        self.window?.makeKeyAndVisible()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        let mainController = MainWireframe()

        self.window!.rootViewController = mainController.viewController

        self.window!.makeKeyAndVisible()
        
//        UserExperior.initialize("76338b1c-c45c-48a9-bfcb-9603d01756a4")
        
        //Messaging.messaging().delegate = self
        
        DB.shared.initFirebase()
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication)
    {
        NotificationCenter.default.post(name: Constants.Notify.AppBackground, object: nil)
    }

    func applicationWillEnterForeground(_ application: UIApplication)
    {
        NotificationCenter.default.post(name: Constants.Notify.AppForeground, object: nil)
    }
    
    /*
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        print("APNs token retrieved: \(deviceToken)")

        Messaging.messaging().token { instanceID, error in
            if let instanceID = instanceID
            {

            }
        }
    }
    */
}

