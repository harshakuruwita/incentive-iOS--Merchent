//
//  URLConstants.swift
//  Bluebloods
//
//  Created by Harsha Kuruwita on 8/26/19.
//  Copyright © 2019 Bluebloods. All rights reserved.
//

import Foundation

struct APPURL {
    
    private struct Domains {
        static let Globaluri = "https://www.dev.linkedassets.com"
        static let Localuri = "http://192.168.1.106:8080/api/v1/"
     
    }
    
    
    private  static let GlobalDomain = Domains.Globaluri
    private  static let LocalDomain = Domains.Localuri
  
    
    
    static var userAuthLogin: String {
        return LocalDomain  + "auth/mobile/token"
    }
    
    
    
}
