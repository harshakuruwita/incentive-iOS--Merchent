//
//  ColourManager.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 8/5/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import Foundation
import UIKit



extension UIColor {
    struct FlatColor {
        struct NavigationBar {
        let status = UserDefaults.standard.bool(forKey: "status")
            
            #if (status)
            static let Fern = UIColor(red:0.00, green:0.28, blue:1.00, alpha:1.0)
            #endif
            #if (status)
            static let Fernd = UIColor(red:0.00, green:0.28, blue:1.00, alpha:1.0)
            #endif
  
        }
        
        struct textFieldBorder {
            let status = UserDefaults.standard.bool(forKey: "status")
            
            #if (status)
            static let lineColour = UIColor.red.cgColor
            #endif
            #if (status)
            static let lineColour = UIColor.red.cgColor
            #endif
        }
        
        struct Violet {
          
        }
        
        struct Yellow {
        
        }
        
        struct Orange {
           
        }
        
        struct Red {
           
        }
        
        struct Gray {
           
        }
    }
}
