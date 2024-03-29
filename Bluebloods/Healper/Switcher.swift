//
//  Switcher.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 8/2/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import UIKit

class Switcher {
    
    static func updateRootVC(){
        
        let isLogin = UserDefaults.standard.bool(forKey: "isLogin")
        var rootVC : UIViewController?
        
    
        
        
        if(isLogin){
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AppNavigator") as! AppNavigator
        }else{
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserNavigator") as! UserNavigator
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
        
    }
    
}
