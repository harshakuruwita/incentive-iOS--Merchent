//
//  AppNavigater.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 8/2/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import UIKit

class AppNavigator: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().barTintColor = UIColor(cgColor: UIColor().colour1())
        
        
    }
    
    func changetab(){
        self.selectedIndex = 3
    }
   

}
