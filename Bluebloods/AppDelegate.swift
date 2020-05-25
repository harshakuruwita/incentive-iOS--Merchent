//
//  AppDelegate.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 8/2/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications
import SwiftyJSON
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        IQKeyboardManager.shared.enable = true
        Switcher.updateRootVC()
        registerForPushNotifications()
        return true
       
    }

    
    func applicationWillEnterForeground(_ application: UIApplication) {
    
        let isLogin = UserDefaults.standard.bool(forKey: "isLogin")

              if(isLogin){
                 getIncentiveFilter()
              }else{
                print("not Loged")
              }
        
        
    }
    
    func getIncentiveFilter() {
        
       
        RestClient.makeGetRequstWithToken(url: APPURL.getFilter, delegate: self, requestFinished: #selector(self.requestFinishedFetch), requestFailed: #selector(self.requestFailedfec), tag: 1)
        
    }
    ////////
    
     @objc func requestFinishedFetch(response:ResponseSwift){
         
         do {
             
             let userObj = JSON(response.responseObject!)
             let code = userObj["response"]["code"].intValue
                   print(code)
            if(code == 200){
                
            }else if(code == 401){
              let realm = try! Realm()
                                   try! realm.write {
                                       realm.deleteAll()
                                   }
                                   
                                   UserDefaults.standard.set(false, forKey: "isLogin")
                                   Switcher.updateRootVC()
            }
           
             
            

            
              
         } catch let error {
             print(error)
         }
         
     }

     @objc func requestFailedfec(response:ResponseSwift){
       
     }
    /////
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

  

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    ///
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                [weak self] granted, error in
                guard let self = self else { return }
                print("Permission granted: \(granted)")
                
                guard granted else { return }
                
                // 1
                
                
                // 3
             
                
                self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
         UserDefaults.standard.set(token, forKey: "apnsToken")
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler:
        @escaping (UIBackgroundFetchResult) -> Void) {
        
         print("SS-99")
        
     guard application.applicationState == .active else {
        print("SS-990")
        return }
          
        ///
        ///if let aps = userInfo["aps"] as? NSDictionary {
       if let aps = userInfo["aps"] as? NSDictionary {
        
                if let alert = aps["alert"] as? NSDictionary {
             print(alert)
                } else if let alert = aps["alert"] as? NSString {
                    let alertController = UIAlertController(title: "Message", message: alert as String, preferredStyle: .alert)
                               let okAct = UIAlertAction(title: "Ok", style: .default, handler: nil)
                               alertController.addAction(okAct)
                               self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                               completionHandler(UIBackgroundFetchResult.noData)
                    print(alert)
                }
            }
        ////
        
        
        

    }
    
    
    
 


}

